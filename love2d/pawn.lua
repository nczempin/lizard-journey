local SPRITE_SIZE = 64 --this assumes rectangular sprites

function love.game.newPawn(world)
	local o = {}
	o.world = world

	o.x = 2
	o.y = 3

	o.goalX = 7
	o.goalY = 7

	o.speed = 0.002

	o.velX = o.speed
	o.velY = o.speed

	o.update = function(dt)
		local tmpX= o.x + o.velX
		local tmpY= o.y + o.velY
		if tmpY<= 1 or tmpY >= o.world.map.height  then --TODO use world edges / collision
			o.velY = -o.velY
		elseif tmpX <= 1 or tmpX >= o.world.map.width then --TODO use world edges / collision
			o.velX = -o.velX
		end
		o.x = tmpX
		o.y = tmpY

	end

	o.draw = function()
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", o.x*SPRITE_SIZE*o.world.map.zoom,o.y*SPRITE_SIZE*o.world.map.zoom, SPRITE_SIZE*o.world.map.zoom,SPRITE_SIZE*o.world.map.zoom)
	end
	return o
end

