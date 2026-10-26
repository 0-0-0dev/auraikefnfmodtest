function onEvent(name, value1, value2)
	if name == "Blue Flashing Camera" then
		cameraFlash('camGame','0000FE',0.5)
		makeLuaSprite('image', value1, -100, -200);
		addLuaSprite('image', true);
		doTweenColor('hello', 'image', '0000FE', 0.6, 'quartIn');
		setObjectCamera('image', 'other');
		runTimer('wait', value2);
	end
end

function onTimerCompleted(tag, loops, loopsleft)
	if tag == 'wait' then
		doTweenAlpha('byebye', 'image', 0.2, 0.4, 'linear');
	end
end

function onTweenCompleted(tag)
	if tag == 'byebye' then
		removeLuaSprite('image', true);
	end
end