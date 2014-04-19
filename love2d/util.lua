
--
function distance_manhattan(x1,y1,x2,y2) --TODO let's not leave this global
	-- manhattan is sufficient for now
	return math.abs(x1-x2)+math.abs(y1-y2)
end

function distance_euclid(x1,y1,x2,y2)
	local x = x1-x2
	local y = y1-y2
	return math.sqrt(x*x+y*y)
end

function love.game.normalize(x, y)
	local m = math.max(math.abs(x), math.abs(y))
	local xRet = x / m
	local yRet = y / m
	return xRet, yRet
end
