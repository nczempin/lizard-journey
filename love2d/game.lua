love.game = {}

require "map"

function love.game.newGame()
	local o = {}
	o.state = 1
	o.map = nil

	o.init = function()
		--o.map = love.game.newMap()
	end

	o.update = function(dt)

	end

	o.draw = function()
		if o.state == 1 then
			love.graphics.print("test", 16, 16)
		elseif o.state == 2 then
			love.graphics.print("test2", 16, 16)
		end
	end

	o.setState = function(state)
		o.state = state
	end

	return o
end
