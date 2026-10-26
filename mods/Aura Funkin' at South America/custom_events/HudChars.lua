local origDadX
local origBfX
local origBfY

local origDadScaleX
local origDadScaleY

local origBfScaleX
local origBfScaleY

local isLegacyMix = false

local normalDadScaleAdd = 0.3
local normalBfScaleAdd = 0.3

local normalDadStartX = -2700
local normalBfStartX = 2570

local normalDadMove = 150
local normalBfMove = -250

local legacyDadScaleAdd = 1
local legacyBfScaleAdd = 1.3

local legacyDadStartX = -2200
local legacyBfStartX = 2200

local legacyDadMove = 1150
local legacyBfMove = 900

local legacyBfYOffset = -200

function onCreatePost()
    makeLuaSprite('000000bg1', '', -1000, -500)
    setScrollFactor('000000bg1', 0, 0)
    makeGraphic('000000bg1', 8000, 8000, '000000')
    addLuaSprite('000000bg1', false)
    setProperty('000000bg1.alpha', 0)

    origDadX = getProperty('dad.x')
    origBfX = getProperty('boyfriend.x')
    origBfY = getProperty('boyfriend.y')

    origDadScaleX = getProperty('dad.scale.x')
    origDadScaleY = getProperty('dad.scale.y')

    origBfScaleX = getProperty('boyfriend.scale.x')
    origBfScaleY = getProperty('boyfriend.scale.y')

    isLegacyMix = songName == 'CrossingFingers-Legacy-Mix'
    if isLegacyMix then
        local dadOrder = getObjectOrder('dad')
        setObjectOrder('000000bg1', dadOrder + 8)
    end
end

function onEvent(name, value1, value2)
    if name ~= 'HudChars' then return end

    local dadScaleAdd = normalDadScaleAdd
    local bfScaleAdd = normalBfScaleAdd

    local dadStartX = normalDadStartX
    local bfStartX = normalBfStartX

    local dadMove = normalDadMove
    local bfMove = normalBfMove

    if isLegacyMix then
        dadScaleAdd = legacyDadScaleAdd
        bfScaleAdd = legacyBfScaleAdd

        dadStartX = legacyDadStartX
        bfStartX = legacyBfStartX

        dadMove = legacyDadMove
        bfMove = legacyBfMove
    end

    if value1 == 'on' then
        setProperty('dad.scale.x', origDadScaleX + dadScaleAdd)
        setProperty('dad.scale.y', origDadScaleY + dadScaleAdd)

        setProperty('boyfriend.scale.x', origBfScaleX + bfScaleAdd)
        setProperty('boyfriend.scale.y', origBfScaleY + bfScaleAdd)

        setProperty('dad.x', dadStartX)
        setProperty('boyfriend.x', bfStartX)

        if isLegacyMix then
            setProperty('boyfriend.y', origBfY + legacyBfYOffset)
        end

        doTweenAlpha('blackFadeIn', '000000bg1', 0.5, 1.5, 'linear')
    end

    if value2 == 'bf' then
        doTweenX('bfTweenBack', 'boyfriend', origBfX + bfMove, 3, 'smootherStepInOut')
    end

    if value2 == 'dad' then
        doTweenX('dadTweenBack', 'dad', origDadX + dadMove, 3, 'smootherStepInOut')
    end

    if value1 == 'off' then
        doTweenX('dadReset', 'dad', origDadX, 0.003, 'smootherStepInOut')
        doTweenX('bfReset', 'boyfriend', origBfX, 0.003, 'smootherStepInOut')

        setProperty('dad.scale.x', origDadScaleX)
        setProperty('dad.scale.y', origDadScaleY)

        setProperty('boyfriend.scale.x', origBfScaleX)
        setProperty('boyfriend.scale.y', origBfScaleY)

        if isLegacyMix then
            setProperty('boyfriend.y', origBfY)
        end

        doTweenAlpha('blackFadeOut', '000000bg1', 0, 0.001, 'linear')
    end
end