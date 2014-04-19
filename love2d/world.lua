require "map"
require "pawn"
require "mapGenerator"

function love.game.newWorld()
	local o = {}
	o.map = nil

	o.offsetX = 0
	o.offsetY = 0


	o.init = function()
		o.map = love.game.newMap(160, 80, 32, 32)
		o.map.init()

		o.pawns = {}
		local pawn = love.game.newPawn(o)
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
		o.map.draw(0, 0, 2)
		for i = 1, #o.pawns do
			o.pawns[i].draw()
		end
		o.drawMapCursor()

	end
	o.drawMapCursor = function()
		local mx = love.mouse.getX()
		local my = love.mouse.getY()
		local tileX = math.floor((mx - o.offsetX) / o.map.tileWidth)
		local tileY = math.floor((my - o.offsetY) / o.map.tileHeight)

		if tileX >= 1 and tileY >= 1 and tileX < o.map.width and tileY < o.map.height then
			G.setColor(255, 63, 0)
			G.setLineWidth(2)
			G.rectangle("line", tileX * o.map.tileWidth*o.map.zoom + o.offsetX, tileY * o.map.tileHeight*o.map.zoom + o.offsetY, o.map.tileWidth*o.map.zoom*o.map.tileScale, o.map.tileHeight*o.map.zoom*o.map.tileScale)

		end
	end
	return o
end