using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afRecaptcha"
		summary = "Client and Server code to process Google reCAPTCHA responses"
		version = Version("0.0.5")

		meta = [
			"pod.dis"		: "Google ReCAPTCHA",
			"repo.tags"		: "web",
			"repo.public"	: "true",
			"repo.internal"	: "true",
			"afIoc.module"	: "afRecaptcha::RecaptchaModule"
		]

		depends = [
			// ---- Fantom Core -----------------
			"sys          1.0.73 - 1.0",
			"dom          1.0.73 - 1.0",
			"web          1.0.73 - 1.0",
			"util         1.0.73 - 1.0",

			// ---- Fantom Factory Core ---------
			"afIoc        3.0.8  - 3.0",
			"afIocConfig  1.1.0  - 1.1",

			// ---- Fantom Factory Web ----------
			"afDuvet      1.1.8  - 1.1",
		]

		srcDirs = [`fan/`, `test/`]
		resDirs = [`doc/`]
		jsDirs  = [`js/`]
	}
}
