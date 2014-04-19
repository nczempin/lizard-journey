require "libraries/gui"

require "external/TSerial"
require "external/postshader"
require "external/light"
require "external/ai"

require "external/anim"
require "external/TEsound"

require "world"
require "game"
require "map"
require "spawn"
require "towerType"
require "sound"

require "util"

require "mapGenerator"

function love.load()
	G = love.graphics
	W = love.window
	T = love.turris
	S = love.sounds
	FS = love.filesystem
	local map = MapGenerator.newMap(25,25)
	
end

function love.turris.reinit(map)
	turGame = love.turris.newGame()
	turGame.init()
end


function love.update(dt)
	for i = 1, #pawns do
		pawns[i].update(dt)
	end
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.line(200,50, 400,50)
	W.setTitle("FPS: " .. love.timer.getFPS())


end


function love.keypressed(key, code)
	if key == "escape" then
	end
end

function love.mousepressed(x, y, key)
	if(key == "l") then
		buttonDetected = 1
		love.turris.checkleftclick(x,y)
	end
	if(key == "m") then
		buttonDetected = 3
	end
	if(key == "r") then
		buttonDetected = 2
		love.turris.checkrightclick(x,y)
	end
end

function love.mousereleased(x, y, key)
	buttonDetected = 0
end