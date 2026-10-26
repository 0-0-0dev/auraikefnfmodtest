local shaderName = "adjustColor"

local shaderEnabled = false
local currentSat = 0
local targetSat = 0

local tweening = false
local tweenStart = 0
local tweenDuration = 0
local tweenFrom = 0
local tweenTo = 0
local tweenEase = "linear"

function onCreate()
    shaderCoordFix()

    makeLuaSprite("adjustColorShader")
    makeGraphic("adjustColorShader", screenWidth, screenHeight)
end

function ensureShader()
    if shaderEnabled then
        return
    end

    shaderEnabled = true

    runHaxeCode([[
        game.initLuaShader("]] .. shaderName .. [[");

        var shader = game.createRuntimeShader("]] .. shaderName .. [[");

        game.camGame.setFilters([new ShaderFilter(shader)]);
        game.camHUD.setFilters([new ShaderFilter(shader)]);

        game.getLuaObject("adjustColorShader").shader = shader;
    ]])

    setShaderFloat("adjustColorShader", "hue", 0)
    setShaderFloat("adjustColorShader", "saturation", 0)
    setShaderFloat("adjustColorShader", "brightness", 0)
    setShaderFloat("adjustColorShader", "contrast", 1)

    currentSat = 0
end

function onEvent(name, v1, v2)
    if name ~= "Saturation Effect" then
        return
    end

    ensureShader()

    local sat = tonumber(v1)
    if sat == nil then
        sat = 1
    end

    if sat < 0 then
        sat = 0
    end

    targetSat = (sat - 1) * 100

    if v2 == nil or v2 == "" then
        tweening = false
        currentSat = targetSat
        setShaderFloat("adjustColorShader", "saturation", currentSat)
        return
    end

    local split = {}

    for s in string.gmatch(v2, "[^,]+") do
        table.insert(split, s)
    end

    tweenDuration = tonumber(split[1]) or 0
    tweenEase = split[2] or "linear"

    if tweenDuration <= 0 then
        tweening = false
        currentSat = targetSat
        setShaderFloat("adjustColorShader", "saturation", currentSat)
        return
    end

    tweening = true
    tweenStart = os.clock()
    tweenFrom = currentSat
    tweenTo = targetSat
end

function onUpdate(elapsed)
    if not tweening then
        return
    end

    local t = (os.clock() - tweenStart) / tweenDuration

    if t >= 1 then
        t = 1
        tweening = false
    end

    local e = ease(t, tweenEase)

    currentSat = tweenFrom + (tweenTo - tweenFrom) * e

    setShaderFloat("adjustColorShader", "saturation", currentSat)
end

function ease(x, e)
    if e == "linear" then
        return x

    elseif e == "quadIn" then
        return x * x

    elseif e == "quadOut" then
        return 1 - (1 - x) * (1 - x)

    elseif e == "quadInOut" then
        if x < 0.5 then
            return 2 * x * x
        end
        return 1 - math.pow(-2 * x + 2, 2) / 2

    elseif e == "cubeIn" then
        return x * x * x

    elseif e == "cubeOut" then
        return 1 - math.pow(1 - x, 3)

    elseif e == "cubeInOut" then
        if x < 0.5 then
            return 4 * x * x * x
        end
        return 1 - math.pow(-2 * x + 2, 3) / 2

    elseif e == "quartIn" then
        return x ^ 4

    elseif e == "quartOut" then
        return 1 - math.pow(1 - x, 4)

    elseif e == "quartInOut" then
        if x < 0.5 then
            return 8 * x ^ 4
        end
        return 1 - math.pow(-2 * x + 2, 4) / 2

    elseif e == "quintIn" then
        return x ^ 5

    elseif e == "quintOut" then
        return 1 - math.pow(1 - x, 5)

    elseif e == "sineIn" then
        return 1 - math.cos((x * math.pi) / 2)

    elseif e == "sineOut" then
        return math.sin((x * math.pi) / 2)

    elseif e == "sineInOut" then
        return -(math.cos(math.pi * x) - 1) / 2
    end

    return x
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr)
        {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }

        fixShaderCoordFix = function(?_)
        {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }

        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
    ]])
end

function onDestroy()
    tweening = false

    runHaxeCode([[
        if (fixShaderCoordFix != null)
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
    ]])

    if shaderEnabled then
        runHaxeCode([[
            game.camGame.setFilters([]);
            game.camHUD.setFilters([]);

            var spr = game.getLuaObject("adjustColorShader");
            if (spr != null)
                spr.shader = null;
        ]])
    end
end