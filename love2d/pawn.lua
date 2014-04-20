require('math')
require('mapGenerator')

local SPRITE_SIZE = 64 --this assumes rectangular sprites --TODO this conflicts with o.spriteSize
local EPSILON = 0.001
local DIGGING_TIME = 0.5
local DEFAULT_AMBIENT_TEMPERATURE = 33

function love.game.newPawn(id, world)
	local o = {}
	o.world = world
	o.zoom = 1

	o.x = 2
	o.y = 3
	o.lastDigging = {-1, -1}
	o.diggingTimeLeft = DIGGING_TIME

	o.maxSpeed = 2
	o.velX = 0
	o.velY = 0


	o.name = id

	o.water = 100
	o.temperature = 0
	o.temperatureDelta = 1
	o.image = love.graphics.newImage("res/gfx/character.png")
	o.image:setFilter("nearest","nearest")
	o.spritesize = 32 --TODO this conflicts with the constant SPRITE_SIZE
	o.anim = {0, 0}
	o.animstates = 8
	o.animspeed = 0.1
	o.curAnimdt = 0
	o.lastIdle = 0.5

	o.ambientTemperature = DEFAULT_AMBIENT_TEMPERATURE


	o.update = function(dt)
		--determine ambient temperature
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
			local ambientDiff = maxTemp-o.ambientTemperature
			o.heatAmbient(ambientDiff*dt)

		if o.state == "dead" then

		else
	
			--			if o.temperature <= 22 or o.temperature >= 56 then
			--				o.temperatureDelta = - o.temperatureDelta -- simplified temp change
			--			end
			--o.temperature = o.temperature + dt * o.temperatureDelta
			local tempDiff = o.ambientTemperature - o.temperature
			o.temperature = o.temperature + 0.05*tempDiff*dt

			local mx = math.floor(o.x + 0.5) + 1
			local my = math.floor(o.y + 0.5) + 1
			if mx > 0 and my > 0 and mx <= o.world.mapWidth and my <= o.world.mapHeight and	MapGenerator.getObject(o.world.mapG, mx, my) == MAP_OBJ_WATER then
				o.water = math.min(100, o.water + 0.00125*o.temperature*o.temperature* dt)
			else
				o.water = math.max(0, o.water - 0.0005*o.temperature*o.temperature* dt) --TODO: make this dependent on all sorts of other things
			end
			
			if o.water <=0 or o.temperature >= 60 then
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

			local x, y
			if o.velX < 0 then
				x = math.floor(tmpX) + 1
			else
				x = math.ceil(tmpX) + 1
			end
			if o.velY < 0 then
				y = math.floor(tmpY) + 1
			else
				y = math.ceil(tmpY) + 1
			end
			if x > 0 and y > 0 and x <= o.world.mapWidth and y <= o.world.mapHeight then
				tileId = MapGenerator.getID(o.world.mapG, x, y)
				if tileId == MAP_MOUNTAIN_DARK or tileId == MAP_MOUNTAIN then
					if o.lastDigging[1] == x and o.lastDigging[2] == y then
						o.diggingTimeLeft = o.diggingTimeLeft - dt
						if o.diggingTimeLeft < 0 then
							if tileId == MAP_MOUNTAIN_DARK then
								MapGenerator.setID(o.world.mapG, x, y, MAP_PLAIN)
								o.world.map.setTileLayer(x, y, 1, 0)
								o.world.map.setTileLayer(x, y, 3, 63)
							elseif tileId == MAP_MOUNTAIN then
								MapGenerator.setID(o.world.mapG, x, y, MAP_PLAIN)
								o.world.map.setTileLayer(x, y, 1, 0)
								o.world.map.setTileLayer(x, y, 3, 63)
							end
							-- change tile to floor
						end
					else
						o.lastDigging[1] = x
						o.lastDigging[2] = y
						o.diggingTimeLeft = DIGGING_TIME
					end
				else
					o.x = tmpX
					o.y = tmpY
				end
			else
				o.x = tmpX
				o.y = tmpY
			end
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
			if o.velX < -EPSILON then
				-- left
				o.anim[2] = 4
			elseif o.velX > EPSILON then
				--right
				o.anim[2] = 3
			else
				o.lastIdle = o.lastIdle - dt
				if o.lastIdle < 0 then
					if math.random() < 0.5 then
						o.anim[2] = 6
						o.lastIdle = 0.5
					else
						o.anim[2] = 7
						o.lastIdle = 0.5
					end
				end
			end
		else
			if o.velY < -EPSILON then
				-- up
				o.anim[2] = 2
			elseif o.velY > EPSILON then
				--down
				o.anim[2] = 1
			else
				o.lastIdle = o.lastIdle - dt
				if o.lastIdle < 0 then
					if math.random() < 0.5 then
						o.anim[2] = 6
						o.lastIdle = 0.5
					else
						o.anim[2] = 7
						o.lastIdle = 0.5
					end
				end
			end
		end
	end

	o.draw = function(x, y)
		local xx = (o.x * SPRITE_SIZE + x) * o.zoom
		local yy = (o.y * SPRITE_SIZE + y) * o.zoom
		if o.state == "dead" then
			love.graphics.setColor(255,255,255)

			local quad = love.graphics.newQuad(4 * o.spritesize, 0 * o.spritesize, o.spritesize, o.spritesize, o.image:getWidth(), o.image:getHeight())
			love.graphics.draw( o.image, quad, xx, yy, 0, 2 * o.zoom, 2 * o.zoom) -- the magic 2 possibly comes from the inconsistency between the sprite size constants
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

