-- AURA: replaces the health bar with two static icons + an "aura" number (Psych Engine 1.0.4)
--
-- Install: put this file in  mods/<your mod>/scripts/  (runs on every song of that mod)
--
-- How it works
--   * Psych's own health keeps running underneath (0..2), so hit gains, miss losses, hurt notes,
--     practice mode and game over all behave like normal. The script just shows it as aura 0..100.
--   * Your aura  = health / 2 * 100        (starts at 50, max 100, 0 = you lose)
--     Opponent   = 100 - your aura          (so both show 50 at the start, like the mockup)
--   * Every opponent note drains you (1 aura by default), but the drain stops at MIN_AURA_FROM_DRAIN.
--     Missing notes can still take you to 0.
--   * The vanilla health bar, its icons and the score line are hidden. The new icons never bounce.
--   * If an icon image can't be found, a red message shows on screen and the normal
--     health bar stays, so the song is still playable.

----------------------------------------------------------------------
-- SETTINGS
----------------------------------------------------------------------
-- image names are relative to  <mod>/images/  and have no ".png"
-- (images/icons/ike.png  ->  'icons/ike')
local PLAYER_ICON         = 'icons/ike'      -- red icon,    right side
local OPPONENT_ICON       = 'icons/chase'    -- yellow icon, left side
local PLAYER_ON_RIGHT     = true             -- false = player on the left, opponent on the right
local ICONS_ON_TOP        = false            -- false = bottom corners (your strums are at the top)
local HIDE_SCORE_TEXT     = true             -- hide Psych's "Score | Misses | Rating" line

-- 1 or more = the number visibly moves for every opponent note (less than 1 often rounds to "no change")
local OPPONENT_DRAIN      = 1.0      -- aura lost for every opponent note
local SUSTAIN_DRAIN       = 1.0      -- aura lost for every piece of an opponent hold
                                     -- (0 when Psych's "Guitar Hero sustains" option is on, because then
                                     --  you don't gain aura for hold pieces either)
local MIN_AURA_FROM_DRAIN = 5        -- the opponent's singing can never push you below this

-- layout (pixels at 720p, scales with the game resolution)
local ICON_HEIGHT = 140
local EDGE_X      = 28               -- distance from the screen sides
local EDGE_Y      = 22               -- distance from the bottom (or top if ICONS_ON_TOP)
local ICON_GAP    = 14               -- space between icon and text
local FONT        = 'vcr.ttf'
local FONT_SIZE   = 36
local TEXT_WIDTH  = 320
local TEXT_BOTTOM_NUDGE = 0          -- move the aura text up (+) or down (-) by a few pixels

----------------------------------------------------------------------
-- internals
----------------------------------------------------------------------
local MAX_HEALTH      = 2                      -- Psych's health bar goes 0 -> 2
local HEALTH_PER_AURA = MAX_HEALTH / 100       -- 1 aura = 0.02 health

-- distance from the top of the text box to the bottom of the letters, as a fraction of the font size
-- (measured for vcr.ttf; if you change FONT, use TEXT_BOTTOM_NUDGE to line it up again)
local FONT_BASELINE = 0.96

local sustainDrain = 0

local LEFT  = 'auraLeft'
local RIGHT = 'auraRight'

local hudOn     = false
local shownAura = -1

-- your aura as a whole number 0..100 (0 is only shown when you are really dead)
local function getAura()
    local health = getHealth()
    local aura = math.floor(health / HEALTH_PER_AURA + 0.5)
    if health > 0 and aura < 1 then aura = 1 end
    if aura > 100 then aura = 100 end
    if aura < 0 then aura = 0 end
    return aura
end

local function hideVanillaHud()
    setProperty('healthBar.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
    if HIDE_SCORE_TEXT then setProperty('scoreTxt.visible', false) end
end

local function removeSide(tag)
    removeLuaSprite(tag .. 'Icon', true)
    removeLuaText(tag .. 'Text', true)
end

-- returns false (and builds nothing) if the icon image doesn't exist
local function makeSide(tag, image, onRight)
    local ui    = screenHeight / 720
    local iconH = ICON_HEIGHT * ui
    local edgeX = EDGE_X * ui
    local edgeY = EDGE_Y * ui
    local gap   = ICON_GAP * ui
    local textW = TEXT_WIDTH * ui

    -- icon in the corner
    local iconY = ICONS_ON_TOP and edgeY or (screenHeight - edgeY - iconH)
    makeLuaSprite(tag .. 'Icon', image, 0, iconY)
    local frameW = getProperty(tag .. 'Icon.frameWidth')
    if frameW == nil or frameW <= 0 then
        debugPrint('AURA: cannot find images/' .. image .. '.png - fix PLAYER_ICON / OPPONENT_ICON at the top of the script', 'FF0000')
        return false
    end
    setGraphicSize(tag .. 'Icon', 0, iconH)
    local iconW = getProperty(tag .. 'Icon.width')
    local iconX = onRight and (screenWidth - edgeX - iconW) or edgeX
    setProperty(tag .. 'Icon.x', iconX)
    setObjectCamera(tag .. 'Icon', 'camHUD')
    addLuaSprite(tag .. 'Icon', true)

    -- text: next to the icon, on the side facing the middle of the screen
    local textX = onRight and (iconX - gap - textW) or (iconX + iconW + gap)
    local size  = math.floor(FONT_SIZE * ui)
    makeLuaText(tag .. 'Text', 'aura: 100', math.floor(textW), textX, 0)
    setTextFont(tag .. 'Text', FONT)
    setTextSize(tag .. 'Text', size)
    setTextColor(tag .. 'Text', 'FFFFFF')
    setTextBorder(tag .. 'Text', math.max(1, math.floor(2 * ui + 0.5)), '000000')
    setTextAlignment(tag .. 'Text', onRight and 'right' or 'left')

    -- the bottom of the letters sits exactly on the bottom edge of the icon
    setProperty(tag .. 'Text.y', iconY + iconH - size * FONT_BASELINE - TEXT_BOTTOM_NUDGE * ui)
    setObjectCamera(tag .. 'Text', 'camHUD')
    addLuaText(tag .. 'Text')
    return true
end

local function refreshText()
    local aura = getAura()
    if aura == shownAura then return end
    shownAura = aura

    local leftValue  = PLAYER_ON_RIGHT and (100 - aura) or aura
    local rightValue = PLAYER_ON_RIGHT and aura or (100 - aura)
    setTextString(LEFT .. 'Text', 'aura: ' .. leftValue)
    setTextString(RIGHT .. 'Text', rightValue .. ' :aura')
end

----------------------------------------------------------------------
-- callbacks
----------------------------------------------------------------------
function onCreatePost()
    -- with Guitar Hero sustains you get no aura for hold pieces, so the opponent's pieces don't drain either
    sustainDrain = (getProperty('guitarHeroSustains') == true) and 0 or SUSTAIN_DRAIN

    if hideHud then   -- "Hide HUD" option: show nothing (the drain still works)
        hideVanillaHud()
        return
    end

    local leftOk  = makeSide(LEFT,  PLAYER_ON_RIGHT and OPPONENT_ICON or PLAYER_ICON, false)
    local rightOk = makeSide(RIGHT, PLAYER_ON_RIGHT and PLAYER_ICON or OPPONENT_ICON, true)
    if not (leftOk and rightOk) then
        removeSide(LEFT)
        removeSide(RIGHT)
        return   -- keep the normal health bar so the song stays playable
    end

    hudOn = true
    hideVanillaHud()
    refreshText()
end

function onUpdatePost(elapsed)
    if not hudOn then return end
    hideVanillaHud()
    refreshText()
end

-- opponent sings -> you lose aura, but never below MIN_AURA_FROM_DRAIN
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    local drain = isSustainNote and sustainDrain or OPPONENT_DRAIN
    if drain <= 0 then return end

    local health      = getHealth()
    local floorHealth = MIN_AURA_FROM_DRAIN * HEALTH_PER_AURA
    if health <= floorHealth then return end   -- already at/under the floor: drain does nothing

    setHealth(math.max(health - drain * HEALTH_PER_AURA, floorHealth))
end
