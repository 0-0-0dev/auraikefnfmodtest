function onCreate()
  makeLuaSprite('redflash', '', -600, -400)
  makeGraphic('redflash', 6500, 1500, 'FF0000')
  setScrollFactor('redflash', 0, 0)
  addLuaSprite('redflash',true)
  setProperty('redflash.alpha', 0)
end
function onEvent(name, value1, value2)
  if name == 'redflash' then
    setProperty('redflash.alpha', 1)
    doTweenAlpha('redflashbye', 'redflash', 0, 1, 'linear')
  end
end
function onUpdate()
  haha = false
  if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.T') and not haha == true then
    setProperty('redflash.alpha', 1)
    doTweenAlpha('redflashbye', 'redflash', 0, 1, 'linear')
  end
end
