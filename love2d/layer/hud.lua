
function love.game.newHudLayer(world)
	local o = {}
	o.world = world

	-- set font
	o.fontTitle = G.newFont(FONT_SIZE_LARGE)
	o.fontDescription = G.newFont(FONT_SIZE_MEDIUM)


	o.update = function(dt)

	end

	o.setColour = function(temperature)
		if (temperature >= 50) then
			G.setColor(255, 0, 0) --red
		elseif (temperature >= 43) then
			G.setColor(255, 165, 0) --orange
		elseif (temperature >=38) then
			G.setColor(255, 215, 0) --yellow
		elseif (temperature >= 33) then
			G.setColor(0, 255, 127) --green
		elseif (temperature >= 25) then
			G.setColor(46, 139, 87) --blue/green
		else
			G.setColor(0, 0, 255) --blue
		end

	end
	o.draw = function()
		local pawn = o.world.getActivePawn()
		G.setFont(FONT_MEDIUM)
		G.setColor(0, 206, 209)

		line = 0

		local water = math.floor(0.5+pawn.water)
		G.print("Water: "..tostring(water).." %", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*line)


		line = line + 1
		local temperature = math.floor(0.5+ pawn.temperature)

		o.setColour(temperature)
		G.print("Body temperature: "..tostring(temperature).." C", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*line)



		line = line + 1
		local ambientTemperature = math.floor(0.5+ pawn.ambientTemperature)

		o.setColour(ambientTemperature)

		G.print("Ambient temperature: "..tostring(ambientTemperature).." C", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*line)

		local timeOfDay =math.floor( o.world.timeOfDay)
		line = line + 1
		G.setColor(0,0,0)

		G.print("Time of day: "..tostring(timeOfDay)..":00", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*line)

	end

	return o
end