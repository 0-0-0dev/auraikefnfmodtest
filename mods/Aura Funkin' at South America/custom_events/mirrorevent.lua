function onEvent(name, value1, value2)
    if name == 'mirrorevent' then
        if value1 == 'nug' then
            triggerEvent('Camera Follow Pos', '970', '500') -- Nug position
        elseif value1 == 'rotnug' then
            triggerEvent('Camera Follow Pos', '-230', '450') -- Rotnug position
        elseif value1 == 'middle' then
            triggerEvent('Camera Follow Pos', '1500', '300') -- Middle position
        elseif value1 == 'max' then
            triggerEvent('Camera Follow Pos', '690', '377.9') -- Focus on boyfriend
        elseif value1 == '' then
            triggerEvent('Camera Follow Pos', '', '') -- Reset to default
        elseif value1 == 'up' then
            triggerEvent('Camera Follow Pos', '389.3', '-2432.1') -- UP MOVIE YASSSSSSS
        end
    end
end
