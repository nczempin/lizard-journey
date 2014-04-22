newStateManager = function()
	-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over, 5 = Credits
	states = {"main menu", "gameplay", "load", "settings", "game over", "credits", "settings/video","settings/video/advanced", "paused"}
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
	states = {main_menu=mmState,gameplay=gpState}


	states.MAIN_MENU = states["main_menu"]
	states.GAMEPLAY = states["gameplay"]
	--states.CREDITS = states[5]
	--states.PAUSED = states[9]


	FSM = require "love2d/external/fsm"

	function action1()
		print("transition from mm to gp")
		return "hurz"
	end

	function action2() print("transition from gp to mm") end


	-- Define your state transitions here
	local myStateTransitionTable = {
		{states.MAIN_MENU.name, "startGame", states.GAMEPLAY.name},
		{states.GAMEPLAY.name, "gotoMainMenu", states.MAIN_MENU.name}
	}

	-- Create your instance of a finite state machine
	fsm = FSM.new(myStateTransitionTable)
	local genericUpdate = function(name)
		local state = states[name]

		print "update action..."
		if state and state.actions then
			if state.actions["update"] then
				state.actions.update()
			end
		end
		print "...update done."
	end

	-- Use your finite state machine
	-- which starts by default with the first defined state
	local stateId = fsm:get()



	print("Starting FSM state: " .. stateId)
	genericUpdate(stateId)
	-- Respond on "event" and last set "state"
	local actionResult = fsm:fire("startGame")
	print (actionResult) -- just testing return value
	stateId = fsm:get()
	genericUpdate(stateId)

	actionResult = fsm:fire("gotoMainMenu")

	print (actionResult) -- just testing return value

	stateId = fsm:get()

	print("Current FSM state: " .. stateId)
	genericUpdate(stateId)


	state = fsm:get()
	print (state)
end

newStateManager()