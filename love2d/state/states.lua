if not love then
	love = {}
	love.game = {}
end

love.game.newStateManager = function()
	local o = {}
	-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over, 5 = Credits
	--states = {"main menu", "gameplay", "load", "settings", "game over", "credits", "settings/video","settings/video/advanced", "paused"}


	--TODO: move to main_menu.lua
	local mmState = {name= "main_menu"}
	mmState.actions = {}

	local mmUp = function(dt)
		lizGame.main_menu.update(dt)
		if lizGame.main_menu.playButton.hit then
			o.fsm:fire("startGame")
		elseif lizGame.main_menu.creditsButton.hit then
			o.fsm:fire("gotoCredits")
		elseif lizGame.main_menu.exitButton.hit then
			love.event.quit() --TODO: more elegant exit transition
		end
	end

	local mmDraw = function()
		lizGame.drawBackgroundImage()
		lizGame.main_menu.draw()
		lizGame.drawTitle("The Tale of Some Reptile")

	end

	local mmKeypressed = function (key, code)
	end
	local mmMousepressed = function (x,y,key)
		print ("main menu mouse: ",x,y,key)
	end
	local mmTransition = function()
		love.sounds.playBgm("lizardViolinSession")
	end

	mmState.actions["update"] = mmUp
	mmState.actions["draw"] = mmDraw
	mmState.actions["keypressed"] = mmKeypressed
	mmState.actions["mousepressed"] = mmMousepressed


	--TODO: move to world/gameplay
	local gpState = {name= "gameplay"}
	gpState.actions = {}

	local gpUp = function(dt)

		-- play ambient sounds
		o.soundWaitTimer = o.soundWaitTimer + dt
		if o.soundWaitTimer >= 1 then
			o.soundWaitTimer = o.soundWaitTimer -1
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
			--			print (".")
			lizGame.world.dragX = x - lizGame.world.offsetX * lizGame.world.zoom
			lizGame.world.dragY = y - lizGame.world.offsetY * lizGame.world.zoom
		end
	end


	gpState.actions["update"] = gpUp
	gpState.actions["draw"] = gpDraw
	gpState.actions["mousepressed"] = gpMousepressed
	gpState.actions["keypressed"] = gpKeypressed

	local pausedState = {name = "paused"}
	pausedState.actions = {}


	--TODO: move to credits
	local creditsState = {name = "credits"}


	--TODO: move to init
	local initState = {name = "init"}

	o.states = {init = initState,main_menu=mmState,gameplay=gpState,credits=creditsState,paused=pausedState}

	o.states.MAIN_MENU = o.states["main_menu"]
	o.states.MAIN_MENU.transition = mmTransition

	o.states.GAMEPLAY = o.states["gameplay"]
	o.states.GAMEPLAY.transition = function()
		love.sounds.playBgm(nil)
	end

	o.soundWaitTimer = 0 --TODO this needs to be gameplay-specific
	o.states.GAMEPLAY.update = function(dt)
	end
	o.states.CREDITS = o.states["credits"]
	creditsState.actions = {}
	o.states.CREDITS.update= function(dt)
	end
	local crUp = function(dt)
		o.states.CREDITS.update(dt)
	end
	o.states.CREDITS.draw= function()
		lizGame.credits.drawCredits()
	end
	local crDraw = function()
		o.states.CREDITS.draw()
	end

	o.states.CREDITS.transition = function()
		S.playBgm("battleIntro")
	end

	local crMousepressed = function()
		print "firing gotoMainMenu"
		o.fsm:fire("gotoMainMenu")
	end
	local crKeypressed = function()
		print "firing gotoMainMenu"
		o.fsm:fire("gotoMainMenu")
	end
	creditsState.actions["keypressed"] = crKeypressed
	creditsState.actions["mousepressed"] = crMousepressed


	creditsState.actions["update"] = crUp
	creditsState.actions["draw"] = crDraw

	o.states.PAUSED = o.states["paused"]


	o.FSM = require "external/fsm"

	local function action1()
		print("transition from mm to gp")
		return "hurz"
	end

	local function action2() print("transition from gp to mm") end


	-- Define your state transitions here
	local myStateTransitionTable = {

			{o.states.MAIN_MENU.name, "startGame", o.states.GAMEPLAY.name,o.states.GAMEPLAY.transition},
			{"*", "startGame", o.states.GAMEPLAY.name,o.states.GAMEPLAY.transition},
			{"*", "gotoCredits", o.states.CREDITS.name,o.states.CREDITS.transition},
			--		{o.states.GAMEPLAY.name, "gotoMainMenu", o.states.MAIN_MENU.name},
			{"*", "gotoMainMenu", o.states.MAIN_MENU.name,o.states.MAIN_MENU.transition},
			{"*",      "*", "*", function() print "unknown transition" end},  -- for any state
	}

	-- Create your instance of a finite state machine
	o.fsm = o.FSM.new(myStateTransitionTable)
	local genericUpdate = function(name, dt)
		local state = o.states[name]

		--print "update action..."
		if state and state.actions then
			if state.actions["update"] then
				state.actions.update(dt)
			end
		end
		--		print "...update done."
	end

	o.keypressed = function(key,code)
		print ("key, code: ",key,code)
		local		stateId = o.fsm:get()
		local state = o.states[stateId]

		--global keys
		if (key == "f1")then
			print "firing gotoMainMenu"
			o.fsm:fire("gotoMainMenu")
			return
		elseif key == "f2" then
			print "firing startGame"
			o.fsm:fire("startGame")
			return
		elseif key == "f3" then
			print "firing gotoCredits"
			o.fsm:fire("gotoCredits")
			return
		end

		if state and state.actions then
			if state.actions["keypressed"] then
				state.actions.keypressed(key, code)
			end
		end
	end
	o.mousepressed = function(x,y,key)
		local	stateId = o.fsm:get()
		local state = o.states[stateId]
		if state and state.actions then
			if state.actions["mousepressed"] then
				state.actions.mousepressed(x,y,key)
			end
		end
	end

	o.update = function(dt)
		local stateId = o.fsm:get()
		local state = o.states[stateId]

		--print "update action..."
		if state and state.actions then
			if state.actions.update then
				state.actions.update(dt)
			end
		end
	end
	o.draw = function()
		local stateId = o.fsm:get()
		local state = o.states[stateId]

		if state and state.actions then
			if state.actions.draw then
				state.actions.draw()
			end
		end
	end

	o.fsm:fire("gotoMainMenu") --TODO go to init/intro?

	return o
end
--	if lizGame.state == lizGame.stateManager.states.PAUSED then
--		print "paused"
--	else
--		if key == "1" then
--			lizGame.setState(lizGame.stateManager.states.MAIN_MENU)
--		elseif key == "2" then
--			print "2"
--			lizGame.setState(lizGame.stateManager.states.GAMEPLAY)
--		elseif key == "3" then
--			lizGame.setState(lizGame.stateManager.states.CREDITS)
--		end
	--	end
	--
	--
	--	-- Toggle pause, but only to/from GAME_PLAY
	--	if lizGame.state == lizGame.stateManager.states.GAMEPLAY or lizGame.state == lizGame.stateManager.states.PAUSED then
	--		if key == "p" then
	--			if lizGame.state == lizGame.stateManager.states.GAMEPLAY then
	--				lizGame.setState(lizGame.stateManager.states.PAUSED)
	--			elseif lizGame.state == lizGame.stateManager.states.PAUSED then
	--				lizGame.setState(lizGame.stateManager.states.GAMEPLAY)
	--			end
	--		end
	--	end