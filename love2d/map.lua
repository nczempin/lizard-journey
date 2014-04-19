function love.game.newMap(width, height, tileWidth, tileHeight)
	local o = {}
	o.width = width or 64
	o.height = height or 48
	o.tileWidth = tileWidth or 32
	o.tileHeight = tileHeight or 32

	o.init = function()
		
	end
	
	o.update = function(dt)
		
	end

	o.draw = function()
		love.graphics.print("draw map", 64, 64)
	end

	return o
end