require "math"

function onCreate()
	wasScreen = getPropertyFromClass('openfl.Lib', 'application.window.fullscreen')
	setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)
	if getPropertyFromClass("openfl.Lib", "application.window.height") >= 720 then
		oldwidth = 1280
		oldheight = 720
	else
		oldwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
		oldheight = getPropertyFromClass("openfl.Lib", "application.window.height")
	end
	makeLuaText('dummyScale', '', 1, oldwidth, oldheight)
	addLuaText('dummyScale')
	oldwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
	oldwindY = getPropertyFromClass("openfl.Lib", "application.window.y")
	curwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
	curwindY = getPropertyFromClass("openfl.Lib", "application.window.y")
end

function onEvent(name, value1, value2)
	if name == "WindowScale" then
		if string.find(value1,',') then
			string = value1 -- setting up value to be separated
			split = string:split(",")
			winScaleX = tonumber(split[1])
			winScaleY = tonumber(split[2])
		else
			debugPrint('oops, no comma!')
			return Function_Stop;
		end

		if string.find(value2,',') then
			string = value2 -- setting up value to be separated
			split = string:split(",")
			scaleTime = tonumber(split[1])
			scaleEase = tonumber(split[2])
		else
			scaleTime = value2
			scaleEase = 'linear'
		end
		if scaleTime == 0 then
			scaleTime = 0.001
		end
		
		doTweenX('winScaleX', 'dummyScale', winScaleX, scaleTime, scaleEase)
		doTweenY('winScaleY', 'dummyScale', winScaleY, scaleTime, scaleEase)
	end
end

function onUpdate()
		if getPropertyFromClass("openfl.Lib", "application.window.width") == getProperty('dummyScale.x') then
		else
			differencex = (getPropertyFromClass("openfl.Lib", "application.window.width") - getProperty('dummyScale.x'))/2
			setPropertyFromClass("openfl.Lib", "application.window.width", getProperty('dummyScale.x'))
			setProperty('dummyWinMove.x', getProperty('dummyWinMove.x') + differencex)
			setPropertyFromClass("openfl.Lib", "application.window.x", getPropertyFromClass("openfl.Lib", "application.window.x") + differencex)
		end

		if getPropertyFromClass("openfl.Lib", "application.window.height") == getProperty('dummyScale.y') then
		else
			differencey = (getPropertyFromClass("openfl.Lib", "application.window.height") - getProperty('dummyScale.y'))/2
			setPropertyFromClass("openfl.Lib", "application.window.height", getProperty('dummyScale.y'))
			setProperty('dummyWinMove.y', getProperty('dummyWinMove.y') + differencey)
			setPropertyFromClass("openfl.Lib", "application.window.y", getPropertyFromClass("openfl.Lib", "application.window.y") + differencey)
		end
end

function onDestroy()
		setPropertyFromClass("openfl.Lib", "application.window.width", oldwidth)
		setPropertyFromClass("openfl.Lib", "application.window.height", oldheight)
		setPropertyFromClass("openfl.Lib", "application.window.x", oldwindX)
		setPropertyFromClass("openfl.Lib", "application.window.y", oldwindY)
		setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', wasScreen)
end

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end