require "tileset"
require "map"
require "pawn"
require "mapGenerator"
require "layer/hud"
require('fire')

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
	o.dragX = 0
	o.dragY = 0

	o.offsetX = 0
	o.offsetY = 0

	o.timeOfDay = 12.0
	
	--TODO right now we have just a "global" goal for pawns, since we just have one pawn and the goal is set with the mouse. For multiple pawns each should have its own goal
	o.goalX = 7
	o.goalY = 7

	o.init = function()
		o.mapG = MapGenerator.newMap(o.mapWidth, o.mapHeight)

		o.tileset = love.game.newTileset("res/gfx/tileset.png", 32, 32, 1)
		o.fireGraphics = love.graphics.newImage("res/gfx/tileset.png")

		o.map = love.game.newMap(o.mapWidth, o.mapHeight)
		o.map.setTileset(o.tileset)
		o.map.init()
		o.fires = {}
		--test
		for i = 1, o.mapWidth do
			for k = 1, o.mapHeight do
				-- field
				if MapGenerator.getID(o.mapG, i, k) == MAP_PLAIN then
					o.map.setTileLayer(i, k, 1, 0)
				elseif MapGenerator.getID(o.mapG, i, k) == MAP_MOUNTAIN then
					o.map.setTileLayer(i, k, 1, 4)
				elseif MapGenerator.getID(o.mapG, i, k) == MAP_PLAIN_DESERT then
					o.map.setTileLayer(i, k, 1, 2)
				elseif MapGenerator.getID(o.mapG, i, k) == MAP_MOUNTAIN_DARK then
					o.map.setTileLayer(i, k, 1, 5)
				end
				--objects
				if MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_WATER then
					o.map.setTileLayer(i, k, 2, 3)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_TREE then
					o.map.setTileLayer(i, k, 2, 22)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_FIREPLACE then
					--o.map.setTileLayer(i, k, 2, 18)
					o.fires[#o.fires + 1] = Fire.newFire(i, k, o.fireGraphics)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_BUSH1 then
					o.map.setTileLayer(i, k, 2, 8)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_BUSH2 then
					o.map.setTileLayer(i, k, 2, 9)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_BUSH3 then
					o.map.setTileLayer(i, k, 2, 10)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_BUSH4 then
					o.map.setTileLayer(i, k, 2, 11)
				elseif MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_STONE then
					o.map.setTileLayer(i, k, 2, 24)	
				else
					o.map.setTileLayer(i, k, 2, 63)
				end
				--objects 2
				if MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_TREE then
					o.map.setTileLayer(i, k - 1, 3, 14)
				elseif MapGenerator.getID(o.mapG, i, k) == MAP_MOUNTAIN then
					o.map.setTileLayer(i, k, 3, 4)
				elseif MapGenerator.getID(o.mapG, i, k) == MAP_MOUNTAIN_DARK then
					o.map.setTileLayer(i, k, 3, 5)
				else
					o.map.setTileLayer(i, k - 1, 3, 63)
				end
			end
		end

		o.hudLayer = love.game.newHudLayer(o)

		o.pawns = {}
		local pawn = love.game.newPawn(1, o)
		table.insert(o.pawns, pawn)
	end

	o.update = function(dt)
	-- update time of day
		o.timeOfDay = (o.timeOfDay + dt)%24 -- one hour per second
		
	
	-- handle scrolling and zooming
		local mx = love.mouse.getX()
		local my = love.mouse.getY()

		if love.mouse.isDown("m") then
			o.offsetX = (mx - o.dragX) / lizGame.world.zoom
			o.offsetY = (my - o.dragY) / lizGame.world.zoom
		end

		if love.keyboard.isDown("left") then
			o.offsetX = o.offsetX + dt * 500
		elseif love.keyboard.isDown("right") then
			o.offsetX = o.offsetX - dt * 500
		end

		if love.keyboard.isDown("up") then
			o.offsetY = o.offsetY + dt * 500
		elseif love.keyboard.isDown("down") then
			o.offsetY = o.offsetY - dt * 500
		end

		o.map.update(dt)
		for i = 1, #o.pawns do
			o.pawns[i].update(dt)
		end

		-- for i = 1, o.mapWidth do
			-- for k = 1, o.mapHeight do
				-- if MapGenerator.getObject(o.mapG, i, k) == MAP_OBJ_FIREPLACE then
					-- o.map.setTileLayer(i, k, 2, 18 + math.floor((love.timer.getTime() * 10) % 4))
				-- end
			-- end
		-- end
		for i, v in pairs(o.fires) do
			v.update(dt, o.pawns)
		end

		o.hudLayer.update(dt)
	end

	o.draw = function()
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 1)
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 2)
		o.map.draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 3)
		o.drawMapCursor()

		for i,v in pairs(o.fires) do
			v.draw(o.offsetX, o.offsetY)
		end

		for i = 1, #o.pawns do
			o.pawns[i].draw(o.offsetX, o.offsetY)
		end

		o.hudLayer.draw()
	end

	o.zoomIn = function(zoom)
		zoom = zoom or 2
		o.zoom = o.zoom * zoom
		o.map.setZoom(o.zoom)
		for i = 1, #o.pawns do
			o.pawns[i].setZoom(o.zoom)
		end
		
		for i, v in pairs(o.fires) do
			v.setZoom(o.zoom)
		end

		o.offsetX = o.offsetX * 0.5
		o.offsetY = o.offsetY * 0.5

		o.offsetX = o.offsetX - (love.mouse.getX() - o.offsetX * o.zoom) / o.zoom
		o.offsetY = o.offsetY - (love.mouse.getY() - o.offsetY * o.zoom) / o.zoom
	end

	o.zoomOut = function(zoom)
		zoom = zoom or 2
		o.zoom = o.zoom / zoom
		o.map.setZoom(o.zoom)
		for i = 1, #o.pawns do
			o.pawns[i].setZoom(o.zoom)
		end
		for i, v in pairs(o.fires) do
			v.setZoom(o.zoom)
		end
		o.offsetX = o.offsetX * 2
		o.offsetY = o.offsetY * 2
print(o.zoom)
		o.offsetX = o.offsetX + (love.mouse.getX() - o.offsetX * o.zoom) / (o.zoom * 2)
		o.offsetY = o.offsetY + (love.mouse.getY() - o.offsetY * o.zoom) / (o.zoom * 2)
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

	o.getActivePawn = function()
		return o.pawns[1] -- TODO: 1. have multiple pawns, 2. be able to change selection
	end

	o.getTileFromScreen = function(mx, my)
		local tileX = math.floor((mx - o.offsetX * o.zoom) / (o.tileset.tileWidth * o.map.tileScale * o.zoom))
		local tileY = math.floor((my - o.offsetY * o.zoom) / (o.tileset.tileHeight * o.map.tileScale * o.zoom))

		return tileX, tileY
	end

	return o
end