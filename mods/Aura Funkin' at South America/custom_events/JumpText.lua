local textCount = 0

local dadOffsetX = -600
local dadOffsetY = -200

function onEvent(name, value1, value2)
    if name ~= 'JumpText' then
        return
    end

    value2 = string.upper(value2 or 'B')

    local char = 'boyfriend'
    if value2 == 'D' then
        char = 'dad'
    elseif value2 == 'G' then
        char = 'gf'
    end

    local tag = 'jumpText' .. textCount
    textCount = textCount + 1

    local baseX = getCharacterX(char) + getProperty(char .. '.width') * 0.5
    local baseY = getCharacterY(char) + getProperty(char .. '.height') * 0.1

    if char == 'dad' then
        baseX = baseX + dadOffsetX
        baseY = baseY + dadOffsetY
    end

    local verticalOffset = getRandomInt(0, 250)
    local spawnX = baseX
    local spawnY = baseY + verticalOffset

    local baseSide = getRandomInt(0, 100)
    local direction = getRandomBool(50) and 1 or -1
    local side = baseSide * (1 + verticalOffset / 100 * 2) * direction

    local angle = getRandomInt(-10, 10)

    local safeText = string.gsub(value1, '"', '\\"')

    runHaxeCode([[
        import flixel.text.FlxText;
        import flixel.tweens.FlxTween;
        import flixel.tweens.FlxEase;

        var txt = new FlxText(0, 0, 0, "]] .. safeText .. [[", 67);
        txt.setFormat(Paths.font("lemon.ttf"), 85, 0xFFFFFFFF, "left");
        txt.cameras = [game.camGame];

        var spawnX = ]] .. spawnX .. [[;
        var spawnY = ]] .. spawnY .. [[;
        var drift = ]] .. side .. [[;
        var angle = ]] .. angle .. [[;

        txt.x = spawnX - txt.width / 2;
        txt.y = spawnY;
        txt.angle = angle;

        var charLower = "]] .. char .. [[";
        if (charLower == "boyfriend") {
            game.addBehindBF(txt);
        } else if (charLower == "dad") {
            game.addBehindDad(txt);
        } else if (charLower == "gf") {
            game.addBehindGF(txt);
        } else {
            game.add(txt);
        }

        FlxTween.tween(txt.scale, {x:1.15, y:1.15}, 0.10, {
            ease: FlxEase.quadOut
        });
        FlxTween.tween(txt.scale, {x:1.0, y:1.0}, 0.12, {
            startDelay:0.10,
            ease:FlxEase.backOut
        });

        FlxTween.tween(txt, {
            x: txt.x + drift,
            y: spawnY - 120
        }, 0.18, {
            ease: FlxEase.quadOut
        });

        FlxTween.tween(txt, {
            y: spawnY + 200,
            alpha: 0
        }, 0.55, {
            startDelay:0.18,
            ease:FlxEase.quadIn,
            onComplete:function(t)
            {
                txt.kill();
                txt.destroy();
            }
        });
    ]])
end