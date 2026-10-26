function onEvent(name, value1, value2)
    if name == "Stage Layer" and value1 ~= nil and value1 ~= "" then
        local targetAlpha = 1
        local speed = 0
        
        if value2 ~= nil and value2 ~= "" then
            local commaPos = string.find(value2, ",")
            if commaPos then
                targetAlpha = tonumber(string.sub(value2, 1, commaPos - 1)) or 1
                speed = tonumber(string.sub(value2, commaPos + 1)) or 0
            else
                targetAlpha = tonumber(value2) or 1
                speed = 0
            end
        end
        
        local sprites = {}
        for sprite in string.gmatch(value1, "[^,]+") do
            sprite = sprite:gsub("^%s*(.-)%s*$", "%1")
            table.insert(sprites, sprite)
        end

        for _, spriteTag in ipairs(sprites) do
            if getProperty(spriteTag) ~= nil then
                if speed <= 0 then
                    setProperty(spriteTag .. ".alpha", targetAlpha)
                else
                    local tweenId = spriteTag .. "Fade"
                    if targetAlpha == 0 then
                        tweenId = tweenId .. "Out"
                    else
                        tweenId = tweenId .. "In"
                    end
                    doTweenAlpha(tweenId, spriteTag, targetAlpha, speed, "linear")
                end
            end
        end
    end
end