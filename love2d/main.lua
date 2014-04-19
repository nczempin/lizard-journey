require "game"
require "state/states"
<<<<<<< HEAD
require "sound"
require "soundinit"
=======
require "util"
>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4

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
	love.sounds.initSounds()
	love.sounds.playBgm("fireplace")
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
	end
end

function love.mousepressed(x, y, key)
<<<<<<< HEAD
	if(key == "l") then
		--press left
=======
	if(key == "wu") then
		lizGame.world.zoomIn()
	elseif(key == "wd") then
		lizGame.world.zoomOut()
>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
	end
end

function love.mousereleased(x, y, key)
	
end