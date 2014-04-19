
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
		local water = math.floor(0.5+o.world.pawns[1].water)
		G.print("Water: "..tostring(water).." %", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*0)
		G.setColor(0, 255, 127)
		local temperature = math.floor(0.5+o.world.pawns[1].temperature)
		G.print("Temp: "..tostring(temperature).." \194\176C", FONT_SIZE_MEDIUM*0, FONT_SIZE_MEDIUM*1)
	end

	return o
end