require('math')
local SPRITE_SIZE = 64 --this assumes rectangular sprites --TODO this conflicts with o.spriteSize
local EPSILON = 0.001
local DEFAULT_AMBIENT_TEMPERATURE = 33

function love.game.newPawn(id, world)
	local o = {}
	o.world = world
	o.zoom = 1

	o.x = 2
	o.y = 3

	o.maxSpeed = 2
	o.velX = 0
	o.velY = 0


	o.name = id

	o.water = 100
	o.temperature = 0
	o.temperatureDelta = 1
	o.image = love.graphics.newImage("res/gfx/character.png")
	o.spritesize = 32 --TODO this conflicts with the constant SPRITE_SIZE
	o.anim = {0, 0}
	o.animstates = 8
	o.animspeed = 0.1
	o.curAnimdt = 0

	o.ambientTemperature = DEFAULT_AMBIENT_TEMPERATURE


	o.update = function(dt)

		if o.state == "dead" then

		else
			local maxTemp = DEFAULT_AMBIENT_TEMPERATURE
			for i, fire in pairs(o.world.fires) do
				if fire.state > FIRE_STATE_ENLIGHT then
					local dist = distance_euclid(fire.x, fire.y, o.x, o.y)+1
					local netTemp = fire.temperature/((dist)*(dist))
					if netTemp > maxTemp then
						maxTemp = netTemp
					end
				end
			end

			--determine ambient temperature
			local ambientDiff = maxTemp-o.ambientTemperature
			o.heatAmbient(ambientDiff*dt)

			--			if o.temperature <= 22 or o.temperature >= 56 then
			--				o.temperatureDelta = - o.temperatureDelta -- simplified temp change
			--			end
			--o.temperature = o.temperature + dt * o.temperatureDelta
			local tempDiff = o.ambientTemperature - o.temperature
			o.temperature = o.temperature + 0.05*tempDiff*dt

			o.water = o.water -0.0005*o.temperature*o.temperature* dt --TODO: make this dependent on all sorts of other things
			if o.water <=0 then
				o.state = "dead"
			end

			--update target coordinates

			--TODO right now these goals are set by mouse clicks

			--set the velocity according to the goal; just move straight towards it at maximum speed
			local wantX = o.world.goalX - o.x
			local wantY = o.world.goalY - o.y
			local dirX, dirY = love.game.normalize(wantX, wantY)

			o.velX = dirX * o.maxSpeed
			o.velY = dirY * o.maxSpeed

			--close enough
			if (math.abs(wantX) < EPSILON)then
				o.velX = 0
				o.x = math.floor(o.x + 0.5)
			end
			if (math.abs(wantY) <EPSILON)then
				o.velY = 0
				o.y = math.floor(o.y + 0.5)
			end


			-- update position and possibly speed
			local tmpX= o.x + o.velX * dt
			local tmpY= o.y + o.velY * dt
			if tmpY <= 1 or tmpY >= o.world.map.height  then
				o.velY = -o.velY
			elseif tmpX <= 1 or tmpX >= o.world.map.width then
				o.velX = -o.velX
			end
			o.x = tmpX
			o.y = tmpY


		end

		--------update graphics ----------------------

		--determine animation frame
		o.curAnimdt = o.curAnimdt + dt
		if o.curAnimdt > o.animspeed then
			o.anim[1] = (o.anim[1] + 1) % o.animstates
			o.curAnimdt = o.curAnimdt - o.animspeed
		end

		--determine facing
		if math.abs(o.velX) > math.abs(o.velY) then
			if o.velX < EPSILON then
				-- left
				o.anim[2] = 4
			elseif o.velX > EPSILON then
				--right
				o.anim[2] = 3
			end
		else
			if o.velY < EPSILON then
				-- up
				o.anim[2] = 2
			elseif o.velY > EPSILON then
				--down
				o.anim[2] = 1
			end
		end

	end

	o.draw = function(x, y)
		local xx = (o.x * SPRITE_SIZE + x) * o.zoom
		local yy = (o.y * SPRITE_SIZE + y) * o.zoom
		if o.state == "dead" then
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill",xx,yy, SPRITE_SIZE*o.zoom,SPRITE_SIZE*o.zoom)
		else
			love.graphics.setColor(255,255,255)

			local quad = love.graphics.newQuad(o.anim[1] * o.spritesize, o.anim[2] * o.spritesize, o.spritesize, o.spritesize, o.image:getWidth(), o.image:getHeight())
			love.graphics.draw( o.image, quad, xx, yy, 0, 2 * o.zoom, 2 * o.zoom) -- the magic 2 possibly comes from the inconsistency between the sprite size constants

			--show the target of this pawn
			--TODO: only show when this pawn is selected / being followed
			love.graphics.setColor(255,255,0)
			love.graphics.rectangle("line", (o.world.goalX*SPRITE_SIZE+x)*o.zoom,(o.world.goalY*SPRITE_SIZE+y)*o.zoom, SPRITE_SIZE*o.zoom,SPRITE_SIZE*o.zoom)
		end
	end
	o.setZoom = function(zoom)
		o.zoom = zoom
	end

	o.heatAmbient = function(dt)
		o.ambientTemperature= o.ambientTemperature + dt
	end

	o.getPosition = function()
		return o.x, o.y
	end

	return o
end

