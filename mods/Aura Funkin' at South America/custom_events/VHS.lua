function onCreate()
    -- Inicializa variáveis
    elapsedTime = 0

    -- Adiciona uma tela branca semitransparente para simular interferências
    makeLuaSprite('vhsOverlay', '', 0, 0)
    makeGraphic('vhsOverlay', screenWidth, screenHeight, 'FFFFFF')
    setProperty('vhsOverlay.alpha', 0.1) -- Valor inicial para alpha (transparência)
    addLuaSprite('vhsOverlay', true)
    setObjectCamera('vhsOverlay', 'camHUD')
    setBlendMode('vhsOverlay', 'add')
    
    -- Variáveis para controle de parâmetros
    noiseIntensity = 0.1  -- Valor 1: Intensidade do ruído
    scanlineIntensity = 0.05  -- Valor 2: Intensidade das linhas de varredura
    scanlineFrequency = 5  -- Valor 3: Frequência das linhas de varredura
end

function onUpdate(elapsed)
    -- Atualiza o tempo decorrido
    elapsedTime = elapsedTime + elapsed

    -- Adiciona ruído aleatório à tela para simular o efeito VHS
    setProperty('vhsOverlay.alpha', 0.05 + math.random() * noiseIntensity) -- Usa o valor 1 (noiseIntensity)
    
    -- Adiciona linhas horizontais para simular scanlines
    for i = 0, screenHeight, 4 do
        local lineAlpha = 0.1 + math.sin(elapsedTime * scanlineFrequency + i * 0.1) * scanlineIntensity -- Usa os valores 2 (scanlineIntensity) e 3 (scanlineFrequency)
        drawLine(0, i, screenWidth, i, lineAlpha)
    end
end

function drawLine(x1, y1, x2, y2, alpha)
    makeLuaSprite('line' .. y1, '', x1, y1)
    makeGraphic('line' .. y1, x2 - x1, 1, 'FFFFFF')
    setProperty('line' .. y1 .. '.alpha', alpha)
    addLuaSprite('line' .. y1, true)
    setObjectCamera('line' .. y1, 'camHUD')
    setBlendMode('line' .. y1, 'add')
end