love.game = {}

LOVE_LAYER_LAST_CANVAS = nil

function love.game.newTileset(path, grid)
	local o = {}

	if love.filesystem.isFile(path) then
		o.img = love.graphics.newImage(path)
		o.grid = grid
		o.tileWidth = o.img:getWidth() / o.grid
		o.tileHeight = o.img:getHeight() / o.grid
	else
		local files = love.filesystem.getDirectoryItems(path)
		local count = (#files) ^ 0.5
		for i = 1, 12 do
			if count < 2 ^ i then
				o.grid = 2 ^ i
				break
			end
		end
		print(o.grid)
		local img = love.graphics.newImage(path .. "/" .. files[1])
		o.tileWidth = img:getWidth()
		o.tileHeight = img:getHeight()
		local imgData = love.image.newImageData(o.tileWidth * o.grid, o.tileHeight * o.grid)
		local n = 0
		for i, file in ipairs(files) do
			img = love.graphics.newImage(path .. "/" .. file)
			for k = 1, img:getHeight() / o.tileHeight do
				for l = 1, img:getWidth() / o.tileWidth do
					imgData:paste(img:getData(), (n % o.grid) * o.tileWidth, math.floor(n / o.grid) * o.tileHeight, (l - 1) * o.tileHeight, (k - 1) * o.tileWidth, o.tileWidth, o.tileHeight)
					n = n + 1
				end
			end
			print(i .. ". " .. file)
		end

		o.img = love.graphics.newImage(imgData)
	end
	o.img:setFilter("nearest", "nearest")

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

	o.load = function(path)
		love.graphics.setColor(255, 255, 255)
		for i = 1, #o.layer do
			local img = love.graphics.newImage(path .. "_" .. i .. ".png")
			LOVE_LAYER_LAST_CANVAS = love.graphics.getCanvas()
			love.graphics.setCanvas(o.layer[i].canvas)
			love.graphics.draw(img)
			love.graphics.setCanvas(LOVE_LAYER_LAST_CANVAS)
		end
	end

	o.save = function(path)
		for i = 1, #o.layer do
			o.layer[i].canvas:getImageData():encode(path .. "_" .. i .. ".png")
		end
	end

	return o
end