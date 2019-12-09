
fan.afRecaptcha.RecaptchaClientPeer = fan.sys.Obj.$extend(fan.sys.Obj);

fan.afRecaptcha.RecaptchaClientPeer.prototype.$ctor = function(self) {}

fan.afRecaptcha.RecaptchaClientPeer.prototype.iAmHere = function(self) {
	if (typeof afRecapture === "undefined") afRecapture = {};
	afRecapture.instance = self;
}

fan.afRecaptcha.RecaptchaClientPeer.prototype.hasLoaded = function(self) {
	if (typeof afRecapture === "undefined") afRecapture = {};
	return afRecapture.loaded == true;
}

fan.afRecaptcha.RecaptchaClientPeer.prototype.doRender = function(self, containerId, fanParams) {
	var params = {};
	if (fanParams != null)
		fanParams.$each(function(b) {
			params[b.key] = b.val;
		});

	var widgetId;
	params.callback = function(response) {
		self.widgetResponses().set(widgetId, response);
	};

	widgetId = grecaptcha.render(containerId, params);
	return widgetId;
}

fan.afRecaptcha.RecaptchaClientPeer.prototype.doReset = function(self, widgetId) {
	grecaptcha.reset(widgetId);
}
