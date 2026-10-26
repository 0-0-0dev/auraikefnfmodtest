-- cool camera event coded by yb, amirite

local camfollowx = 0
local camfollowy = 0
local followCameraX = true
local followCameraY = true
local tweeningCam = false

local camPositions = {
    bf = {690, 377.9},
    dad = {-300, 356.5},
    middle = {-200, 400},
    up = {50, -2432.1},
    rotnug = {-230, 450},
    nug = {970, 500}
}

local easeMap = {
    -- Linear
    ["linear"] = "Linear",

    -- Sine
    ["sinein"] = "SineIn",
    ["sineout"] = "SineOut",
    ["sineinout"] = "SineInOut",

    -- Quad
    ["quadin"] = "QuadIn",
    ["quadout"] = "QuadOut",
    ["quadinout"] = "QuadInOut",

    -- Cubic
    ["cubein"] = "CubeIn",
    ["cubeout"] = "CubeOut",
    ["cubeinout"] = "CubeInOut",

    -- Quart
    ["quartin"] = "QuartIn",
    ["quartout"] = "QuartOut",
    ["quartinout"] = "QuartInOut",

    -- Quint
    ["quintin"] = "QuintIn",
    ["quintout"] = "QuintOut",
    ["quintinout"] = "QuintInOut",

    -- Expo
    ["expoin"] = "ExpoIn",
    ["expoout"] = "ExpoOut",
    ["expoinout"] = "ExpoInOut",

    -- Circ
    ["circin"] = "CircIn",
    ["circout"] = "CircOut",
    ["circinout"] = "CircInOut",

    -- Back
    ["backin"] = "BackIn",
    ["backout"] = "BackOut",
    ["backinout"] = "BackInOut",

    -- Bounce
    ["bouncein"] = "BounceIn",
    ["bounceout"] = "BounceOut",
    ["bounceinout"] = "BounceInOut",

    -- Elastic
    ["elasticin"] = "ElasticIn",
    ["elasticout"] = "ElasticOut",
    ["elasticinout"] = "ElasticInOut",

    -- Step (if custom added)
    ["step"] = "Step",
    ["stepin"] = "StepIn",
    ["stepout"] = "StepOut",
    ["stepinout"] = "StepInOut",

    -- Smoothstep (if custom added)
    ["smoothstep"] = "SmoothStep",
    ["smootherstep"] = "SmootherStep"
}

function split(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function normalizeEase(ease)
    return easeMap[string.lower(ease)] or ease
end

function onCreate()
    makeLuaSprite('camTarget', '', 0, 0)
    setProperty('camTarget.visible', false)
    addLuaSprite('camTarget', false)
end

function onEvent(eventName, value1, value2)
    if eventName == "CamPosV2" then
        local pos = camPositions[value1]
        if not pos then return end

        local x, y = pos[1], pos[2]
        local tweenData = split(value2, ",")

        if #tweenData == 2 then
            local ease = normalizeEase(tweenData[1])
            local time = tonumber(tweenData[2])
            if not time then return end

            followCameraX = false
            followCameraY = false
            camfollowx = x
            camfollowy = y

            setProperty('camTarget.x', getProperty('camFollow.x'))
            setProperty('camTarget.y', getProperty('camFollow.y'))

            tweeningCam = true
            doTweenX("camX", "camTarget", x, time, ease)
            doTweenY("camY", "camTarget", y, time, ease)
        end
    end
end

function onTweenCompleted(tag)
    if tag == "camX" or tag == "camY" then
        tweeningCam = false
    end
end

function onUpdatePost()
    if tweeningCam then
        camfollowx = getProperty('camTarget.x')
        camfollowy = getProperty('camTarget.y')
        setProperty('camFollow.x', camfollowx)
        setProperty('camFollow.y', camfollowy)
    end
end
