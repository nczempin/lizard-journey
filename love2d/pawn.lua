local SPRITE_SIZE = 32 --this assumes rectangular sprites

function love.game.newPawn()
	local o = {}

<<<<<<< HEAD
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
=======
	o.x = 2
	o.y = 3
	o.zoom = 1

	o.speed = 0.002

	o.velX = o.speed
	o.velY = o.speed

	o.update = function(dt)
		local wantX = o.world.goalX - o.x
		local wantY = o.world.goalY - o.y
		
		local dirX, dirY = love.game.normalize(wantX, wantY)
		o.velX = dirX * o.speed
		o.velY = dirY * o.speed
		
	
	
	-- update position and possibly speed
		local tmpX= o.x + o.velX
		local tmpY= o.y + o.velY
		if tmpY <= 1 or tmpY >= o.world.map.height  then 
			o.velY = -o.velY
		elseif tmpX <= 1 or tmpX >= o.world.map.width then 
			o.velX = -o.velX
>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
		end
	end

<<<<<<< HEAD
	o.draw = function()
		love.graphics.rectangle("fill", o.x,o.y, SPRITE_SIZE,SPRITE_SIZE)
=======
	o.draw = function(x, y)
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", (o.x * SPRITE_SIZE + x) * o.zoom, (o.y * SPRITE_SIZE + y) * o.zoom, SPRITE_SIZE * o.zoom,SPRITE_SIZE * o.zoom)
			love.graphics.setColor(255,255,0)
		love.graphics.rectangle("line", o.world.goalX*SPRITE_SIZE*o.zoom,o.world.goalY*SPRITE_SIZE*o.zoom, SPRITE_SIZE*o.zoom,SPRITE_SIZE*o.zoom)
>>>>>>> c1345b30ebe7f0e21252df1764c23ed1b62bcdd4
	end

	o.setZoom = function(zoom)
		o.zoom = zoom
	end

	return o
end

