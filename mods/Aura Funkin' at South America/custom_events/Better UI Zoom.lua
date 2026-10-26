require "math"

HUDIn = ''
HUDHold = ''
HUDOut = ''
HUDeasing = 'expoOut'


function onEvent(name, value1, value2)
	if name == 'Better UI Zoom' then
		HUDIn = ''
		HUDHold = ''
		HUDOut = ''
		oldHUDAmount = getProperty('camHUD.zoom')
		HUDAmount = value1
		HUDdonot = 'no'
		HUDeasing = easing

		string = value1 -- setting up value to be separated
		split = string:split(",")
		if table.getn(split) == 2 then
			HUDAmount = split[1]
			HUDeasing = split[2]
		elseif table.getn(split) == 1 then
			HUDAmount = split[1]
		end

		if string.find(HUDAmount,'+') then
			HUDAmount = oldHUDAmount + HUDAmount
		end
		if string.find(HUDAmount,'-') then
			HUDAmount = oldHUDAmount + HUDAmount
		end

		string = value2 -- setting up value to be separated
		split = string:split(",")
		if table.getn(split) == 3 then
			HUDIn = split[1]
			HUDHold = split[2]
			HUDOut = split [3]
		elseif table.getn(split) == 2 then
			HUDIn = split[1]
			HUDOut = split [2]
		elseif table.getn(split) == 1 then
			HUDIn = split[1]
		end

		if tonumber(HUDIn) == 0 then
			HUDIn = 0.00001
		end
		if tonumber(HUDOut) == 0 then
			HUDOut = 0.00001
		end

		doTweenZoom('HUDInitialZoom', 'camHUD', HUDAmount, HUDIn, easing)

		if HUDHold == '' then
		else
			HUDdonot = 'yes'
			runTimer('waitforHUDtimer', HUDIn, 1)
			runTimer('repeatHUDquick', 0.001, 0)
		end
		if HUDOut == '' then
		else
			if HUDdonot == 'no' then
			runTimer('waitforHUDzoom', HUDIn, 1)
			end
		end
	end	
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'waitforHUDzoom' then
		HUDdonot = 'yes'
		doTweenZoom('SecondHUDZoom', 'camHUD', oldHUDAmount, HUDOut, easing)
	end
	if tag == 'waitforHUDtimer' then
		
		runTimer('waitforHUDzoom', HUDIn, 1)
		HUDdonot = 'no'
	end
	if tag == 'repeatHUDquick' then
		if HUDdonot == 'no' then
			doTweenZoom('HUDInitialZoom', 'camHUD', HUDAmount, 0.001, easing)
		end
	end
end



function addToSet(set, key)
    set[key] = true
end

function removeFromSet(set, key)
    set[key] = nil
end

function setContains(set, key)
    return set[key] ~= nil
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




