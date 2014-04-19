require('math')

MapGenerator = {}

function MapGenerator.newMap(width, height)
	local map = {}
	for x = 1, width do
		map[x] = {}
		for y = 1, height do
			if y/width < 0.5 * math.cos((x / height) * 2 * math.pi - 2*math.pi/3)  -math.abs(0.5 * math.cos((x / height) * 4 * math.pi - 2*math.pi/3)) + 0.5 then
				map[x][y] = 0
			else
				map[x][y] = 1
			end
		end
	end
	
	MapGenerator.printMap(map)
	return map
end

function MapGenerator.printMap(map)
	for i,v in pairs(map) do
		local line = ""
		for j, v in pairs(v) do
			line = line .. v .. " "
		end
		print(line)
	end
end