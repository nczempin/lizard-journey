require "tileset"
require "map"
require "pawn"
require "mapGenerator"

function love.game.newWorld()
	local o = {}
	o.map = nil
	o.tileset = nil
	o.offsetX = 0
	o.offsetY = 0
	o.zoom = 1

	o.offsetX = 0
	o.offsetY = 0


	o.init = function()
		o.tileset = love.game.newTileset("res/gfx/tileset.png", 32, 32, 1)
		local tile
		tile = o.tileset.addTile(0, 1)
		tile = o.tileset.addTile(0, 1)
		tile.addLayer(32, 1)
		tile.setCollision(true)
		tile = o.tileset.addTile(1, 1)
		tile = o.tileset.addTile(2, 1)
		tile = o.tileset.addTile(3, 1)

		o.map = love.game.newMap(80, 40)
		o.map.setTileset(o.tileset)
		o.map.init()

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
			o.pawns[i].draw()
		end
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 2)
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 3)
	end

	o.zoomIn = function(z)
		z = z or 2
		o.zoom = o.zoom * z
		o.map.setZoom(o.zoom)
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
	end

	return o
end