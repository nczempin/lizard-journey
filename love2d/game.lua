love.game = {}

require "map"

function love.game.newGame()
	local o = {}
	o.map = nil

	o.init = function()
		--o.map = love.game.newMap()
	end

	o.update = function(dt)

	end

	o.draw = function()
		love.graphics.print("test", 16, 16)
		--o.map.draw()
	end

	return o
end
