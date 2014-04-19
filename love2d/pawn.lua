local SPRITE_SIZE = 32 --this assumes rectangular sprites

function love.game.newPawn()
	local o = {}

	o.x = 20
	o.y = 300
	
	o.goalX = 40
	o.goalY = 40
	
	o.speed = 0.2

	o.update = function(dt)
		o.x = o.x + o.speed
		o.y = o.y + o.speed
		
		if o.x < 0 or o.y < 0 or o.x >800-SPRITE_SIZE or o.y >600 -SPRITE_SIZE then --TODO use world edges / collision
			o.speed = -o.speed
		end
	end

	o.draw = function()
		love.graphics.rectangle("fill", o.x,o.y, SPRITE_SIZE,SPRITE_SIZE)
	end
	return o
end

