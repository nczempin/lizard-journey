if not love then
	love = {}
	love.game = {}
end

love.game.newStateManager = function()
	local o = {}
	-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over, 5 = Credits
	--states = {"main menu", "gameplay", "load", "settings", "game over", "credits", "settings/video","settings/video/advanced", "paused"}
	local mmState = {name= "main_menu"}
	mmState.actions = {}

	local mmUp = function()
		print "update main menu"
	end
	mmState.actions["update"] = mmUp

	local gpState = {name= "gameplay"}
	gpState.actions = {}

	local gpUp = function()
		print "playing da game"
	end
	gpState.actions["update"] = gpUp

	local creditsState = {name = "credits"}
	creditsState.actions = {}
	local pausedState = {name = "paused"}
	pausedState.actions = {}

	o.states = {main_menu=mmState,gameplay=gpState,credits=creditsState,paused=pausedState}


	o.states.MAIN_MENU = o.states["main_menu"]
	o.states.GAMEPLAY = o.states["gameplay"]
	o.states.CREDITS = o.states["credits"]
	o.states.PAUSED = o.states["paused"]


	o.FSM = require "external/fsm"

	local function action1()
		print("transition from mm to gp")
		return "hurz"
	end

	local function action2() print("transition from gp to mm") end


	-- Define your state transitions here
	local myStateTransitionTable = {
		{o.states.MAIN_MENU.name, "startGame", o.states.GAMEPLAY.name, action1},
		{o.states.GAMEPLAY.name, "gotoMainMenu", o.states.MAIN_MENU.name}
	}

	-- Create your instance of a finite state machine
	o.fsm = o.FSM.new(myStateTransitionTable)
	local genericUpdate = function(name)
		local state = o.states[name]

		print "update action..."
		if state and state.actions then
			if state.actions["update"] then
				state.actions.update()
			end
		end
		print "...update done."
	end
	o.use = function()
		-- Use your finite state machine
		-- which starts by default with the first defined state
		local stateId = o.fsm:get()



		print("Starting FSM state: " .. stateId)
		genericUpdate(stateId)
		-- Respond on "event" and last set "state"
		local actionResult = o.fsm:fire("startGame")
		print (actionResult) -- just testing return value
		stateId = o.fsm:get()
		genericUpdate(stateId)

		actionResult = o.fsm:fire("gotoMainMenu")

		print (actionResult) -- just testing return value

		stateId = o.fsm:get()

		print("Current FSM state: " .. stateId)
		genericUpdate(stateId)


		state = o.fsm:get()
		print (state)
	end
	return o
end

local sm = love.game.newStateManager()
sm.use()