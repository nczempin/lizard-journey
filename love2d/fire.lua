require('util')

FIRE_STATE_OFF = 0
FIRE_STATE_ENLIGHT = 1
FIRE_STATE_BURN_ANIM1 = 2
FIRE_STATE_BURN_ANIM2 = 3
FIRE_STATE_BURN_ANIM3 = 4
FIRE_STATE_BURN_ANIM4 = 5

local SPRITE_SIZE = 64

Fire = {}
function Fire.newFire(x, y, graphic)
	local fire = {}
	fire.state = FIRE_STATE_OFF
	fire.x = x - 1
	fire.y = y - 1
	fire.image = graphic
	fire.spritesize = 32
	fire.timeInState = 0
	fire.timeStateChange = 0.25
	fire.zoom = 1
	
	fire.temperature = 300
	
	fire.draw = function(x, y)
		local quad = love.graphics.newQuad(fire.state * fire.spritesize, 2 * fire.spritesize, fire.spritesize, fire.spritesize, fire.image:getWidth(), fire.image:getHeight())
		love.graphics.draw( fire.image, quad, (fire.x * SPRITE_SIZE + x) * fire.zoom, (fire.y * SPRITE_SIZE + y) * fire.zoom, 0, 2 * fire.zoom, 2 * fire.zoom)
	end
	
	fire.setZoom = function(zoom)
		fire.zoom = zoom
	end
	
	fire.update = function(dt, pawns)
		if fire.state <= FIRE_STATE_ENLIGHT then
			for i, v in pairs(pawns) do
				local x, y = v.getPosition()
				local dist = distance_euclid(x, y, fire.x, fire.y)
				if dist < 1 then
					fire.timeInState = fire.timeInState + dt
					if fire.timeInState > fire.timeStateChange then
						fire.timeInState = fire.timeInState - fire.timeStateChange
						fire.state = fire.state + 1
					end
				end
			end
		else
			fire.timeInState = fire.timeInState + dt
			if fire.timeInState > fire.timeStateChange then
				fire.timeInState = fire.timeInState - fire.timeStateChange
				fire.state = fire.state + 1
				if fire.state > FIRE_STATE_BURN_ANIM4 then
					fire.state = FIRE_STATE_BURN_ANIM1
				end
			end
		end
	end
	
	return fire
end
