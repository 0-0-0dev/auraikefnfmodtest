require "math"
function onCreate()
	wasScreen = getPropertyFromClass('openfl.Lib', 'application.window.fullscreen')
	setPropertyFromClass('openfl.Lib', 'application.window.fullscreen', false)

	oldwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
	oldwindY = getPropertyFromClass("openfl.Lib", "application.window.y")
	curwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
	curwindY = getPropertyFromClass("openfl.Lib", "application.window.y")

	makeLuaText('dummyWinMove', '', 1, oldwindX, oldwindY)
	addLuaText('dummyWinMove')
end

function onEvent(name, value1, value2)
	if name == "WindowMove" then
		curwindX = getPropertyFromClass("openfl.Lib", "application.window.x")
		curwindY = getPropertyFromClass("openfl.Lib", "application.window.y")

		if string.find(value1,',') then
			string = value1 -- setting up value to be separated
			split = string:split(",")
			if split[1] == '~' then
				winMoveX = curwindX
			else
				if string.find(split[1],'+') or string.find(split[1],'-') then
					winMoveX = tonumber(split[1]) + curwindX
				else
					winMoveX = tonumber(split[1])
				end
			end
			if split[2] == '~' then
				winMoveY = curwindY
			else
				if string.find(split[2],'+') or string.find(split[2],'-') then
					winMoveY = tonumber(split[2]) + curwindY
				else
					winMoveY = tonumber(split[2])
				end
			end
		else
			debugPrint('oops, no comma!')
			return Function_Stop;
		end

		if string.find(value2,',') then
			string = value2 -- setting up value to be separated
			split = string:split(",")
			MoveTime = tonumber(split[1])
			MoveEase = split[2]
		else
			MoveTime = tonumber(value2)
			MoveEase = 'linear'
		end
		if MoveTime == 0 then
			setProperty('dummyWinMove.x', winMoveX)
			setProperty('dummyWinMove.y', winMoveY)
			setPropertyFromClass("openfl.Lib", "application.window.x", winMoveX)
			setPropertyFromClass("openfl.Lib", "application.window.y", winMoveY)

		else
			if winMoveX == curwindX then
			else
				doTweenX('winMoveX', 'dummyWinMove', winMoveX, MoveTime, MoveEase)
			end
			if winMoveY == curwindY then
			else
				doTweenY('winMoveY', 'dummyWinMove', winMoveY, MoveTime, MoveEase)
			end
		end	
	end
end

function onUpdate()
	if getPropertyFromClass("openfl.Lib", "application.window.x") == getProperty('dummyWinMove.x') then
	else
		setPropertyFromClass("openfl.Lib", "application.window.x", getProperty('dummyWinMove.x'))
	end

	if getPropertyFromClass("openfl.Lib", "application.window.y") == getProperty('dummyWinMove.y') then
	else
		setPropertyFromClass("openfl.Lib", "application.window.y", getProperty('dummyWinMove.y'))
	end
end
function onDestroy()
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
