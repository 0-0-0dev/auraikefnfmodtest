-- Hola mc!!!!! Si lees esto entonces algo se rompio o lo que sea, descarga de nuevo el archivo o lo que sea lolol. Ah y recomiendo que no cambies nada si no sabes que estas haciendo, y si igual lo vas a hacer, haz una copia de seguridad plz. Buen dia bro!

function onEvent(name, value1, value2)
	if name == 'InstantCameraFixated-EpicProto' then
		duracion = tonumber(value1);

		if duracion < 0 then
			duracion = 0;
		end

		numEvento = tonumber(value2);

		if numEvento == 0 then --si evento 0
			ActivarLaWeaDeLaCamaraQueNoMeSeElNombreLol = 0;
			setProperty('cameraSpeed', 1)
		end

		if numEvento == 1 then --si evento 1
			ActivarLaWeaDeLaCamaraQueNoMeSeElNombreLol = 1;
			setProperty('cameraSpeed', 99999)
		end

		if numEvento == 2 then --si evento 2 SIN USAR E USADO DE BASE
			ActivarLaWeaDeLaCamaraQueNoMeSeElNombreLol = 2;
			setProperty('cameraSpeed', duracion)
		end
	end
end

function onStepHit()
	if ActivarLaWeaDeLaCamaraQueNoMeSeElNombreLol == 1 then
		setProperty('cameraSpeed', 99999)
		setProperty('camFollowPos.x', 0)
		setProperty('camFollowPos.y', 0)
	end
	if ActivarLaWeaDeLaCamaraQueNoMeSeElNombreLol == 2 then
		setProperty('cameraSpeed', duracion)
		setProperty('camFollowPos.x', 0)
		setProperty('camFollowPos.y', 0)
	end
end 
