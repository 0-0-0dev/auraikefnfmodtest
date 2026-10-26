-- make bars, set scale, set type, then move smoothly within 0.5 seconds by default.
BarType = 'wide'
BarAmount = 1
function onCreate()
	makeLuaSprite('bar1','',0,0)
	makeGraphic('bar1', 1, 1, '000000')
	addLuaSprite('bar1',false)
	setObjectCamera('bar1', 'hud')

	makeLuaSprite('bar2','',0,0)
	makeGraphic('bar2', 1, 1, '000000')
	addLuaSprite('bar2',false)
	setObjectCamera('bar2', 'hud')
end

function onEvent(name, value1, value2)
	if name == "Bars" then
		string = value1
		split = string:split(",")
		if table.getn(split) == 2 then
			BarType = split[1]
			BarAmount = split[2]
		elseif table.getn(split) == 1 then
			debugPrint('Check to see if you missed or added an extra comma!')
			debugPrint('Whoops! Something went wrong!')
			return Function_Stop;
		end
		if value2 == '' or value2 == nil then
			if BarType == 'wide' then
				setProperty('bar1.scale.y', BarAmount/2)
				setProperty('bar2.scale.y', BarAmount/2)
				setProperty('bar1.scale.x', screenWidth)
				setProperty('bar2.scale.x', screenWidth)
			else
				setProperty('bar1.scale.x', BarAmount/2)
				setProperty('bar2.scale.x', BarAmount/2)
				setProperty('bar1.scale.y', screenHeight)
				setProperty('bar2.scale.y', screenHeight)
			end
				
		else
			if BarType == 'wide' then
				doTweenY('bar1scale', 'bar1.scale', BarAmount/2, value2, 'circOut')
				doTweenY('bar2scale', 'bar2.scale', BarAmount/2, value2, 'circOut')
				setProperty('bar1.scale.x', screenWidth)
				setProperty('bar2.scale.x', screenWidth)
			else
				doTweenX('bar1scale', 'bar1.scale', BarAmount/2, value2, 'circOut')
				doTweenX('bar2scale', 'bar2.scale', BarAmount/2, value2, 'circOut')
				setProperty('bar1.scale.y', screenHeight)
				setProperty('bar2.scale.y', screenHeight)
			end
		end
	end
end

function onUpdate()
	if BarType == 'wide' then
		setProperty('bar2.y', screenHeight - getProperty('bar2.height'))
		setProperty('bar2.x', 0)
	else
		setProperty('bar2.x', screenWidth - getProperty('bar2.width'))
		setProperty('bar2.y', 0)
	end
	updateHitbox('bar2')
	updateHitbox('bar1')
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