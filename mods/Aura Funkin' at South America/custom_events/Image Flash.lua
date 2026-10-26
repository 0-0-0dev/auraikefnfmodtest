function onEvent(name, value1, value2)
	if name == "Image Flash" then
		makeLuaSprite('image', value1, 0, 0);
		addLuaSprite('image', true);
		setObjectCamera('image', 'other');
		doTweenAlpha('in', 'image', 0, value2, 'linear');
	end
end