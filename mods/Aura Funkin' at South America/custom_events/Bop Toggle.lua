local zoomEnabled = false

function onEvent(name, value1, value2)
  if name == 'Bop Toggle' then
    if value1 == 'on' then
      zoomEnabled = true
    elseif value1 == 'off' then
      zoomEnabled = false
    end
  end
end

function onUpdate(elapsed)
  if zoomEnabled then
    setProperty('camZooming', true)
  else
    setProperty('camZooming', false)
  end
end