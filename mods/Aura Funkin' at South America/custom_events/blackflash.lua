function onCreate()
  makeLuaSprite('blackflash', '', -600, -400)
  makeGraphic('blackflash', 6500, 1500, '000000')
  setScrollFactor('blackflash', 0, 0)
  addLuaSprite('blackflash',true)
  setProperty('blackflash.alpha', 0)
end
function onEvent(name, value1, value2)
  if name == 'blackflash' then
    setProperty('blackflash.alpha', 1)
    doTweenAlpha('blackflashbye', 'blackflash', 0, 1, 'linear')
  end
end
function onUpdate()
  haha = false
  if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.T') and not haha == true then
    setProperty('blackflash.alpha', 1)
    doTweenAlpha('blackflashbye', 'blackflash', 0, 1, 'linear')
  end
end
