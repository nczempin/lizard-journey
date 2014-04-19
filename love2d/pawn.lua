local SPRITE_SIZE = 32 --this assumes rectangular sprites

function love.game.newPawn()
	local o = {}

	o.x = 20
	o.y = 300
	
	o.goalX = 40
	o.goalY = 40

	o.speed = 0.2

	o.velX = o.speed
	o.velY = o.speed

	o.update = function(dt)
		local tmpX= o.x + o.velX
		local tmpY= o.y + o.velY
		if tmpY<= 0 or tmpY >= 600 -SPRITE_SIZE then --TODO use world edges / collision
			o.velY = -o.velY
		elseif tmpX <= 0 or tmpX >= 800-SPRITE_SIZE then --TODO use world edges / collision
			o.velX = -o.velX
		end
		o.x = tmpX
		o.y = tmpY
		
		if o.x < 0 or o.y < 0 or o.x >800-SPRITE_SIZE or o.y >600 -SPRITE_SIZE then --TODO use world edges / collision
			o.speed = -o.speed
		end
	end

	o.draw = function()
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", o.x,o.y, SPRITE_SIZE,SPRITE_SIZE)
	end
	return o
end

