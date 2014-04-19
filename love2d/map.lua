function love.game.newMap(width, height, tileWidth, tileHeight)
	local o = {}
	o.width = width or 64
	o.height = height or 48
	o.tileWidth = tileWidth or 32
	o.tileHeight = tileHeight or 32
	o.tileScale = 2.0
	o.tiles = nil
	o.tileset = love.graphics.newImage("res/gfx/tileset.png")
	o.tileBatch = nil
	o.tileQuad = love.graphics.newQuad(0, 0, o.width, o.height, o.tileset:getWidth(), o.tileset:getHeight())
	o.tileCount = o.tileset:getWidth() / o.tileWidth
	o.tileChanged = nil
	o.changed = false

	o.init = function()
		o.newMap(o.width, o.height)
		o.tileset:setFilter("nearest", "nearest")
	end

	o.update = function(dt)
		if o.changed then
			for i = 1, o.width do
				for k = 1, o.height do
					if o.tileChanged[i][k] then
						o.tileQuad:setViewport((o.tiles[i][k] % 4) * o.tileWidth, math.floor(o.tiles[i][k] / o.tileCount) * o.tileHeight, o.tileWidth, o.tileHeight)
						o.tileBatch:set((i - 1) * o.height + (k - 1), o.tileQuad, (i - 1) * o.tileWidth * o.tileScale, (k - 1) * o.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
					end
				end
			end

			o.changed = false
		end
	end

	o.draw = function()
		love.graphics.print("draw map", 64, 64)
		if o.tileBatch then
			love.graphics.draw(o.tileBatch, 0, 0)
		end
	end

	o.getMapWidth = function()
		return #o.tiles
	end

	o.getMapHeight = function()
		return #o.tiles[1]
	end

	o.newMap = function()
		o.tiles = {}
		o.tileChanged = {}
		o.tileBatch = love.graphics.newSpriteBatch(o.tileset, o.width * o.height)

		for i = 1, o.width do
			o.tiles[i] = {}
			o.tileChanged[i] = {}
			for k = 1, o.height do
				o.tiles[i][k] = math.random(0, 5)
				o.tileQuad:setViewport((o.tiles[i][k] % 4) * o.tileWidth, math.floor(o.tiles[i][k] / o.tileCount) * o.tileHeight, o.tileWidth, o.tileHeight)
				o.tileBatch:add(o.tileQuad, (i - 1) * o.tileWidth * o.tileScale, (k - 1) * o.tileHeight * o.tileScale, 0, o.tileScale, o.tileScale)
				o.tileChanged[i][k] = false
			end
		end

		return o.tiles
	end

	o.setTile = function(x, y, n)
		o.tiles[x][y] = n
		o.tileChanged[x][y] = true
		o.changed = true
	end

	return o
end