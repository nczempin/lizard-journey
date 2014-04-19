require "map"
require "pawn"
require "mapGenerator"

function love.game.newWorld()
	local o = {}
	o.map = nil

	o.init = function()
		o.map = love.game.newMap(160, 80, 32, 32)
		o.map.init()
		MapGenerator.newMap(32, 32)
		--o.map.setTile(x,y,z,tiletype)
		
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
		o.map.draw(0, 0, 1)
		for i = 1, #o.pawns do
			o.pawns[i].draw()
		end
		o.map.draw(0, 0, 2)
	end

	return o
end