love.game = {}

require "world"
require "external/gui/gui"

function love.game.newGame()
	local o = {}
	o.state = 1
	o.world = nil
	o.version = "0.0.0"
	
	o.x = 30
	o.y = 20
	o.xVel = 0.1
	o.yVel = -0.1

	o.init = function()
		o.world = love.game.newWorld()
		o.world.init()
		
		o.menu = love.gui.newGui()
		o.playButton = o.menu.newButton(5, 5, 120, 20, "Play", nil)
		o.creditsButton = o.menu.newButton(5, 30, 120, 20, "Credits", nil)
		o.exitButton = o.menu.newButton(5, 55, 120, 20, "Exit", nil)
		
		o.setState(states.MAIN_MENU) -- set the starting state (use e. g. MAIN_MENU if you work on the menus)
	end

	o.update = function(dt)
		if o.state == states.MAIN_MENU then
			if o.playButton.hit then
				o.setState(states.GAME_PLAY)
			elseif o.creditsButton.hit then
				o.setState(states.CREDITS)
			elseif o.exitButton.hit then
				love.event.quit()
			end
			o.menu.update(dt)
		elseif o.state == states.GAME_PLAY then
			o.world.update(dt)
		end
	end

	o.draw = function()
		if o.state == states.MAIN_MENU then
			o.menu.draw()
		elseif o.state == states.GAME_PLAY then
			o.world.draw()
		elseif o.state == states.CREDITS then
			love.graphics.print("Credits!", o.x, o.y)
		end
	end

	o.setState = function(state)
		o.state = state
	end

	o.setVersion = function(version)
		o.version = version
	end

	return o
end
