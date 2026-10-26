function parseDurationEasing(str)
    if str == nil or str == '' then
        return nil, nil
    end

    local s = str:gsub("^%s*(.-)%s*$", "%1")

    local commaPos = s:find(",", 1, true)
    if commaPos then
        local durStr = s:sub(1, commaPos-1):gsub("^%s*(.-)%s*$", "%1")
        local easeStr = s:sub(commaPos+1):gsub("^%s*(.-)%s*$", "%1")
        local dur = tonumber(durStr)
        if dur then
            return dur, easeStr ~= '' and easeStr or 'sineInOut'
        else
            return nil, nil
        end
    else
        local dur = tonumber(s)
        if dur then
            return dur, 'sineInOut'
        else
            return nil, nil
        end
    end
end

function onEvent(name, value1, value2)
    if name == "Set Cam Zoom" then
        if cancelTween then
            cancelTween('camz')
        end

        local duration, easing = parseDurationEasing(value2)

        if duration == nil then
            setProperty("defaultCamZoom", tonumber(value1))
        else
            doTweenZoom('camz', 'camGame', tonumber(value1), duration, easing or 'sineInOut')
        end
    end
end

function onTweenCompleted(name)
    if name == 'camz' then
        setProperty("defaultCamZoom", getProperty('camGame.zoom'))
    end
end