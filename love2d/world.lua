require "map"

function love.game.newWorld()
	local o = {}
	o.map = nil

	o.init = function()
		o.map = love.game.newMap(16, 8, 32, 32)
		o.map.init()
		o.map.setTile(3,5,4)
	end
	
	o.update = function(dt)
		o.map.update(dt)
	end

	o.draw = function()
		o.map.draw(0, 0, 1)
		o.map.draw(0, 0, 2)
	end

	return o
end