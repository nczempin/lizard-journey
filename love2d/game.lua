love.game = {}

require "world"
require "external/gui/gui"
require "conf"
require "state/main_menu"
require "state/credits"

function love.game.newGame()
	local o = {}
	--o.state = 1
	o.world = nil
	o.version = "0.0.0"

	o.x = 30
	o.y = 20
	o.xVel = 0.1
	o.yVel = -0.1
	o.stateManager = love.game.newStateManager()

	o.init = function()
		o.world = love.game.newWorld()
		o.world.init()

		o.prepareBackgroundImage()
		o.main_menu = love.game.newMainMenu()
		o.main_menu.setupMenu()
		o.credits = love.game.newCreditsScreen()
		o.credits.setupCredits()

		--o.setState(o.stateManager.states.MAIN_MENU) -- set the starting state
	end


	o.update = function(dt)
		o.stateManager.update(dt)
	end
	o.prepareBackgroundImage = function()
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
	o.drawBackgroundImage = function()
		G.setColor(255, 255, 255)
		G.draw(o.backgroundImage, 0, 0, 0,
			W.getWidth()/o.backgroundImage:getWidth(),
			W.getHeight()/o.backgroundImage:getHeight())
	end

	o.drawTitle = function(titleText)
		local font = FONT_XLARGE
		G.setFont(font)
		G.setColor(120, 118, 112)
		G.printf(titleText, 0, W.getHeight()/4 - font:getHeight()/2, W.getWidth(), "center")
		G.setColor(255, 255, 255)
	end


	o.drawPause = function()
		-- Draw world as backdrop
		G.setColor(255, 255, 255, 255)
		o.world.draw()
		-- Draw transparent rectangle for the 'faded' effect
		local w = W.getWidth()
		local h = W.getHeight()
		G.setColor(255, 255, 255, 96)
		G.rectangle("fill", 0, 0, w, h)
		-- Draw centered (H&V) text
		G.setColor(0, 0, 0)
		local font = FONT_XLARGE
		G.setFont(font)
		G.printf("Paused.", 0, h/2 - font:getHeight()/2, w, "center")

		G.setColor(255, 255, 255)
	end

	o.draw = function()
		o.stateManager.draw()

	end

	o.setState = function(state)
		o.state = state

		--change music depending on state. TODO. put this into a separate state object
		if o.state == o.stateManager.states.MAIN_MENU then
			love.sounds.playBgm("lizardViolinSession")
		elseif o.state ==  o.stateManager.states.GAMEPLAY then
			-- ingame music is disabled for now
			love.sounds.playBgm(nil)
		elseif o.state ==  o.stateManager.states.CREDITS then
			S.playBgm("battleIntro")
		elseif o.state ==  o.stateManager.states.PAUSED then
		--TODO pick some pause music
		end
	end

	o.setVersion = function(version)
		o.version = version
	end

	return o
end
