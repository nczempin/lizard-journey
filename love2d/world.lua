require "tileset"
require "map"
require "pawn"
require "mapGenerator"
require "layer/hud"

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

	--TODO right now we have just a "global" goal for pawns, since we just have one pawn and the goal is set with the mouse. For multiple pawns each should have its own goal
	o.goalX = 7
	o.goalY =7

	o.init = function()
		o.mapG = MapGenerator.newMap(o.mapWidth, o.mapHeight)

		o.tileset = love.game.newTileset("res/gfx/tileset.png", 32, 32, 1)

		o.map = love.game.newMap(o.mapWidth, o.mapHeight)
		o.map.setTileset(o.tileset)
		o.map.init()
		--test
		for i = 1, o.mapWidth do
			for k = 1, o.mapHeight do
				-- field
				if MapGenerator.getID(o.mapG, i, k) == 1 then
					o.map.setTileLayer(i, k, 1, 0)
				elseif MapGenerator.getID(o.mapG, i, k) == 2 then
					o.map.setTileLayer(i, k, 1, 2)
				end
				--objects
				if MapGenerator.getObject(o.mapG, i, k) == 1 then
					o.map.setTileLayer(i, k, 2, 3)
				elseif MapGenerator.getObject(o.mapG, i, k) == 2 then
					o.map.setTileLayer(i, k, 2, 22)
				elseif MapGenerator.getObject(o.mapG, i, k) == 4 then
					o.map.setTileLayer(i, k, 2, 18)
				else
					o.map.setTileLayer(i, k, 2, 63)
				end
				--objects 2
				if MapGenerator.getObject(o.mapG, i, k) == 2 then
					o.map.setTileLayer(i, k - 1, 3, 14)
				else
					o.map.setTileLayer(i, k - 1, 3, 63)
				end
			end
		end

		o.hudLayer = love.game.newHudLayer()

		o.pawns = {}
		local pawn = love.game.newPawn(1, o)
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

		for i = 1, o.mapWidth do
			for k = 1, o.mapHeight do
				if MapGenerator.getObject(o.mapG, i, k) == 4 then
					o.map.setTileLayer(i, k, 2, 18 + math.floor((love.timer.getTime() * 10) % 4))
				end
			end
		end

		o.hudLayer.update(dt)
	end

	o.draw = function()
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 1)
		for i = 1, #o.pawns do
			o.pawns[i].draw(o.offsetX, o.offsetY)
		end
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 2)
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 3)
		o.drawMapCursor()

		o.hudLayer.draw()
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
		local tileX, tileY = o.getTileFromScreen(mx, my)

		G.setColor(255, 63, 0)
		G.rectangle("line",
			tileX * (o.tileset.tileWidth * o.map.tileScale * o.zoom) + (o.offsetX * o.zoom),
			tileY * (o.tileset.tileHeight * o.map.tileScale * o.zoom) + (o.offsetY * o.zoom),
			o.tileset.tileWidth * o.map.tileScale * o.zoom,
			o.tileset.tileHeight * o.map.tileScale * o.zoom
		)
	end

	o.setGoal = function(map, x, y)
		o.goalX, o.goalY = o.getTileFromScreen(x, y)
	end

	o.getTileFromScreen = function(mx, my)
		local tileX = math.floor((mx - o.offsetX * o.zoom) / (o.tileset.tileWidth * o.map.tileScale * o.zoom))
		local tileY = math.floor((my - o.offsetY * o.zoom) / (o.tileset.tileHeight * o.map.tileScale * o.zoom))

		return tileX, tileY
	end

	return o
end