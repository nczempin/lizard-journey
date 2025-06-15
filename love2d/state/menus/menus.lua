function love.game.newMenus()
	local o =  {}
	o.init = function()
		o.prepareBackgroundImage()
		o.main_menu = love.game.newMainMenu(o)
		o.main_menu.setupMenu()
		o.credits = love.game.newCreditsScreen(o)
		o.credits.setupCredits()

	end
	-- help for consistent look and feel in menus
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
			return (159 + diff*color/255)/255, (159 + diff*color/255)/255, (159 + diff*color/255)/255, 1
		end)

		o.backgroundImage = G.newImage(imageData)
	end
	o.drawBackgroundImage = function()
		G.setColor(1, 1, 1)
		G.draw(o.backgroundImage, 0, 0, 0,
			W.getWidth()/o.backgroundImage:getWidth(),
			W.getHeight()/o.backgroundImage:getHeight())
	end

	o.drawTitle = function(titleText)
		local font = FONT_XLARGE
		G.setFont(font)
		G.setColor(0.471, 0.463, 0.439)
		G.printf(titleText, 0, W.getHeight()/4 - font:getHeight()/2, W.getWidth(), "center")
		G.setColor(1, 1, 1)
	end
	-- end look and feel
	return o
end