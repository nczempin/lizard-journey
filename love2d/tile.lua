function love.game.newTile(id, count)
	local o = {}
	o.id = {}
	o.id[1] = id
	o.count = {}
	o.count[1] = count
	o.collision = false

	o.init = function()

	end

	o.update = function(dt)

	end

	o.draw = function()

	end

	o.getID = function(layer)
		if layer <= #o.id then
			return o.id[layer]
		end
	end

	o.isLayer = function(layer)
		if layer <= #o.id then
			return true
		else
			return false
		end
	end

	o.addLayer = function(id, count)
		o.id[#o.id + 1] = id
		o.count[#o.count + 1] = count
	end

	o.getCollision = function()
		return o.collision
	end

	o.setCollision = function(collision)
		o.collision = collision
	end

	return o
end