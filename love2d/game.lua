love.game = {}

require "world"

function love.game.newGame()
	local o = {}
	o.state = 1
	o.world = nil
	o.version = "0.0.0"

	o.x = 30
	o.y = 20
	o.xVel = 0.1
	o.yVel = -0.1

	o.init = function()
		o.world = love.game.newWorld()
		o.world.init()
	end

	o.update = function(dt)
		if o.state == states.MAIN_MENU then
			o.x = o.x + o.xVel
			if (o.x >800 or o.x <0)then
				o.xVel = -o.xVel
			end
			o.y = o.y + o.yVel
			if (o.y >600 or o.y <0)then
				o.yVel = -o.yVel
			end
		elseif o.state == states.GAMEPLAY then
			o.world.update(dt)
		end
	end

	o.draw = function()
		if o.state == states.MAIN_MENU then
			love.graphics.print("test", o.x, o.y)
		elseif o.state == states.GAMEPLAY then
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
