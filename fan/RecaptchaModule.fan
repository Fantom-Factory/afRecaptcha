using afIoc::Contribute
using afIoc::Configuration
using afIoc::RegistryBuilder
using afIocConfig::FactoryDefaults

const class RecaptchaModule {
	
	Void defineServices(RegistryBuilder bob) {
		bob.addService(RecaptchaServer#)
	}
	
	@Contribute { serviceType=FactoryDefaults# }
	Void contributeFactoryDefaults(Configuration config) {
		config["afRecaptcha.enabled"]	= false
		config["afRecaptcha.verifyUrl"]	= `https://www.google.com/recaptcha/api/siteverify`
		config["afRecaptcha.siteKey"]	= "XXXX"
		config["afRecaptcha.secretKey"]	= "XXXX"
	}
}
