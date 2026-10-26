function onEvent(name, value1, value2)
	if name == 'playsound' then
	playSound(value1, value2, 'sound')
	end
end

function onPause()
    pauseSound('sound')
end

function onResume()
    resumeSound('sound')
end

function onGameOver()
    stopSound('sound')
end