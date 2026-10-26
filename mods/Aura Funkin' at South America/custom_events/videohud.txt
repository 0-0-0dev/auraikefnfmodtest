function onEvent(name,value1,value2)

    if name == 'videoHud' then
		
	if value1 == 'enable' or value1 == 'Enable'then
        	--doTweenAlpha('hudalpha', 'camHUD', tonumber(value1), 1, 'linear');
		setProperty('scoreTxt.visible', true)
		setProperty('miss.visible', true)
		setProperty('songText.visible', true)
		setProperty('timeBar.visible', true)
		setProperty('miss.visible', true)
		setProperty('healthBar.visible', true)
    		setProperty('iconP1.visible', true)
    		setProperty('iconP2.visible', true)
		
		if botplay then
			setProperty('botplayTxt.visible', true)
		end

	elseif value1 == 'disable' or value1 == 'Disable' then
		setProperty('scoreTxt.visible', false)
		setProperty('miss.visible', false)
		setProperty('songText.visible', false)
		setProperty('timeBar.visible', false)
		setProperty('miss.visible', false)
		setProperty('healthBar.visible', false)
    		setProperty('iconP1.visible', false)
    		setProperty('iconP2.visible', false)

		if botplay then
			setProperty('botplayTxt.visible', false)
		end

	elseif value1 == '' then
		print('')
	end
	
	if value2 == 'dadEnable' then
		noteTweenAlpha('dad0', 0, 1, 0.01, 'linear') --This will call a linear moving Alpha Tween on All of Dad's notes (notes 0 - 3).
		noteTweenAlpha('dad1', 1, 1, 0.01, 'linear') --The tween will take 0.01 seconds to be completed, when the tween ends, the note's alpha will be 1 (100%)
		noteTweenAlpha('dad2', 2, 1, 0.01, 'linear')
		noteTweenAlpha('dad3', 3, 1, 0.01, 'linear')

		for i = 0, 3 do
			setPropertyFromGroup('strumLineNotes', i, 'visible', true)
		end
	elseif value2 == 'dadDisable' then
		noteTweenAlpha('dad0', 0, 0, 0.01, 'linear')
		noteTweenAlpha('dad1', 1, 0, 0.01, 'linear')
		noteTweenAlpha('dad2', 2, 0, 0.01, 'linear')
		noteTweenAlpha('dad3', 3, 0, 0.01, 'linear')

		for i = 0, 3 do
			setPropertyFromGroup('strumLineNotes', i, 'visible', false)
		end
	
	elseif value2 == 'bfEnable' then
		noteTweenAlpha('bf0', 4, 1, 0.01, 'linear')
		noteTweenAlpha('bf1', 5, 1, 0.01, 'linear')
		noteTweenAlpha('bf2', 6, 1, 0.01, 'linear')
		noteTweenAlpha('bf3', 7, 1, 0.01, 'linear')

		for i = 4, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'visible', true)
		end

	elseif value2 == 'bfDisable' then
		noteTweenAlpha('bf0', 4, 0, 0.01, 'linear')
		noteTweenAlpha('bf1', 5, 0, 0.01, 'linear')
		noteTweenAlpha('bf2', 6, 0, 0.01, 'linear')
		noteTweenAlpha('bf3', 7, 0, 0.01, 'linear')

		for i = 4, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'visible', false)
		end
	
	elseif value2 == 'bothEnable' then
		noteTweenAlpha('dad0', 0, 1, 0.01, 'linear')
		noteTweenAlpha('dad1', 1, 1, 0.01, 'linear')
		noteTweenAlpha('dad2', 2, 1, 0.01, 'linear')
		noteTweenAlpha('dad3', 3, 1, 0.01, 'linear')
		noteTweenAlpha('bf0', 0, 1, 0.01, 'linear')
		noteTweenAlpha('bf1', 1, 1, 0.01, 'linear')
		noteTweenAlpha('bf2', 2, 1, 0.01, 'linear')
		noteTweenAlpha('bf3', 3, 1, 0.01, 'linear')


		for i = 0, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'visible', true)
		end

	elseif value2 == 'bothDisable' then
		noteTweenAlpha('dad0', 0, 0, 0.01, 'linear')
		noteTweenAlpha('dad1', 1, 0, 0.01, 'linear')
		noteTweenAlpha('dad2', 2, 0, 0.01, 'linear')
		noteTweenAlpha('dad3', 3, 0, 0.01, 'linear')
		noteTweenAlpha('bf0', 0, 0, 0.01, 'linear')
		noteTweenAlpha('bf1', 1, 0, 0.01, 'linear')
		noteTweenAlpha('bf2', 2, 0, 0.01, 'linear')
		noteTweenAlpha('bf3', 3, 0, 0.01, 'linear')

		for i = 0, 7 do
			setPropertyFromGroup('strumLineNotes', i, 'visible', false)
		end

	elseif value2 == 'merge' then
		local notePositions = {}

		function onUpdate()
    			notePositions = {
        			defaultPlayerStrumX0, defaultPlayerStrumX1, defaultPlayerStrumX2, defaultPlayerStrumX3,
        			defaultOpponentStrumX0, defaultOpponentStrumX1, defaultOpponentStrumX2, defaultOpponentStrumX3
    			}
    			for i = 0, 7 do
        			noteTweenX('dad0', 7, 770, 0.5, 'linear');
				noteTweenX('dad1', 6, 655, 0.5, 'linear');
				noteTweenX('dad2', 5, 540, 0.5, 'linear');
				noteTweenX('dad3', 4, 425, 0.5, 'linear');
				noteTweenX('bf0', 3, 770, 0.5, 'linear');
				noteTweenX('bf1', 2, 655, 0.5, 'linear');
				noteTweenX('bf2', 1, 540, 0.5, 'linear');
				noteTweenX('bf3', 0, 425, 0.5, 'linear');
				noteTweenAlpha('dad0_', 3, 0.25, 0.5, 'linear')
				noteTweenAlpha('dad1_', 2, 0.25, 0.5, 'linear')
				noteTweenAlpha('dad2_', 1, 0.25, 0.5, 'linear')
				noteTweenAlpha('dad3_', 0, 0.25, 0.5, 'linear')

							
    			end
		end

	else do
		debugPrint('Note Visibility Enabled')
	end
	end

    end

end