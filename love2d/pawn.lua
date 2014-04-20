local SPRITE_SIZE = 64 --this assumes rectangular sprites

function love.game.newPawn(id, world)
	local o = {}
	o.world = world
	o.zoom = 1

	o.x = 2
	o.y = 3

	o.speed = 2
	o.velX = o.speed
	o.velY = o.speed


	o.name = id

	o.water = 100
	o.temperature = 33
	o.temperatureDelta = 1

	o.ambientTemperature = 33

	o.update = function(dt)




		if o.temperature <= 22 or o.temperature >= 56 then
			o.temperatureDelta = - o.temperatureDelta -- simplified temp change
		end
		o.temperature = o.temperature + dt * o.temperatureDelta

		o.water = o.water -0.0005*o.temperature*o.temperature* dt --one per five seconds. TODO: make this dependent on all sorts of other things
		--update target coordinates

		--TODO right now these goals are set by mouse clicks

		--set the velocity according to the goal; just move straight towards it at maximum speed
		local wantX = o.world.goalX - o.x
		local wantY = o.world.goalY - o.y
		local dirX, dirY = love.game.normalize(wantX, wantY)
		o.velX = dirX * o.speed
		o.velY = dirY * o.speed



		-- update position and possibly speed
		local tmpX= o.x + o.velX* dt
		local tmpY= o.y + o.velY* dt
		if tmpY <= 1 or tmpY >= o.world.map.height  then
			o.velY = -o.velY
		elseif tmpX <= 1 or tmpX >= o.world.map.width then
			o.velX = -o.velX
		end
		o.x = tmpX
		o.y = tmpY

	end

	o.draw = function(x, y)
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle("fill", (o.x * SPRITE_SIZE + x) * o.zoom, (o.y * SPRITE_SIZE + y) * o.zoom, SPRITE_SIZE * o.zoom,SPRITE_SIZE * o.zoom)

		--show the target of this pawn
		--TODO: only show when this pawn is selected / being followed
		love.graphics.setColor(255,255,0)
		love.graphics.rectangle("line", (o.world.goalX*SPRITE_SIZE+x)*o.zoom,(o.world.goalY*SPRITE_SIZE+y)*o.zoom, SPRITE_SIZE*o.zoom,SPRITE_SIZE*o.zoom)
	end

	o.setZoom = function(zoom)
		o.zoom = zoom
	end

	return o
end

