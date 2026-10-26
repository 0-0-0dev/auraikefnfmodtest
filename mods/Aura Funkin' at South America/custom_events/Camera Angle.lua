local angleTweenCount = 0
local currentAngleTweenTag = nil

function onEvent(name, value1, value2)
    if name == 'Camera Angle' then
        local angle = tonumber(value1)
        if angle == nil then
            return
        end

        if currentAngleTweenTag ~= nil then
            cancelTween(currentAngleTweenTag)
            currentAngleTweenTag = nil
        end

        if value2 == nil or value2 == '' then
            setProperty('camGame.angle', angle)
            return
        end

        local parts = {}
        for part in string.gmatch(value2, "[^,]+") do
            table.insert(parts, part)
        end

        local duration = tonumber(parts[1])
        if duration == nil or duration <= 0 then
            setProperty('camGame.angle', angle)
            return
        end

        local easing = parts[2] or 'sineInOut'

        angleTweenCount = angleTweenCount + 1
        local tag = 'angleTween_' .. angleTweenCount
        currentAngleTweenTag = tag

        doTweenAngle(tag, 'camGame', angle, duration, easing)
    end
end

function onCreatePost()
    addLuaScript("custom_events/zCameraFix")
end