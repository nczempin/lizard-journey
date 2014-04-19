function love.game.newMap(width, height, tileWidth, tileHeight, layer)
	local o = {}
	o.width = width or 64
	o.height = height or 48
	o.layer = layer or 2
	o.tileWidth = tileWidth or 32
	o.tileHeight = tileHeight or 32
	o.tileScale = 2.0
	o.tiles = nil
	o.tileset = nil
	o.tileBatch = nil
	o.tileQuad = nil
	o.tileCount = nil
	o.tileChanged = nil
	o.zoom = 1.0
	o.changed = false

	o.init = function()
		o.tileset = {}
		o.tileQuad = {}
		o.tileCount = {}
		for i = 1, o.layer do
			o.tileset[i] = love.graphics.newImage("res/gfx/layer" .. i .. ".png")
			o.tileset[i]:setFilter("nearest", "nearest")
			o.tileQuad[i] = love.graphics.newQuad(0, 0, o.width, o.height, o.tileset[i]:getWidth(), o.tileset[i]:getHeight())
			o.tileCount[i] = o.tileset[i]:getWidth() / o.tileWidth
		end
		o.newMap(o.width, o.height)
	end

	o.update = function(dt)
		if o.changed then
			for i = 1, o.width do
				for k = 1, o.height do
					for l = 1, o.layer do
						if o.tileChanged[i][k][l] then
							o.tileQuad[l]:setViewport((o.tiles[i][k] % o.tileCount[l]) * o.tileWidth, math.floor(o.tiles[i][k][l] / o.tileCount[l]) * o.tileHeight, o.tileWidth, o.tileHeight)
							o.tileBatch[l]:set((i - 1) * o.height + (k - 1), o.tileQuad, (i - 1) * o.tileWidth * o.tileScale, (k - 1) * o.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
						end
					end
				end
			end

			o.changed = false
		end
	end

	o.draw = function(x, y, z)
		love.graphics.setColor(255,255,255)
		if o.tileBatch[z] then
			love.graphics.draw(o.tileBatch[z], x, y, 0, o.zoom, o.zoom)
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
		o.tileBatch = {}

		for i = 1, o.layer do
			o.tileBatch[i] = love.graphics.newSpriteBatch(o.tileset[i], o.width * o.height)
		end

		for i = 1, o.width do
			o.tiles[i] = {}
			o.tileChanged[i] = {}
			for k = 1, o.height do
				o.tiles[i][k] = {}
				o.tileChanged[i][k] = {}
				for l = 1, o.layer do
					o.tiles[i][k][l] = math.random(0, l * 5)
					o.tileQuad[l]:setViewport((o.tiles[i][k][l] % o.tileCount[l]) * o.tileWidth, math.floor(o.tiles[i][k][l] / o.tileCount[l]) * o.tileHeight, o.tileWidth, o.tileHeight)
					o.tileBatch[l]:add(o.tileQuad[l], (i - 1) * o.tileWidth * o.tileScale, (k - 1) * o.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
					o.tileChanged[i][k][l] = false
				end
			end
		end

		return o.tiles
	end

	o.getTile = function(x, y, z)
		return o.tiles[x][y][z]
	end

	o.setTile = function(x, y, z, n)
		o.tiles[x][y][z] = n
		o.tileChanged[x][y][z] = true
		o.changed = true
	end

	o.zoomIn = function(z)
		z = z or 2
		o.zoom = o.zoom * z
	end

	o.zoomOut = function(z)
		z = z or 2
		o.zoom = o.zoom / z
	end

	return o
end