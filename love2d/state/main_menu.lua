function love.game.newMainMenu()
	local o = {}
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
		lizGame.prepareBackgroundImage() --TODO no globals plz
	end
	return o
end