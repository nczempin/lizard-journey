love.game = {}

LOVE_LAYER_LAST_CANVAS = nil

function love.game.newTileset(path, grid)
	local o = {}

	o.img = love.graphics.newImage(path)
	o.img:setFilter("nearest", "nearest")
	o.grid = grid
	o.tileWidth = o.img:getWidth() / grid
	o.tileHeight = o.img:getHeight() / grid

	return o
end

function love.game.newLayer(width, height, tileset)
	local o = {}

	o.width = width
	o.height = height
	o.tileset = tileset
	o.canvas = love.graphics.newCanvas(o.width, o.height)
	o.canvas:setFilter("nearest", "nearest")
	o.shader = love.graphics.newShader("res/shader/tileset.glsl")
	o.shader:send("tileset", o.tileset.img)
	o.shader:send("grid", o.tileset.grid)
	o.shader:send("size", {o.width, o.height})

	o.draw = function(x, y, r, sx, sy, ...)
		love.graphics.setColor(255, 255, 255)
		love.graphics.setShader(o.shader)
		o.shader:send("time", math.floor(love.timer.getTime() * 5))
		love.graphics.draw(o.canvas, x or 0, y or 0, r or 0, (sx or 1) * 16, (sy or 1) * 16, ...)
		love.graphics.setShader()
	end

	o.startDraw = function()
		LOVE_LAYER_LAST_CANVAS = love.graphics.getCanvas()
		love.graphics.setShader()
		love.graphics.setCanvas(o.canvas)
	end

	o.endDraw = function()
		love.graphics.setCanvas(LOVE_LAYER_LAST_CANVAS)
	end

	o.setTile = function(x, y, n, frames)
		love.graphics.setPointStyle("rough")
		love.graphics.setColor(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0)
		love.graphics.point(x, y)
	end

	o.setTileRectangle = function(x, y, width, height, n, frames)
		love.graphics.setColor(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0)
		love.graphics.rectangle("fill", x, y, width, height)
	end

	o.setTileCircle = function(x, y, r, n, frames)
		love.graphics.setColor(math.mod(n, o.tileset.grid), math.floor(n / o.tileset.grid), frames or 0)
		love.graphics.circle("fill", x, y, r)
	end

	return o
end

function love.game.newMap(width, height)
	local o = {}

	o.layer = {}
	o.width = width or 256
	o.height = height or 256

	o.draw = function(x, y, r, sx, sy, ...)
		love.graphics.setColor(255, 255, 255)
		for i = 1, #o.layer do
			love.graphics.setShader(o.layer[i].shader)
			o.layer[i].shader:send("time", math.floor(love.timer.getTime() * 5))
			love.graphics.draw(o.layer[i].canvas, x or 0, y or 0, r or 0, (sx or 1) * 16, (sy or 1) * 16, ...)
		end
		love.graphics.setShader()
	end

	o.addLayer = function(tileset)
		o.layer[#o.layer + 1] = love.game.newLayer(o.width, o.height, tileset)

		return o.layer[#o.layer]
	end

	return o
end