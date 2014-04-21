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

		o.setupMenu()

		o.setState(states.MAIN_MENU) -- set the starting state (use e. g. MAIN_MENU if you work on the menus)
	end

	o.setupMenu = function()
		o.menu = love.gui.newGui()

		-- Buttons


		-- A man can dream...
		--[[
		local buttons = {{o.playButton, "Play"}, {o.creditsButton, "Credits"}, {o.exitButton, "Exit"}}
		local i = 0
		for button in buttons do
		button[1] = o.menu.newButton(5, i*(spacing + button_height), 120, padding + font_h, button[2], nil)
		i = i + 1
		end
		--]]


		o.buttonImage = G.newImage("res/gfx/gui-arrow.png")
		G.setFont(FONT_LARGE)
		local padding = 7
		local fontH = FONT_MEDIUM:getHeight()
		local spacing = 25
		local buttonH = padding + fontH
		local buttonX = love.window.getWidth()/2 - 140/2
		local windowH = love.window.getHeight()/2
		local nButtons = 3
		local totalButtonH = nButtons*(spacing + buttonH)
		o.playButton = o.menu.newButton(buttonX, windowH - totalButtonH/2 + 0*(spacing + buttonH), 140, buttonH, "Play", o.buttonImage)
		o.playButton.setFont(FONT_LARGE)
		o.creditsButton = o.menu.newButton(buttonX, windowH - totalButtonH/2 + 1*(spacing + buttonH), 140, buttonH, "Credits", o.buttonImage)
		o.creditsButton.setFont(FONT_LARGE)
		o.exitButton = o.menu.newButton(buttonX, windowH - totalButtonH/2 + 2*(spacing + buttonH), 140, buttonH, "Exit", o.buttonImage)
		o.creditsButton.setFont(FONT_LARGE)

		-- Background image
		local scale = function(x, min1, max1, min2, max2)
			return min2 + ((x - min1) / (max1 - min1)) * (max2 - min2)
		end

		local distance = function(x1, y1, x2, y2)
			return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
		end

		local imageData = love.image.newImageData(1024, 1024)
		local maxDist = math.sqrt(512)^2
		imageData:mapPixel(function(x, y)
			local dist = distance(1024/2, 1024/2, x, y)
			local color = 255 - (dist/maxDist)*255
			local color = color > 255 and 255 or color
			local diff = 215 - 159
			return 159 + diff*color/255, 159 + diff*color/255, 159 + diff*color/255, 255
		end)

		o.backgroundImage = G.newImage(imageData)
	end

	o.update = function(dt)
		if o.state == states.PAUSED then
			return
		end

		if o.state == states.MAIN_MENU then
			if o.playButton.hit then
				o.setState(states.GAME_PLAY)
				TEsound.stop(love.sounds.bgm.activeBgm,false)
				--love.sounds.playBgm("lizardGuitarFx")
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
			G.setColor(255, 255, 255)
			G.draw(o.backgroundImage, 0, 0, 0,
				love.window.getWidth()/o.backgroundImage:getWidth(),
				love.window.getHeight()/o.backgroundImage:getHeight())
			o.menu.draw()

			local font = FONT_XLARGE
			G.setFont(font)
			G.setColor(151*0.80, 147*0.80, 141*0.80)
			G.printf("The Tale of Some Reptile", 0, love.window.getHeight()/4 - font:getHeight()/2, love.window.getWidth(), "center")
			-- debug
			--G.setColor(255, 0, 0)
			--G.rectangle("fill", love.window.getWidth()/2 - 20, love.window.getHeight()/2 - 20, 40, 40)

			G.setColor(255, 255, 255)
		elseif o.state == states.GAME_PLAY then
			o.world.draw()
		elseif o.state == states.CREDITS then
			G.print("Credits!", o.x, o.y)
		elseif o.state == states.PAUSED then
			-- Draw world as backdrop
			G.setColor(255, 255, 255, 255)
			o.world.draw()
			-- Draw transparent rectangle for the 'faded' effect
			local w = love.window.getWidth()
			local h = love.window.getHeight()
			G.setColor(255, 255, 255, 96)
			G.rectangle("fill", 0, 0, w, h)
			-- Draw centered (H&V) text
			G.setColor(0, 0, 0)
			local font = FONT_XLARGE
			G.setFont(font)
			G.printf("Paused.", 0, h/2 - font:getHeight()/2, w, "center")

			G.setColor(255, 255, 255)
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
