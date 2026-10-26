-- Event notes hooks
function onEvent(name, value1)
	if name == 'Cam Speed Change' then
		setProperty('cameraSpeed', value1)
	end
end