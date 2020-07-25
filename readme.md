# Google ReCAPTCHA v0.0.4
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](https://fantom-lang.org/)
[![pod: v0.0.4](http://img.shields.io/badge/pod-v0.0.4-yellow.svg)](http://eggbox.fantomfactory.org/pods/afRecaptcha)
[![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)](https://choosealicense.com/licenses/isc/)

## Overview

*Google ReCAPTCHA is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Client and Server code to process Google reCAPTCHA responses.

Requires a Google account and reCAPTCHA to be configured on the Admin screen. See:

* [Google reCAPTCHA Docs](https://developers.google.com/recaptcha)
* [Google reCAPTCHA Admin](https://www.google.com/recaptcha/admin/)


## <a name="Install"></a>Install

Install `Google ReCAPTCHA` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afRecaptcha

Or install `Google ReCAPTCHA` with [fanr](https://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afRecaptcha

To use in a [Fantom](https://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afRecaptcha 0.0"]

## <a name="documentation"></a>Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afRecaptcha/) - the Fantom Pod Repository.

## Quick Start

Client side code:

    using afRecaptcha::RecaptchaClient
    
    ...
    
    siteKey     := "..."    // siteKey = your unique Google reCAPTCHA key
    enabled     := true     // enabled = false to disable reCAPTCHA during dev
    recaptcha   := RecaptchaClient(siteKey, enabled)
    
    ...
    
    containerId := "divId"  // id of where reCAPTCHA is to be rendered
    recaptchaId := recaptcha.render(containerId)
    
    ...
    
    response    := recaptcha.getResponse(recaptchaId)
    if (response == null)
        Win.cur.alert("If you're a human, complete the captcha!")
    else
        // set a hidden form value to send response to the Server
        doc.elemById("recaptchaInput").setAttr("value", response)
    

Then when processing form values on the server:

    using afIoc::Inject
    using afBedSheet::HttpRequest
    using afEfanXtra::BeforeRender
    using afRecaptcha::RecaptchaServer
    ...
    
    @Inject const HttpRequest      httpReq
    @Inject const RecaptchaServer  recaptcha
    
    @BeforeRender
    Void onBeforeRender() {
        // inject Google reCAPTCHA scripts into the page
        recaptcha.setupCaptcha()
    }
    
    Void onProcessForm() {
        // grab the reCAPTCHA response from the form
        response := httpReq.body.form["recaptchaInput"]
    
        // verify it with Google
        success  := recaptcha.verifyCaptcha(response, false)
        if (success == false)
            throw Err("reCAPTRUE failed")
    }
    

