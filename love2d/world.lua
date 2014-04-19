require "tileset"
require "mapGenerator"
require "map"
require "pawn"

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


	o.init = function()
<<<<<<< HEAD
		o.map = love.game.newMap(16, 8, 32, 32)
		o.map.init()
		
=======
		mapG = MapGenerator.newMap(o.mapWidth, o.mapHeight)
		MapGenerator.printMap(mapG)
		print(MapGenerator.getID(mapG, 1, 1))

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
		tile = o.tileset.addTile(6, 1)
		tile = o.tileset.addTile(7, 1)
		tile = o.tileset.addTile(8, 1)
		tile = o.tileset.addTile(9, 1)
		tile = o.tileset.addTile(10, 1)

		o.map = love.game.newMap(o.mapWidth, o.mapHeight)
		o.map.setTileset(o.tileset)
		o.map.init()
		--test
		for i = 1, o.mapWidth do
			for k = 1, o.mapHeight do
				print(MapGenerator.getID(mapG, i, k))
				o.map.setTile(i, k, 1, MapGenerator.getID(mapG, i, k))
			end
		end

>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
		o.pawns = {}
		local pawn = love.game.newPawn()
		table.insert(o.pawns, pawn)
	end
	
	o.update = function(dt)
<<<<<<< HEAD
	--love.graphics.clear()
=======
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

>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
		o.map.update(dt)
		for i = 1, #o.pawns do
			o.pawns[i].update(dt)
		end
	end

	o.draw = function()
<<<<<<< HEAD
		o.map.draw(0, 0, 1)
=======
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 1)
>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
		for i = 1, #o.pawns do
			o.pawns[i].draw(o.offsetX, o.offsetY)
		end
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 2)
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 3)
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
		local tileX = o.map.tileScale*math.floor((mx - o.offsetX) / (o.map.tileWidth*o.map.tileScale))
		local tileY = o.map.tileScale*math.floor((my - o.offsetY) / (o.map.tileHeight*o.map.tileScale))

		if tileX >= 1 and tileY >= 1 and tileX < o.map.width and tileY < o.map.height then
			G.setColor(255, 63, 0)
			G.setLineWidth(2)
			G.rectangle("line", tileX * o.map.tileWidth*o.map.zoom + o.offsetX, tileY * o.map.tileHeight*o.map.zoom + o.offsetY, o.map.tileWidth*o.map.zoom*o.map.tileScale, o.map.tileHeight*o.map.zoom*o.map.tileScale)

		end
<<<<<<< HEAD
		o.map.draw(0, 0, 2)
=======
>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
	end

	return o
end