local function videoThing(a, b, c, d, e, f)
    startVideo(a, b, c, d, e)
    if not f then return end
    setObjectCamera('videoCutscene', 'hud')
    setObjectOrder('videoCutscene', 0)
end

function onCreate()
  for i = 0, getProperty('eventNotes.length')-1 do
    if getProperty('eventNotes['..i..'].event') == 'playVideo' then
      startVideo(getProperty('eventNotes['..i..'].value1'), false, true, false, false)
    end
  end
end

function onEvent(n, v1, v2)
  if n ~= 'playVideo' then return end
  videoThing(v1, false, true, nil, nil, v2 == '')
end

------ dont mind any of this   vvv
function onPause()
  if getProperty("videoCutscene") == nil then return end
  callMethod("videoCutscene.pause")

  if callMethodFromClass("flixel.FlxG", "signals.focusLost.has", {instanceArg("videoCutscene.videoSprite.pause")}) then
    callMethodFromClass("flixel.FlxG", "signals.focusLost.remove", {instanceArg("videoCutscene.videoSprite.pause")})
  end

  if callMethodFromClass("flixel.FlxG", "signals.focusGained.has", {instanceArg("videoCutscene.videoSprite.resume")}) then
    callMethodFromClass("flixel.FlxG", "signals.focusGained.remove", {instanceArg("videoCutscene.videoSprite.resume")})
  end
end

function onResume()
  if getProperty("videoCutscene") == nil then return end
  callMethod("videoCutscene.resume")

  if not callMethodFromClass("flixel.FlxG", "signals.focusLost.has", {instanceArg("videoCutscene.videoSprite.pause")}) then
    callMethodFromClass("flixel.FlxG", "signals.focusLost.add", {instanceArg("videoCutscene.videoSprite.pause")})
  end

  if not callMethodFromClass("flixel.FlxG", "signals.focusGained.has", {instanceArg("videoCutscene.videoSprite.resume")}) then
    callMethodFromClass("flixel.FlxG", "signals.focusGained.add", {instanceArg("videoCutscene.videoSprite.resume")})
  end
end