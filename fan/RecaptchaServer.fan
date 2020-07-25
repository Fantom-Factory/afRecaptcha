using afIoc::Inject
using afIocConfig::Config
using afDuvet::HtmlInjector
using web::WebClient
using util::JsonInStream

**
** To edit or view your reCAPTCHA account, visit `https://www.google.com/recaptcha/admin/`.
** 
const class RecaptchaServer {
	@Inject private const HtmlInjector	injector
	@Inject	private const Log			log
	@Config { id="afRecaptcha.verifyUrl" }
			private const Uri			verifyUrl
	@Config { id="afRecaptcha.secretKey" }
			private const Str			secretKey
	@Config { id="afRecaptcha.enabled" }
			private const Bool			enabled
	
	new make(|This| f) { f(this) }
	
	Void setupCaptcha() {
		if (!enabled) return
		
		injector.injectScript.withScript(
		"""function afRecaptchaOnLoadCallback() { 
		    if (typeof afRecaptcha === "undefined") afRecaptcha = {};
		    afRecaptcha.loaded = true;
		    if (afRecaptcha.instance != null)
		        afRecaptcha.instance.onLoad();
		   }"""
		)
		injector.injectScript.fromExternalUrl(`https://www.google.com/recaptcha/api.js?render=explicit&onload=afRecaptchaOnLoadCallback`).async.defer
	}

	Bool verifyCaptcha(Str? response, Bool checked := true) {
		resp := null as Str:Obj?
		
		if (response?.trimToNull == null)
			return !checked ? false : throw Err("No reCAPTCHA given")

		if (enabled) {
			json := WebClient(verifyUrl).postForm([
				"secret"	: secretKey,
				"response"	: response ?: ""
			]).resStr
			resp = JsonInStream(json.in).readJson
			
		} else {
			resp = ["success" : response != "<fail>"]
			if (response == "<error>")
				resp["error-codes"] = "afRecaptcha-test-error"
			log.info("Recaptcha Stub - " + (resp["success"] ? "Success!" : "Fail") + " - $response")
		}

		if (resp.containsKey("error-codes") && resp["error-codes"] != null)
			// error codes aren't a 500 from Google, but things like
			// Bad reCAPTCHA response - [timeout-or-duplicate]
			return !checked ? false : throw Err("Bad reCAPTCHA response - " + resp["error-codes"])
		
		success := resp["success"]
		if (!success && checked)
			throw Err("reCAPTRUE failed")
		return success
	}
}
