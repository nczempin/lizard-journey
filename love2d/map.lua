require "mapGenerator"

function love.game.newMap(width, height, layer)
	local o = {}
	o.width = width or 64
	o.height = height or 48
	o.layer = layer or 1
	o.tileScale = 2.0
	o.tiles = nil
	o.tileset = nil
	o.tileChanged = nil
	o.zoom = 1.0
	o.changed = false

	o.init = function()
		o.newMap(o.width, o.height)
	end

	o.update = function(dt)
	
	end

	o.draw = function(x, y, z)
		love.graphics.setColor(255, 255, 255)
		if o.tileset.batch[z] then
			love.graphics.draw(o.tileset.batch[z], x, y, 0, o.zoom, o.zoom)
		end
	end

	o.getMapWidth = function()
		return #o.tiles
	end

	o.getMapHeight = function()
		return #o.tiles[1]
	end

	o.getMapLayer = function()
		return #o.tiles[1][1]
	end

	o.newMap = function()
		o.tiles = {}
		o.tileChanged = {}

		for i = 1, o.width do
			o.tiles[i] = {}
			o.tileChanged[i] = {}
			for k = 1, o.height do
				o.tiles[i][k] = {}
				o.tileChanged[i][k] = {}
				-- create data
				for l = 1, o.layer do
					o.tiles[i][k][l] = 0
					o.tileChanged[i][k][l] = false
				end

				-- create batch
				o.tileset.quad:setViewport(0, 0, o.tileset.tileWidth, o.tileset.tileHeight)
				o.tileset.batch[1]:add(o.tileset.quad, (i - 1) * o.tileset.tileWidth * o.tileScale, (k - 1) * o.tileset.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
				o.tileset.batch[2]:add(o.tileset.quad, (i - 1) * o.tileset.tileWidth * o.tileScale, (k - 1) * o.tileset.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
				o.tileset.batch[3]:add(o.tileset.quad, (i - 1) * o.tileset.tileWidth * o.tileScale, (k - 1) * o.tileset.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
			end
		end

		return o.tiles
	end

	o.setTileset = function(tileset)
		o.tileset = tileset
	end

	o.getTile = function(x, y, z)
		return o.tiles[x][y][z]
	end

	o.setTile = function(x, y, z, n)
		o.tiles[x][y][z] = n
		o.tileChanged[x][y][z] = true
		o.changed = true
	end

	o.setTileLayer = function(x, y, z, n)
		o.tileset.quad:setViewport((n % o.tileset.count) * o.tileset.tileWidth, math.floor(n / o.tileset.count) * o.tileset.tileHeight, o.tileset.tileWidth, o.tileset.tileHeight)
		o.tileset.batch[z]:set((x - 1) * o.height + (y - 1),o.tileset.quad, (x - 1) * o.tileset.tileWidth * o.tileScale, (y - 1) * o.tileset.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
	end

	o.setZoom = function(zoom)
		o.zoom = zoom
	end

	o.zoomIn = function(zoom)
		z = z or 2
		o.zoom = o.zoom * zoom
	end

	o.zoomOut = function(zoom)
		z = z or 2
		o.zoom = o.zoom / zoom
	end

	return o
end