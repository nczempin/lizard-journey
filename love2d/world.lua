require "map"
require "pawn"
require "mapGenerator"

function love.game.newWorld()
	local o = {}
	o.map = nil

	o.offsetX = 0
	o.offsetY = 0

	o.goalX = 7
	o.goalY =7

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
		local tileX, tileY = getTileFromScreen(o.map,mx, my)
		tileX = tileX * o.map.tileScale
		tileY = tileY * o.map.tileScale
		if tileX >= 0 and tileY >= 0 and tileX < o.map.width and tileY < o.map.height then
			G.setColor(255, 63, 0)
			G.setLineWidth(2)
			G.rectangle("line", tileX * o.map.tileWidth*o.map.zoom + o.offsetX, tileY * o.map.tileHeight*o.map.zoom + o.offsetY, o.map.tileWidth*o.map.zoom*o.map.tileScale, o.map.tileHeight*o.map.zoom*o.map.tileScale)

		end
	end

	o.setGoal = function(map, x,y)
		o.goalX, o.goalY = getTileFromScreen(map,x,y)
		print (x, y, o.goalX, o.goalY)
	end

	return o
end
getTileFromScreen = function(map, mx, my)

	local tileX =math.floor((mx) / (map.tileWidth*map.tileScale))
	local tileY =math.floor((my) / (map.tileHeight*map.tileScale))
	return tileX, tileY
end