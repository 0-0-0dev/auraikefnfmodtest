require "math"

In = ''
Hold = ''
Out = ''
easing = 'expoOut'
keepZoom = false

function onEvent(name, value1, value2)

	if name == 'Better Camera Zoom' then
		In = ''
		Hold = ''
		Out = ''
		oldGameAmount = getProperty('camGame.zoom')
		GameAmount = value1
		easing = 'expoOut'
		keepZoom = false
		
		string = value1 -- setting up value to be separated
		split = string:split(",")
		if table.getn(split) == 2 then
			GameAmount = split[1]
			easing = split[2]
		elseif table.getn(split) == 1 then
			GameAmount = split[1]
		end

		if string.find(GameAmount,'+') then
			GameAmount = oldGameAmount + GameAmount
		end
		if string.find(GameAmount,'-') then
			GameAmount = oldGameAmount + GameAmount
		end

		string = value2 -- setting up value to be separated
		split = string:split(",")
		if table.getn(split) == 3 then
			In = split[1]
			Hold = split[2]
			Out = split[3]
		elseif table.getn(split) == 2 then
			In = split[1]
			Hold = 'no'
			Out = split[2]
		elseif table.getn(split) == 1 then
			In = split[1]
			Hold = 'no'
			Out = 'no'
		end

		if tonumber(In) == 0 then
			In = 0.00001
		end
		if tonumber(Out) == 0 then
			Out = 0.00001
		end


		doTweenZoom('InitialZoom', 'camGame', GameAmount, In, easing)

	end	
end

function onUpdate()
	if keepZoom then
		setProperty('camGame.zoom', GameAmount)
	end
end

function onTweenCompleted(tag)
	if tag == 'InitialZoom' then
		if Hold == 'no' then
			if Out == 'no' then
				keepZoom = true
			else
				doTweenZoom('ZoomOut', 'camGame', oldGameAmount, Out, easing)
			end
		else
			doTweenZoom('HoldZoom', 'camGame', GameAmount, Hold, easing)
		end
	end
	if tag == 'HoldZoom' then
		doTweenZoom('ZoomOut', 'camGame', OldGameAmount, Out, easing)
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




