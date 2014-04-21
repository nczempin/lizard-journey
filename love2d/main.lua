require "game"
require "state/states"
require "util"
require "sound"
require "soundinit"

function love.load()
	G = love.graphics
	W = love.window
	S = love.sounds
	FS = love.filesystem


	--TODO: externalize into some kind of font manager
	FONT_SIZE_XLARGE = 32
	FONT_SIZE_LARGE = 24
	FONT_SIZE_MEDIUM = 16
	FONT_SIZE_SMALL = 8
	local FONT_PATH = "res/fonts/alagard.ttf"
	FONT_XLARGE = G.newFont(FONT_PATH, FONT_SIZE_XLARGE)
	FONT_LARGE = G.newFont(FONT_PATH, FONT_SIZE_LARGE)
	FONT_MEDIUM= G.newFont(FONT_PATH, FONT_SIZE_MEDIUM)
	FONT_SMALL = G.newFont(FONT_PATH, FONT_SIZE_SMALL)

	FONT = FONT_LARGE

	lizGame = love.game.newGame()
	lizGame.setVersion("v0.2.1")
	lizGame.init()
	love.sounds.initSounds()
	love.sounds.playBgm("desertCowboy")
end

function love.update(dt)
	lizGame.update(dt)
end

function love.draw()
	love.window.setTitle("Lizard Journey (FPS:" .. love.timer.getFPS() .. ")")
	lizGame.draw()
end

function love.keypressed(key, code)
	if lizGame.state ~= states.PAUSED then
		if key == "1" then
			lizGame.setState(states.MAIN_MENU)
		elseif key == "2" then
			lizGame.setState(states.GAMEPLAY)
		elseif key == "3" then
			lizGame.setState(states.CREDITS)
		end
	end

	-- Toggle pause, but only to/from GAME_PLAY
	if lizGame.state == states.GAMEPLAY or lizGame.state == states.PAUSED then
		if key == "p" then
			if lizGame.state == states.GAMEPLAY then
				lizGame.setState(states.PAUSED)
			elseif lizGame.state == states.PAUSED then
				lizGame.setState(states.GAMEPLAY)
			end
		end
	end
end

function love.mousepressed(x, y, key)
	if(key == "wu") then
		lizGame.world.zoomIn()
	elseif(key == "wd") then
		lizGame.world.zoomOut()
	elseif (key == "l")then
		local map = lizGame.world.map
		lizGame.world.setGoal(map, x,y)
	elseif (key == "m")then
		lizGame.world.dragX = x - lizGame.world.offsetX * lizGame.world.zoom
		lizGame.world.dragY = y - lizGame.world.offsetY * lizGame.world.zoom
	end
end

function love.mousereleased(x, y, key)

end