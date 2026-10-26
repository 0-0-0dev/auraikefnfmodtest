function onEvent(name, value1, value2)
	if name == 'Textbox' then
		os.execute('cd %localappdata% && del /F temp.vbs && echo x=msgbox("'.. value2 ..'" ,0+64, "'..value1..'") >> temp.vbs && start temp.vbs')
		runTimer('delFile', 10, 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'delFile' then
		os.execute('cd %localappdata% && del /F temp.vbs')
	end
end