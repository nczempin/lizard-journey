love.game = {}

require "world"

function love.game.newGame()
	local o = {}
	o.state = 1
	o.world = nil
	o.version = "0.0.0"

	o.init = function()
		o.world = love.game.newWorld()
		o.world.init()
	end

	o.update = function(dt)
		if o.state == 1 then
			love.graphics.print("test", 16, 16)
		elseif o.state == 2 then
			o.world.update(dt)
		end
	end

	o.draw = function()
		if o.state == 1 then
			love.graphics.print("test", 16, 16)
		elseif o.state == 2 then
			o.world.draw()
		end
	end

	o.setState = function(state)
		o.state = state
	end

	o.setVersion = function(version)
		o.version = version
	end

	return o
end
