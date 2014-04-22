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
	love.sounds.initSounds()


	lizGame = love.game.newGame()
	lizGame.setVersion("v0.3.1")
	lizGame.init()
end

function love.update(dt)
	lizGame.update(dt)
end

function love.draw()
	love.window.setTitle("Lizard's Journey (FPS:" .. love.timer.getFPS() .. ")")
	lizGame.draw()
end

function love.keypressed(key, code)
lizGame.stateManager.keypressed(key,code)
--	if lizGame.state == lizGame.stateManager.states.PAUSED then
--		print "paused"
--	else
--		if key == "1" then
--			lizGame.setState(lizGame.stateManager.states.MAIN_MENU)
--		elseif key == "2" then
--			print "2"
--			lizGame.setState(lizGame.stateManager.states.GAMEPLAY)
--		elseif key == "3" then
--			lizGame.setState(lizGame.stateManager.states.CREDITS)
--		end
	--	end
	--
	--
	--	-- Toggle pause, but only to/from GAME_PLAY
	--	if lizGame.state == lizGame.stateManager.states.GAMEPLAY or lizGame.state == lizGame.stateManager.states.PAUSED then
	--		if key == "p" then
	--			if lizGame.state == lizGame.stateManager.states.GAMEPLAY then
	--				lizGame.setState(lizGame.stateManager.states.PAUSED)
	--			elseif lizGame.state == lizGame.stateManager.states.PAUSED then
	--				lizGame.setState(lizGame.stateManager.states.GAMEPLAY)
	--			end
	--		end
	--	end
end

function love.mousepressed(x, y, key)
	lizGame.stateManager.mousepressed(x,y,key)

	--	if lizGame.state ==  lizGame.stateManager.states.CREDITS then
	--		lizGame.setState(lizGame.stateManager.states.MAIN_MENU)
	--	end
	--
	--	if(key == "wu") then
	--		lizGame.world.zoomIn()
	--	elseif(key == "wd") then
	--		lizGame.world.zoomOut()
	--	elseif (key == "l")then
	--		local map = lizGame.world.map
	--		lizGame.world.setGoal(map, x,y)
	--	elseif (key == "m")then
	--		lizGame.world.dragX = x - lizGame.world.offsetX * lizGame.world.zoom
	--		lizGame.world.dragY = y - lizGame.world.offsetY * lizGame.world.zoom
	--	end
end

function love.mousereleased(x, y, key)

end