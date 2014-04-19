require "map"
require "pawn"

function love.game.newWorld()
	local o = {}
	o.map = nil

	o.init = function()
		o.map = love.game.newMap(16, 8, 32, 32)
		o.map.init()
		
		o.pawns = {}
		local pawn = love.game.newPawn()
		table.insert(o.pawns, pawn)
	end
	
	o.update = function(dt)
	--love.graphics.clear()
		o.map.update(dt)
		for i = 1, #o.pawns do
			o.pawns[i].update(dt)
		end
	end

	o.draw = function()
		
		o.map.draw()
		for i = 1, #o.pawns do
			o.pawns[i].draw()
		end
		
	end

	return o
end