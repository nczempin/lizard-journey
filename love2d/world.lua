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

		if tileX >= 0 and tileY >= 0 and tileX < o.map.width and tileY < o.map.height then
			--			if o.map.data[tileX + 1][tileY + 1].id == 0 then
			--				G.setColor(0, 127, 255)
			--				G.draw(o.mapCursorNormal, tileX * o.map.tileWidth + o.offsetX, tileY * o.map.tileHeight + o.offsetY)
			--			else
			G.setColor(255, 63, 0)
			G.setLineWidth(2)
			G.rectangle("line", tileX * o.map.tileWidth*o.map.zoom + o.offsetX, tileY * o.map.tileHeight*o.map.zoom + o.offsetY, o.map.tileWidth*o.map.zoom*o.map.tileScale, o.map.tileHeight*o.map.zoom*o.map.tileScale)

			G.setColor(255, 255, 255)

			--				G.draw(tower.upper, tileX * o.map.tileWidth + o.offsetX, tileY * o.map.tileHeight - (tower.img:getHeight() - o.map.tileHeight) + o.offsetY)

			G.setColor(255, 63, 0)
			--			G.draw(o.mapCursorBlock, tileX * o.map.tileWidth + o.offsetX + o.map.tileWidth * 0.5, tileY * o.map.tileHeight + o.offsetY + o.map.tileHeight * 0.5, 0, 0.95 - math.sin(o.effectTimer * 5.0) * 0.05, 0.95 - math.sin(o.effectTimer * 5.0) * 0.05, o.map.tileWidth * 0.5, o.map.tileHeight * 0.5)
			--			end
		end
	end
	return o
end