MapGenerator = {}

function MapGenerator.newMap(width, height)
	local map = {}
	for x = 1, width do
		map[x] = {}
		for y = 1, height do
			map[x][y] = 0
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