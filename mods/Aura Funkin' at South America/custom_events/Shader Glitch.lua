function boundTo(value, min, max)
    return math.max(min, math.min(max, value))
end

function math.lerp(from, to, i)
    return from + (to - from) * i
end

function setChrome(chromeOffset)
    setShaderFloat("temporaryShader", "rOffset", chromeOffset)
    setShaderFloat("temporaryShader", "gOffset", 0.0)
    setShaderFloat("temporaryShader", "bOffset", chromeOffset * -1)
end

local easings = {
    linear = function(t) return t end,
    sineinout = function(t) return -(math.cos(math.pi * t) - 1) / 2 end,
    quadinout = function(t)
        return t < 0.5 and 2 * t * t or 1 - math.pow(-2 * t + 2, 2) / 2
    end,
    cubicinout = function(t)
        return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
    end,
}

glitchState = {
    active = false,
    current = 0,
    startValue = 0,
    target = 0,
    timer = 0,
    duration = 1,
    easing = easings.sineinout,
}

function onCreatePost()
    if shadersEnabled then
        initLuaShader("vcr")

        makeLuaSprite("temporaryShader")
        makeGraphic("temporaryShader", screenWidth, screenHeight)
        setSpriteShader("temporaryShader", "vcr")

        addHaxeLibrary("ShaderFilter", "openfl.filters")
        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("temporaryShader").shader)]);
        ]])
    end
end

function onEvent(name, value1, value2)
    if name == 'Shader Glitch' then
        local parts1 = {}
        for part in string.gmatch(value1, "[^,]+") do
            table.insert(parts1, part)
        end
        if #parts1 ~= 2 then return end

        local direction = parts1[1]:lower()
        local amount = tonumber(parts1[2]) or 0

        local parts2 = {}
        for part in string.gmatch(value2, "[^,]+") do
            table.insert(parts2, part)
        end

        local duration = tonumber(parts2[1]) or 1
        duration = math.max(duration, 0.001)

        local easingName = "sineinout"
        if #parts2 >= 2 then
            easingName = parts2[2]:lower()
        end

        local easingFunc = easings[easingName] or easings.linear

        glitchState.duration = duration
        glitchState.easing = easingFunc
        glitchState.timer = 0

        if direction == "fadein" then
            glitchState.startValue = 0
            glitchState.target = amount
        elseif direction == "fadeout" then
            glitchState.startValue = glitchState.current
            glitchState.target = 0
        else
            return
        end

        glitchState.active = true
    end
end

function onUpdate(elapsed)
    if not glitchState.active then return end

    glitchState.timer = glitchState.timer + elapsed
    local rawProgress = math.min(glitchState.timer / glitchState.duration, 1)

    local easedProgress = glitchState.easing(rawProgress)
    glitchState.current = math.lerp(glitchState.startValue, glitchState.target, easedProgress)

    setChrome(glitchState.current)

    if rawProgress >= 1 then
        glitchState.active = false
        glitchState.current = glitchState.target
        setChrome(glitchState.current)
    end
end