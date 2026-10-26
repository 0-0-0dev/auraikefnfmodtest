local intensity = 0.05
function onCreatePost()
	makeLuaSprite('flashbang', '', 0, 0)
	makeGraphic('flashbang', screenWidth, screenHeight, 'cee0ff')
	setObjectCamera('flashbang', 'other')
	setBlendMode('flashbang', 'ADD')
	setProperty('flashbang.alpha', 0)
	addLuaSprite('flashbang', false)
end
function onEvent(name, value1, value2)
	if name == 'flashbang undertale blue' then
		setProperty('flashbang.alpha', intensity)
		doTweenAlpha('flashbang fade', 'flashbang', 0, 1, 'linear')
	end
end