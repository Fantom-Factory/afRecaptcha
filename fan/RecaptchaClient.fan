using dom::Win

@Js class RecaptchaClient {
	private Bool	enabled
	private Str		siteKey
	private |->|[]	messageQueue	:= |->|[,]
	private Str:Int	widgetIds		:= Str:Int[:]
	private Int:Str	widgetResponses	:= Int:Str[:]

	new make(Str siteKey, Bool enabled) {
		this.enabled = enabled
		this.siteKey = siteKey
		if (enabled) iAmHere
	}
	
	** theme, type, size, tabindex
	** callback, expired-callback, error-callback not supported
	** 
	** No need to add sitekey
	** Themes: normal =  304px x78px
	**         compact = 164px x 144px
	** 
	** What's returned is NOT the google widget id
	** 
	** See [grecaptcha.render parameters]`https://developers.google.com/recaptcha/docs/display#render_param` for details.
	Str render(Str containerId, [Str:Obj?]? params := null) {
		if (!enabled)
			return "<recaptcha-not-enabled>"
		myId := genId
		call |->| {
			gooId := doRender(containerId, ["sitekey" : siteKey].setAll(params ?: [:]))
			widgetIds[myId] = gooId
		}
		return myId
	}
	
	Void reset(Str widgetId) {
		if (enabled)
			call |->| { doReset(widgetIds[widgetId]) }		
	}
	
	Str? getResponse(Str widgetId) {
		if (!enabled)
			return "<recaptcha-not-enabled>"
		if (!hasLoaded)
			throw Err("Google reCAPTCHA has not loaded")
		return widgetResponses[widgetIds[widgetId]]
	}
	
	private Void call(|->| func) {
		if (hasLoaded)
			func()
		else
			messageQueue.add(func)		
	}
	
	private Void onLoad() {
		while (messageQueue.size > 0) {
			messageQueue.removeAt(0).call()
		}
	}
	
	private Int _lastGenIdTime
	private Str genId() {
		// 2.pow(32) / 1000ms / 60 sec / 60 min / 24 hour ~~ 50 days --> and no one will over need more than 48K of RAM
		time := DateTime.nowTicks / 1ms.ticks
		if (time < _lastGenIdTime)
			time = _lastGenIdTime++
		_lastGenIdTime = time
		time  = time.and(0xffff_ffff)
		rand := Int.random.and(0xffff_ffff)
		return StrBuf(17).add(time.toHex(8)).addChar('-').add(rand.toHex(8)).toStr
	}
	
	private native Void iAmHere()
	private native Bool hasLoaded()
	private native Int  doRender(Str containerId, [Str:Obj?]? params := null)
	private native Void doReset(Int widgetId)
}
