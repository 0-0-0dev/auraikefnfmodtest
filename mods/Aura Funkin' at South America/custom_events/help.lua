function onCreate()
    -- Make sure the mouse is visible
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)

    -- Create a simple sprite (colored rectangle for testing)
    makeLuaSprite('help.png', '', 100, 100)
    makeGraphic('help.png', 200, 200, 'FF0000')  -- Red square
    addLuaSprite('help.png', false)  -- Add the image to the screen
end
