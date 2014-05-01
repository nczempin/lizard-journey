function love.game.newMainMenu()
	local o = {}
	o.update = function(dt)
		o.menu.update(dt)
	end
	o.draw = function()
		lizGame.drawBackgroundImage()
		o.menu.draw()
		lizGame.drawTitle("The Tale of Some Reptile")

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
		local buttonX = W.getWidth()/2 - 140/2
		local windowH = W.getHeight()/2
		local nButtons = 3
		local totalButtonH = nButtons*(spacing + buttonH)
		o.playButton = o.menu.newButton(buttonX, windowH - totalButtonH/2 + 0*(spacing + buttonH), 140, buttonH, "Play", o.buttonImage)
		o.playButton.setFont(FONT_LARGE)
		o.creditsButton = o.menu.newButton(buttonX, windowH - totalButtonH/2 + 1*(spacing + buttonH), 140, buttonH, "Credits", o.buttonImage)
		o.creditsButton.setFont(FONT_LARGE)
		o.exitButton = o.menu.newButton(buttonX, windowH - totalButtonH/2 + 2*(spacing + buttonH), 140, buttonH, "Exit", o.buttonImage)
		o.creditsButton.setFont(FONT_LARGE)
	end
	return o
end

function love.game.newMmState(sm)
	--TODO: move to main_menu.lua
	local mmState = {name= "main_menu"}
	mmState.actions = {}

	local mmUp = function(dt)
		lizGame.main_menu.update(dt)
		if lizGame.main_menu.playButton.hit then
			sm.fsm:fire("startGame")
		elseif lizGame.main_menu.creditsButton.hit then
			sm.fsm:fire("gotoCredits")
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
	mmState.actions["transition"] = mmTransition

	return mmState
end