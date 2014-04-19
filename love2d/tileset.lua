require "tile"

function love.game.newTileset(path, tileWidth, tileHeight)
	local o = {}
	o.img = love.graphics.newImage(path)
	o.img:setFilter("nearest", "nearest")
	o.tileWidth = tileWidth
	o.tileHeight = tileHeight
	o.quad = love.graphics.newQuad(0, 0, o.tileWidth, o.tileHeight, o.img:getWidth(), o.img:getHeight())
	o.count = o.img:getWidth() / o.tileWidth
	o.maxLayer = 3
	o.batch = {}
	o.batch[1] = love.graphics.newSpriteBatch(o.img, 9999)
	o.batch[2] = love.graphics.newSpriteBatch(o.img, 9999)
	o.batch[3] = love.graphics.newSpriteBatch(o.img, 9999)
	o.tiles = {}

	o.init = function()

	end

	o.update = function(dt)

	end

	o.draw = function()

	end

	o.isID = function(id, layer)
		if o.tiles[id] and o.tiles[id].isLayer(layer) then
			return true
		else
			return false
		end
	end

	o.getID = function(id, layer)
		return o.tiles[id].getID(layer)
	end

	o.addTile = function(id, count)
		o.tiles[#o.tiles + 1] = love.game.newTile(id, count)

		return o.tiles[#o.tiles]
	end

	return o
end