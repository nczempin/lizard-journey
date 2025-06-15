require "game"
require "state/states"
require "util"
require "sound/sound"
require "sound/soundinit"

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
	--lizGame.setVersion("v0.3.2")
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
end


function love.mousepressed(x, y, button, isTouch)
	-- For backward compatibility, pass button as the third parameter
	lizGame.stateManager.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button, isTouch)
	-- Currently not used in the game
end

function love.wheelmoved(x, y)
	-- Handle wheel movement
	if lizGame.stateManager.wheelmoved then
		lizGame.stateManager.wheelmoved(x, y)
	end
end