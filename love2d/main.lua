require "game"

function love.load()
	G = love.graphics
	W = love.window
	S = love.sounds
	FS = love.filesystem
	FONT = G.newFont(32)
	FONT_SMALL = G.newFont(24)

	--stateMainMenu.setVersion("v0.0.1")
	lizGame = love.game.newGame()
	lizGame.init()
end

function love.update(dt)
	lizGame.update(dt)
end

function love.draw()
	lizGame.draw()
end

function love.keypressed(key, code)
	if key == "1" then
		lizGame.setState(1)
	elseif key == "2" then
		lizGame.setState(2)
	end
end

function love.mousepressed(x, y, key)
	if(key == "l") then
		--press left
	end
end

function love.mousereleased(x, y, key)
	
end