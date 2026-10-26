function onEvent(name, value1, value2)
    if name == "A Flash" then
        local color = value1 or 'FF0000'
        local duration = tonumber(value2) or 0.3

        makeLuaSprite('flash', '', 0, 0)
        makeGraphic('flash', screenWidth, screenHeight, color)
        setObjectCamera('flash', 'other')
        setProperty('flash.alpha', 1)
        addLuaSprite('flash', true)

        doTweenAlpha('flashFade', 'flash', 0, duration, 'linear')
    end
end
