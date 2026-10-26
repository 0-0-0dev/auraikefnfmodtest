local currentVideoName = nil

function onEvent(eventName, value1, value2)
    if eventName == 'fireVideo' then

        if (value1 == nil or value1 == '') and value2 == 'yes' then
            if getProperty('videoCutscene.exists') then
                callMethod('videoCutscene.destroy')
                cancelTween('scaleVideoTween')
                cancelTimer('scaleVideo')
                cancelTimer('destroyVideo')
            end
            return
        end

        if value1 ~= nil and value1 ~= '' then
            currentVideoName = value1
            startVideo(value1, true, true, true, nil)
            setProperty('videoCutscene.alpha', 0)
            setObjectOrder('videoCutscene', getObjectOrder('uiGroup') - 1)
            setObjectCamera('videoCutscene', 'camHUD')
            runTimer('g', 0.1, 1)
            runTimer('scaleVideo', 0.1, 1)
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'g' then
        doTweenAlpha('videoFadeIn', 'videoCutscene', 0.3, 0.1, 'linear')
    end
    if tag == 'scaleVideo' then
        setProperty('videoCutscene.videoSprite.scale.x', 1280 / getProperty('videoCutscene.videoSprite.frameWidth'))
        setProperty('videoCutscene.videoSprite.scale.y', 720 / getProperty('videoCutscene.videoSprite.frameHeight'))
        setProperty('videoCutscene.videoSprite.updateHitbox', true)
        setProperty('videoCutscene.x', -160)
        setProperty('videoCutscene.y', 0)
    end
end

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