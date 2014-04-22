
-- GameStates:0=MainMenu, 1=inGame, 2=Load, 3=Settings, 4=Game Over, 5 = Credits
states = {"main menu", "gameplay", "load", "settings", "game over", "credits", "settings/video","settings/video/advanced", "paused"}
local mmState = {name= "main_menu"}
mmState.action = function()
	print "hello"
end

local gpState = {name = "gameplay"}
states = {main_menu=mmState,gameplay=gpState}
states.MAIN_MENU = states["main_menu"]
states.GAMEPLAY = states["gameplay"]
states.CREDITS = states[5]
states.PAUSED = states[9]


FSM = require "love2d/external/fsm"

function action1() print("transition from mm to gp") end

function action2() print("transition from gp to mm") end


-- Define your state transitions here
local myStateTransitionTable = {
	{states.MAIN_MENU.name, "startGame", states.GAMEPLAY.name, action1},
	{states.GAMEPLAY.name, "gotoMainMenu", states.MAIN_MENU.name, action2}
}

-- Create your instance of a finite state machine
fsm = FSM.new(myStateTransitionTable)

-- Use your finite state machine
-- which starts by default with the first defined state
local name = fsm:get()
print("Current FSM state: " .. name)

local state = states[name]
if state and state.action then
	state.action()
end
-- Respond on "event" and last set "state"
local action = fsm:fire("startGame")
fsm:fire("main_menu") --nothing should happen

print("Current FSM state: " .. fsm:get())


state = fsm:get()
print (state)