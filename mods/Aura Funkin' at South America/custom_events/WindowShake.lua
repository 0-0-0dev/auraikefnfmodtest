require "math"

function onCreate()
	wasScreen = getPropertyFromClass('openfl.Lib', 'application.window.fullscreen')
	setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)

	oldwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
	oldwindY = getPropertyFromClass("openfl.Lib", "application.window.y")
	curwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
	curwindY = getPropertyFromClass("openfl.Lib", "application.window.y")

	winShakeStatus = 'none'
	winDone = false

	makeLuaText('dummyWin', '', 1, 0, 0)
	addLuaText('dummyWin')
end

function onEvent(name, value1, value2)
	if name == "WindowShake" then
		curwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
		curwindY = getPropertyFromClass("openfl.Lib", "application.window.y")
		winIntensity = value1
		if string.find(value2,',') then
			string = value2
			split = string:split(",")
			winShakeTime = tonumber(split[1])
			winFadeTime = tonumber(split[2])
		else
			winShakeTime = tonumber(value2)
			winFadeTime = 'none'
		end
		winDone = false
		winShakeStatus = 'start'
		setProperty('dummyWin.x', winIntensity)
		runTimer('winTime', winShakeTime, 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'winTime' then
		winDone = true
	end
end

function onUpdate()
	if winShakeStatus == 'start' then
		setPropertyFromClass("openfl.Lib", "application.window.x", curwindX + math.random(0 - winIntensity, winIntensity))
		setPropertyFromClass("openfl.Lib", "application.window.y", curwindY + math.random(0 - winIntensity, winIntensity))

		if winDone then
			if winFadeTime == 'none' then
				setPropertyFromClass("openfl.Lib", "application.window.x", curwindX)
				setPropertyFromClass("openfl.Lib", "application.window.y", curwindY)
				winShakeStatus = 'none'
			else
				winDone = false
				winShakeStatus = 'fade'
				doTweenX('dummyWinTween', 'dummyWin', 0, winFadeTime, linear)
				runTimer('winTime', winFadeTime, 1)
			end
		end

	elseif winShakeStatus == 'fade' then
		setPropertyFromClass("openfl.Lib", "application.window.x", curwindX + math.random(0 - winIntensity, winIntensity))
		setPropertyFromClass("openfl.Lib", "application.window.y", curwindY + math.random(0 - winIntensity, winIntensity))
		winIntensity = getProperty('dummyWin.x')
		if winDone then
			winShakeStatus = 'none'
			setPropertyFromClass("openfl.Lib", "application.window.x", curwindX)
			setPropertyFromClass("openfl.Lib", "application.window.y", curwindY)
		end
	else
	end
end

function onDestroy()
	setPropertyFromClass("openfl.Lib", "application.window.x", oldwindX)
	setPropertyFromClass("openfl.Lib", "application.window.y", oldwindY)
	setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', wasScreen)
end

function string:split(inSplitPattern, outResults)
	if not outResults then
		outResults = { }
	end
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
	while theSplitStart do
		table.insert(outResults, string.sub(self, theStart, theSplitStart - 1))
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
	end
	table.insert(outResults, string.sub(self, theStart))
	return outResults
end