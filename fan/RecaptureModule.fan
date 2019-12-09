using afIoc::Contribute
using afIoc::Configuration
using afIoc::RegistryBuilder
using afIocConfig::FactoryDefaults

const class RecaptureModule {
	
	Void defineServices(RegistryBuilder bob) {
		bob.addService(RecaptchaServer#)
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	Void contributeFactoryDefaults(Configuration config) {
		config["afRecapture.enabled"]	= false
		config["afRecapture.verifyUrl"]	= `https://www.google.com/recaptcha/api/siteverify`
		config["afRecapture.siteKey"]	= "XXXX"
		config["afRecapture.secretKey"]	= "XXXX"
	}
}
