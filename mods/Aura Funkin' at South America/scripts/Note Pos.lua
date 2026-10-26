function onCreatePost()
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', true)

    local newY = 25
    local newScale = 0.6

    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'y', newY)
        setPropertyFromGroup('opponentStrums', i, 'scale.x', newScale)
        setPropertyFromGroup('opponentStrums', i, 'scale.y', newScale)
    end

    for i = 0, 3 do
        setPropertyFromGroup('playerStrums', i, 'y', newY)
        setPropertyFromGroup('playerStrums', i, 'scale.x', newScale)
        setPropertyFromGroup('playerStrums', i, 'scale.y', newScale)
    end
end
