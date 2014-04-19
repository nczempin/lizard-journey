require "game"
require "state/states"

function love.load()
	G = love.graphics
	W = love.window
	S = love.sounds
	FS = love.filesystem
	FONT = G.newFont(32)
	FONT_SMALL = G.newFont(24)

	lizGame = love.game.newGame()
	lizGame.setVersion("v0.0.1")
	lizGame.init()
end

function love.update(dt)
	lizGame.update(dt)
end

function love.draw()
	love.window.setTitle("Lizard Journey (FPS:" .. love.timer.getFPS() .. ")")
	lizGame.draw()
end

function love.keypressed(key, code)
	if key == "1" then
		lizGame.setState(states.MAIN_MENU)
	elseif key == "2" then
		lizGame.setState(states.GAME_PLAY)
	elseif key == "3" then
        lizGame.setState(states.CREDITS)
    end
end

function love.mousepressed(x, y, key)
	if(key == "wu") then
		lizGame.world.map.zoomIn()
	elseif(key == "wd") then
		lizGame.world.map.zoomOut()
	end
end

function love.mousereleased(x, y, key)
	
end