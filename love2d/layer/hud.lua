
function love.game.newHudLayer(world)
	local o = {}
	o.world = world

	-- set font
	o.fontTitle = G.newFont(FONT_SIZE_LARGE)
	o.fontDescription = G.newFont(FONT_SIZE_MEDIUM)


	o.update = function(dt)

	end

	o.draw = function()
		G.setFont(FONT_MEDIUM)
		G.setColor(0, 206, 209)
		local water = math.floor(0.5+o.world.getActivePawn().water)
		G.print("Water: "..tostring(water).." %", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*0)


		local temperature = math.floor(0.5+o.world.getActivePawn().temperature)
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



		G.print("Temp: "..tostring(temperature).." \194\176C", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*1)
	end

	return o
end