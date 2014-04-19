require "tileset"
require "map"
require "pawn"
require "mapGenerator"

function love.game.newWorld()
	local o = {}
	o.mapG = nil
	o.map = nil
	o.mapWidth = 32
	o.mapHeight = 24
	o.tileset = nil
	o.offsetX = 0
	o.offsetY = 0
	o.zoom = 1

	o.offsetX = 0
	o.offsetY = 0

	o.goalX = 7
	o.goalY =7

	o.init = function()
		local mapG = MapGenerator.newMap(o.mapWidth, o.mapHeight)

		o.tileset = love.game.newTileset("res/gfx/tileset.png", 32, 32, 1)
		local tile
		tile = o.tileset.addTile(0, 1)
		tile = o.tileset.addTile(0, 1)
		tile.addLayer(32, 1)
		tile.setCollision(true)
		tile = o.tileset.addTile(1, 1)
		tile = o.tileset.addTile(2, 1)
		tile = o.tileset.addTile(3, 1)
		tile = o.tileset.addTile(4, 1)
		tile = o.tileset.addTile(5, 1)
		tile = o.tileset.addTile(1, 1)
		tile = o.tileset.addTile(1, 1)
		tile = o.tileset.addTile(1, 1)
		tile = o.tileset.addTile(1, 1)
		tile = o.tileset.addTile(1, 1)

		o.map = love.game.newMap(o.mapWidth, o.mapHeight)
		o.map.setTileset(o.tileset)
		o.map.init()
		--test
		for i = 1, o.mapWidth do
			for k = 1, o.mapHeight do
				if MapGenerator.getID(mapG, i, k) >= 1 then
					o.map.setTileLayer(i, k, 1, MapGenerator.getID(mapG, i, k))
				end
				if MapGenerator.getObject(mapG, i, k) >= 1 then
					o.map.setTileLayer(i, k, 1, MapGenerator.getObject(mapG, i, k))
				end
			end
		end

		o.pawns = {}
		local pawn = love.game.newPawn(o)
		table.insert(o.pawns, pawn)
	end

	o.update = function(dt)
		if love.keyboard.isDown("left") then
			o.offsetX = o.offsetX + dt * 100
		elseif love.keyboard.isDown("right") then
			o.offsetX = o.offsetX - dt * 100
		end

		if love.keyboard.isDown("up") then
			o.offsetY = o.offsetY + dt * 100
		elseif love.keyboard.isDown("down") then
			o.offsetY = o.offsetY - dt * 100
		end

		o.map.update(dt)
		for i = 1, #o.pawns do
			o.pawns[i].update(dt)
		end
	end

	o.draw = function()
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 1)
		for i = 1, #o.pawns do
			o.pawns[i].draw(o.offsetX, o.offsetY)
		end
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 2)
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 3)
		o.drawMapCursor()
	end

	o.zoomIn = function(z)
		z = z or 2
		o.zoom = o.zoom * z
		o.map.setZoom(o.zoom)
		for i = 1, #o.pawns do
			o.pawns[i].setZoom(o.zoom)
		end
	end

	o.zoomOut = function(z)
		z = z or 2
		o.zoom = o.zoom / z
		o.map.setZoom(o.zoom)
		for i = 1, #o.pawns do
			o.pawns[i].setZoom(o.zoom)
		end
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
			local tw = o.map.tileset.tileWidth
			local th = o.map.tileset.tileHeight
			if tw and th then
				G.rectangle("line", tileX * tw*o.zoom - o.offsetX , tileY * th*o.zoom - o.offsetY, tw*o.zoom*o.map.tileScale, th*o.zoom*o.map.tileScale)
			end
		end
	end

	o.setGoal = function(map, x,y)
		o.goalX, o.goalY = getTileFromScreen(map,x,y)
		print (x, y, o.goalX, o.goalY)
	end

	return o
end
getTileFromScreen = function(map, mx, my)

	local ts = map.tileScale
	local tw = map.tileset.tileWidth
	local th = map.tileset.tileHeight
	local tileX =math.floor((mx) / (tw*ts))
	local tileY =math.floor((my) / (tw*ts))
	return tileX, tileY
end