--require "tileset"
require "external/map"
require "pawn"
require "mapGenerator"
require "layer/hud"
require('fire')

function love.game.newWorld()
	local o = {}
	o.mapG = nil
	o.map = nil
	o.mapWidth = 128
	o.mapHeight = 128
	o.tileset = nil
	o.layer = {}
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

		--o.tileset = love.game.newTileset("res/gfx/tileset.png", 32, 32, 1)
		o.fireGraphics = love.graphics.newImage("res/gfx/tileset.png")
		o.fireGraphics:setFilter("nearest","nearest")

		o.map = love.game.newMap(o.mapWidth * 2, o.mapHeight * 2)
		o.tileset = love.game.newTileset("res/gfx/tileset.png", 8)
		o.layer[1] = o.map.addLayer(o.tileset)
		o.layer[2] = o.map.addLayer(o.tileset)
		o.layer[3] = o.map.addLayer(o.tileset)
		o.fires = {}
		--test
		o.layer[1].startDraw()
		for i = 0, o.mapWidth * 8 - 1 do
			for k = 0, o.mapHeight * 8 - 1 do
				local id = math.random(0, 1)

				if id == 0 then
					o.layer[1].setTile(i, k, 6)
				else
					o.layer[1].setTile(i, k, 7)
				end
			end
		end
		for i = 0, o.mapWidth - 1 do
			for k = 0, o.mapHeight - 1 do
				local id = MapGenerator.getID(o.mapG, i + 1, k + 1)
				-- field
				if id == MAP_PLAIN then
					o.layer[1].setTile(i, k, 0)
				elseif id == MAP_MOUNTAIN then
					o.layer[1].setTile(i, k, 6)
				elseif id == MAP_PLAIN_DESERT then
					o.layer[1].setTile(i, k, 2)
				elseif id == MAP_MOUNTAIN_DARK then
					o.layer[1].setTile(i, k, 7)
				end
			end
		end
		o.layer[1].endDraw()

		--objects
		o.layer[2].startDraw()
		for i = 0, o.mapWidth * 8 - 1 do
			for k = 0, o.mapHeight * 8 - 1 do
				o.layer[2].setTile(i, k, 63)
			end
		end
		for i = 0, o.mapWidth - 1 do
			for k = 0, o.mapHeight - 1 do
				local id = MapGenerator.getObject(o.mapG, i + 1, k + 1)

				if id == MAP_OBJ_WATER then
					o.layer[2].setTile(i, k, 3, 3)
				elseif id == MAP_OBJ_TREE then
					o.layer[2].setTile(i, k, 22)
				elseif id == MAP_OBJ_FIREPLACE then
					--o.map.setTileLayer(i, k, 2, 18)
					o.fires[#o.fires + 1] = Fire.newFire(i + 1, k + 1, o.fireGraphics)
				elseif id == MAP_OBJ_BUSH1 then
					o.layer[2].setTile(i, k, 8)
				elseif id == MAP_OBJ_BUSH2 then
					o.layer[2].setTile(i, k, 9)
				elseif id == MAP_OBJ_BUSH3 then
					o.layer[2].setTile(i, k, 10)
				elseif id == MAP_OBJ_BUSH4 then
					o.layer[2].setTile(i, k, 11)
				elseif id == MAP_OBJ_STONE then
					o.layer[2].setTile(i, k, 24)
				else
					o.layer[2].setTile(i, k, 63)
				end
			end
		end
		o.layer[2].endDraw()

		--high objects
		o.layer[3].startDraw()
		for i = 0, o.mapWidth * 8 - 1 do
			for k = 0, o.mapHeight * 8 - 1 do
				o.layer[2].setTile(i, k, 63)
			end
		end
		for i = 0, o.mapWidth - 1 do
			for k = 0, o.mapHeight - 1 do
				local id = MapGenerator.getID(o.mapG, i + 1, k + 1)
				local object = MapGenerator.getObject(o.mapG, i + 1, k + 1)

				o.layer[3].setTile(i, k, 63)
				if object == MAP_OBJ_TREE then
					o.layer[3].setTile(i, k - 1, 14)
				elseif id == MAP_MOUNTAIN then
					o.layer[3].setTile(i, k, 6)
				elseif id == MAP_MOUNTAIN_DARK then
					o.layer[3].setTile(i, k, 7)
				else
				--o.map.setTileLayer(i, k - 1, 3, 63)
				end
			end
		end
		o.layer[3].endDraw()

		o.hudLayer = love.game.newHudLayer(o)

		o.pawns = {}
		local pawn = love.game.newPawn(1, o)
		table.insert(o.pawns, pawn)
	end

	--	o.update = function(dt)
	--
	--		if  lizGame.state == lizGame.stateManager.states.GAMEPLAY then
	--		lizGame.stateManager.states.GAMEPLAY.update()
	--		end
	--	end
	o.draw = function()
		o.layer[1].draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 0, o.zoom * 2, o.zoom * 2)
		o.layer[2].draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 0, o.zoom * 2, o.zoom * 2)
		for i,v in pairs(o.fires) do
			v.draw(o.offsetX, o.offsetY)
		end
		o.layer[3].draw(o.offsetX * o.zoom, o.offsetY * o.zoom, 0, o.zoom * 2, o.zoom * 2)
		o.drawMapCursor()

		for i = 1, #o.pawns do
			o.pawns[i].draw(o.offsetX, o.offsetY)
		end

		o.hudLayer.draw()
	end

	o.zoomIn = function(zoom)
		zoom = zoom or 2
		o.zoom = o.zoom * zoom
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
		for i = 1, #o.pawns do
			o.pawns[i].setZoom(o.zoom)
		end
		for i, v in pairs(o.fires) do
			v.setZoom(o.zoom)
		end
		o.offsetX = o.offsetX * 2
		o.offsetY = o.offsetY * 2

		o.offsetX = o.offsetX + (love.mouse.getX() - o.offsetX * o.zoom) / (o.zoom * 2)
		o.offsetY = o.offsetY + (love.mouse.getY() - o.offsetY * o.zoom) / (o.zoom * 2)
	end

	o.drawMapCursor = function()
		local mx = love.mouse.getX()
		local my = love.mouse.getY()
		local tileX, tileY = o.getTileFromScreen(mx, my)

		G.setColor(255, 63, 0)
		G.rectangle("line",
			tileX * (o.tileset.tileWidth * o.zoom) + (o.offsetX * o.zoom),
			tileY * (o.tileset.tileHeight * o.zoom) + (o.offsetY * o.zoom),
			o.tileset.tileWidth * o.zoom,
			o.tileset.tileHeight * o.zoom
		)
		G.setColor(255, 255, 255)
	end

	o.setGoal = function(map, x, y)
		o.goalX, o.goalY = o.getTileFromScreen(x, y)
	end

	o.getActivePawn = function()
		return o.pawns[1] -- TODO: 1. have multiple pawns, 2. be able to change selection
	end

	o.getTileFromScreen = function(mx, my)
		local tileX = math.floor((mx - o.offsetX * o.zoom) / (o.tileset.tileWidth * o.zoom))
		local tileY = math.floor((my - o.offsetY * o.zoom) / (o.tileset.tileHeight * o.zoom))

		return tileX, tileY
	end
	o.drawPause = function()
		-- Draw world as backdrop
		G.setColor(255, 255, 255, 255)
		o.world.draw()
		-- Draw transparent rectangle for the 'faded' effect
		local w = W.getWidth()
		local h = W.getHeight()
		G.setColor(255, 255, 255, 96)
		G.rectangle("fill", 0, 0, w, h)
		-- Draw centered (H&V) text
		G.setColor(0, 0, 0)
		local font = FONT_XLARGE
		G.setFont(font)
		G.printf("Paused.", 0, h/2 - font:getHeight()/2, w, "center")

		G.setColor(255, 255, 255)
	end

	return o
end


function love.game.newGpState(sm)
	local gpState = {name= "gameplay"}
	gpState.actions = {}

	sm.soundWaitTimer = 0 --TODO this needs to be gameplay-specific
	local gpUp = function(dt)

		-- play ambient sounds
		sm.soundWaitTimer = sm.soundWaitTimer + dt
		if sm.soundWaitTimer >= 1 then
			sm.soundWaitTimer = sm.soundWaitTimer -1
			if love.sound.ambientSound then
				love.sound.ambientSound.soundActive = true
				love.sound.ambientSound.playAmbient()
			else
				love.sound.ambientSound = getAmbientSoundGenerator()
			end
		end
		-- update time of day
		lizGame.world.timeOfDay = (lizGame.world.timeOfDay + dt)%24 -- one hour per second

		-- handle scrolling and zooming
		local mx = love.mouse.getX()
		local my = love.mouse.getY()


		if love.mouse.isDown("m") then
			lizGame.world.offsetX = (mx - lizGame.world.dragX) / lizGame.world.zoom
			lizGame.world.offsetY = (my - lizGame.world.dragY) / lizGame.world.zoom
		end

		if love.keyboard.isDown("left") then
			lizGame.world.offsetX = lizGame.world.offsetX + dt * 500
		elseif love.keyboard.isDown("right") then
			lizGame.world.offsetX = lizGame.world.offsetX - dt * 500
		end

		if love.keyboard.isDown("up") then
			lizGame.world.offsetY = lizGame.world.offsetY + dt * 500
		elseif love.keyboard.isDown("down") then
			lizGame.world.offsetY = lizGame.world.offsetY - dt * 500
		end

		--lizGame.world.map.update(dt)


		for i = 1, #lizGame.world.pawns do
			lizGame.world.pawns[i].update(dt)
		end

		--TODO fires
		--		for i = 1, lizGame.world.mapWidth do
		--			for k = 1, lizGame.world.mapHeight do
		--				if MapGenerator.getObject(lizGame.world.mapG, i, k) == MAP_OBJ_FIREPLACE then
		--					lizGame.world.map.setTileLayer(i, k, 2, 18 + math.floor((love.timer.getTime() * 10) % 4))
		--				end
		--			end
		--		end
		for i, v in pairs(lizGame.world.fires) do
			v.update(dt, lizGame.world.pawns)
		end
		--
		lizGame.world.hudLayer.update(dt)
	end
	local gpDraw = function()
		lizGame.world.draw()
	end
	local gpKeypressed = function(key, code)
		if key == "s" then
			print "saving..."
			lizGame.world.map.save("test")
		elseif key == "l" then
			print "loading..."
			lizGame.world.map.load("test")
		end
	end
	local gpMousepressed = function (x,y,key)

		if(key == "wu") then
			lizGame.world.zoomIn()
		elseif(key == "wd") then
			lizGame.world.zoomOut()
		elseif (key == "l")then
			local map = lizGame.world.map
			lizGame.world.setGoal(map, x,y)
		elseif (key == "m")then
			lizGame.world.dragX = x - lizGame.world.offsetX * lizGame.world.zoom
			lizGame.world.dragY = y - lizGame.world.offsetY * lizGame.world.zoom
		end
	end


	gpState.actions["update"] = gpUp
	gpState.actions["draw"] = gpDraw
	gpState.actions["mousepressed"] = gpMousepressed
	gpState.actions["keypressed"] = gpKeypressed
	
	return gpState
end