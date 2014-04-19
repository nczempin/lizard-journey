function love.game.newPawn()
	local o = {}

	o.x = 500
	o.y = 300

	o.update = function(dt)

	end

	o.draw = function()
		love.graphics.rectangle("fill", o.x,o.y, 64,64)
	end
	return o
end

