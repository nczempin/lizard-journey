require "state/menus/main_menu"
require "state/menus/credits"

if not love then
	love = {}
	love.game = {}
end

function love.game.newStateManager(menus)
	local o = {}
	--states = {"main menu", "gameplay", "load", "settings", "game over", "credits", "settings/video","settings/video/advanced", "paused"}
	print (lizGame.menus)
	local mmState = lizGame.menus.main_menu.newMmState(o)


	local gpState = love.game.newGpState(o)


	local pausedState = {name = "paused"}
	pausedState.actions = {}


	local creditsState = love.game.newCrState(o)

	--TODO: move to init
	local initState = {name = "init"}

	o.states = {init = initState,main_menu=mmState,gameplay=gpState,credits=creditsState,paused=pausedState}

	o.states.CREDITS = o.states["credits"]
	o.states.CREDITS.transition = function()
		S.playBgm("battleIntro")
	end

	o.states.MAIN_MENU = o.states["main_menu"]
	o.states.MAIN_MENU.transition = mmState.actions["transition"]

	o.states.GAMEPLAY = o.states["gameplay"]
	o.states.GAMEPLAY.transition = function()
		love.sounds.playBgm(nil)
	end

	o.states.GAMEPLAY.update = function(dt)
	end



	--TODO	o.states.PAUSED = o.states["paused"]



	--general state code; this should stay here.

	o.FSM = require "external/fsm"
	local myStateTransitionTable = {

			{o.states.MAIN_MENU.name, "startGame", o.states.GAMEPLAY.name,o.states.GAMEPLAY.transition},
			{"*", "startGame", o.states.GAMEPLAY.name,o.states.GAMEPLAY.transition},
			{"*", "gotoCredits", o.states.CREDITS.name,o.states.CREDITS.transition},
			--		{o.states.GAMEPLAY.name, "gotoMainMenu", o.states.MAIN_MENU.name},
			{"*", "gotoMainMenu", o.states.MAIN_MENU.name,o.states.MAIN_MENU.transition},
			{"*",      "*", "*", function() print "unknown transition" end},  -- for any state
	}

	o.fsm = o.FSM.new(myStateTransitionTable)
	local genericUpdate = function(name, dt)
		local state = o.states[name]

		if state and state.actions then
			if state.actions["update"] then
				state.actions.update(dt)
			end
		end
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