require "map"

function love.game.newWorld()
	local o = {}
	o.map = nil

	o.init = function()
		o.map = love.game.newMap(16, 8, 32, 32)
	end
	
	o.update = function(dt)
		o.map.update(dt)
	end

	o.draw = function()
		o.map.draw()
	end

	return o
end