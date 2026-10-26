function onEvent(name, value1, value2)
    if name == 'Change Note Skin' then
        -- Determine who to target based on Value 2 (0 = BF, 1 = Dad, 2 = Both)
        local target = tonumber(value2) or 2
        local newSkin = value1

        -- 1. Change the upcoming scrollable notes
        for i = 0, getProperty('unspawnNotes.length') - 1 do
            local mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
            if (target == 0 and mustPress) or (target == 1 and not mustPress) or target == 2 then
                setPropertyFromGroup('unspawnNotes', i, 'texture', newSkin)
            end
        end

        -- 2. Change the static receptors (strumline) at the top/bottom of the screen
        if target == 0 or target == 2 then
            for i = 4, 7 do
                setPropertyFromGroup('strumLineNotes', i, 'texture', newSkin)
            end
        end
        if target == 1 or target == 2 then
            for i = 0, 3 do
                setPropertyFromGroup('strumLineNotes', i, 'texture', newSkin)
            end
        end
    end
end
