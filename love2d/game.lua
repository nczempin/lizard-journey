love.game = {}

require "map"

function love.game.newGame()
	local o = {}
	o.state = 1
	o.map = nil

	o.x = 30
	o.y = 20
	o.xVel = 0.1
	o.yVel = -0.1

	o.init = function()
	--o.map = love.game.newMap()
	end

	o.update = function(dt)
		if o.state == 1 then
			o.x = o.x + o.xVel
			if (o.x >800 or o.x <0)then
				o.xVel = -o.xVel
			end
			o.y = o.y + o.yVel
			if (o.y >600 or o.y <0)then
				o.yVel = -o.yVel
			end
		end
	end

	o.draw = function()
		if o.state == 1 then
			love.graphics.print("test", o.x, o.y)
		elseif o.state == 2 then
			love.graphics.print("test2", 16, 16)
		end
	end

	o.setState = function(state)
		o.state = state
	end

	return o
end
