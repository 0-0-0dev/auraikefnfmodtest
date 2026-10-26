local onGF = false
local lockX = nil
local lockY = nil

function getTargetPos(char)
    local oldX = getProperty('camFollow.x')
    local oldY = getProperty('camFollow.y')

    cameraSetTarget(char)

    local x = getProperty('camFollow.x')
    local y = getProperty('camFollow.y')

    setProperty('camFollow.x', oldX)
    setProperty('camFollow.y', oldY)

    return x, y
end

function parseDurationEasing(v2)
    if v2 == nil or v2 == '' then
        return nil, nil
    end

    local s = v2:gsub("^%s*(.-)%s*$", "%1")

    local commaPos = s:find(",", 1, true)
    if commaPos then
        local durStr = s:sub(1, commaPos-1):gsub("^%s*(.-)%s*$", "%1")
        local easeStr = s:sub(commaPos+1):gsub("^%s*(.-)%s*$", "%1")
        local dur = tonumber(durStr)
        if dur then
            return dur, easeStr ~= '' and easeStr or 'sineinout'
        else
            return nil, nil
        end
    else
        local dur = tonumber(s)
        if dur then
            return dur, 'sineinout'
        else
            return nil, nil
        end
    end
end

function onEvent(n, v1, v2)
    if n ~= 'Camera Set Target' then return end

    local duration, easing = parseDurationEasing(v2)

    if duration == nil then
        lockX = nil
        lockY = nil

        if v1 == nil or v1 == '' then
            onGF = false
            triggerEvent('Camera Follow Pos', nil, nil)
        elseif string.lower(v1) == 'g' then
            onGF = true
            triggerEvent('Camera Follow Pos',
                getMidpointX('gf') + getProperty('gf.cameraPosition[0]'),
                getMidpointY('gf') + getProperty('gf.cameraPosition[1]'))
        elseif string.lower(v1) == 'b' then
            onGF = false
            cameraSetTarget('boyfriend')
        elseif string.lower(v1) == 'd' then
            onGF = false
            cameraSetTarget('dad')
        elseif string.lower(v1) == 'm' then
            onGF = false
            local bx, by = getTargetPos('boyfriend')
            local dx, dy = getTargetPos('dad')
            triggerEvent('Camera Follow Pos', (bx + dx) / 2, (by + dy) / 2)
        end
        return
    end

    local x, y

    if v1 == nil or v1 == '' then
        lockX = nil
        lockY = nil
        onGF = false
        triggerEvent('Camera Follow Pos', nil, nil)
        return
    elseif string.lower(v1) == 'b' then
        onGF = false
        x, y = getTargetPos('boyfriend')
    elseif string.lower(v1) == 'd' then
        onGF = false
        x, y = getTargetPos('dad')
    elseif string.lower(v1) == 'g' then
        onGF = true
        x = getMidpointX('gf') + getProperty('gf.cameraPosition[0]')
        y = getMidpointY('gf') + getProperty('gf.cameraPosition[1]')
    elseif string.lower(v1) == 'm' then
        onGF = false
        local bx, by = getTargetPos('boyfriend')
        local dx, dy = getTargetPos('dad')
        x = (bx + dx) / 2
        y = (by + dy) / 2
    else
        return
    end

    if duration == 0 then
        lockX = x
        lockY = y

        setProperty('camFollow.x', x)
        setProperty('camFollow.y', y)

        callMethod('camGame.snapToTarget', {''})
        triggerEvent('Camera Follow Pos', x, y)
    elseif duration > 0 then
        lockX = x
        lockY = y

        doTweenX('camTargetX', 'camFollow', x, duration, easing or 'sineinout')
        doTweenY('camTargetY', 'camFollow', y, duration, easing or 'sineinout')
    end
end

function onTweenCompleted(tag)
    if (tag == 'camTargetX' or tag == 'camTargetY') and lockX ~= nil and lockY ~= nil then
        triggerEvent('Camera Follow Pos', lockX, lockY)
    end
end