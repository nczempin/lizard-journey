love.game = {}

require "world"
require "external/gui/gui"
require "conf"

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
        if o.state == states.PAUSED then
            return
        end
        
		if o.state == states.MAIN_MENU then
			if o.playButton.hit then
				o.setState(states.GAME_PLAY)
				love.sounds.playBgm("lizardGuitarFx")
			elseif o.creditsButton.hit then
				o.setState(states.CREDITS)
				love.sounds.playBgm("lizardGuitarSlow")
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
		elseif o.state == states.PAUSED then
            -- Draw world as backdrop
            o.world.draw()
            -- Draw transparent rectangle for the 'faded' effect
            local w = love.window.getWidth()
            local h = love.window.getHeight()
            love.graphics.setColor(255, 255, 255, 96)
            love.graphics.rectangle("fill", 0, 0, w, h)
            -- Draw centered (H&V) text
            love.graphics.setColor(0, 0, 0, 255)
            local font = FONT_XLARGE
            love.graphics.setFont(font)
            love.graphics.printf("Paused.", 0, h/2 - font:getHeight()/2, w, "center")
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
