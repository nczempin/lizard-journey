require('math')

MapGenerator = {}

MAP_PLAIN = 0
MAP_MOUNTAIN = 1
MAP_PLAIN_START = 2
MAP_PLAIN_WATER = 3
MAP_MOUNTAIN_WATER = 4
MAP_PLAIN_TREE = 5

MAP_WATER_PERCENTAGE = 0.1
MAP_TREE_PERCENTAGE = 0.1

function MapGenerator.newMap(width, height)
	local map = {}
	local plain = {}
	local mountain = {}
	local countPlain = 0
	for x = 1, width do
		map[x] = {}
		for y = 1, height do
			if y/width < 0.5 * math.cos((x / height) * 2 * math.pi - 2*math.pi/3)  -math.abs(0.5 * math.cos((x / height) * 4 * math.pi - 2*math.pi/3)) + 0.5 then
				map[x][y] = MAP_PLAIN
				countPlain = countPlain + 1
				plain[#plain + 1] = {x, y}
			else
				map[x][y] = MAP_MOUNTAIN
				mountain[#mountain + 1] = {x, y}
			end
		end
	end
	
	local numPlain = #plain
	local numMountains = #mountain
	-- create trees
	local numTrees = MAP_TREE_PERCENTAGE * countPlain
	for i = 1, numTrees do
		local idx = math.random(#plain)
		local pos = plain[idx]
		table.remove(plain, idx)
		map[pos[1]][pos[2]] = MAP_PLAIN_TREE
		print("Tree: ", pos[1], pos[2])
	end
	
	-- create start point
	local numUnits = 1
	for i = 1, numUnits do
		local idx = math.random(#plain)
		local pos = plain[idx]
		table.remove(plain, idx)
		map[pos[1]][pos[2]] = MAP_PLAIN_START
		print("Unit: ", pos[1], pos[2])
	end
	
	-- create water
	local numWater = MAP_WATER_PERCENTAGE * width * height
	for i = 1, numWater do
		local pos
		if (math.random() < numPlain/(numPlain + numMountains) and #plain > 0) or (#mountain == 0 and #plain > 0) then
			local idx = math.random(#plain)
			pos = plain[idx]
			table.remove(plain, idx)
			map[pos[1]][pos[2]] = MAP_PLAIN_WATER
		else
			local idx = math.random(#mountain)
			pos = mountain[idx]
			table.remove(mountain, idx)
			map[pos[1]][pos[2]] = MAP_MOUNTAIN_WATER
		end
		print("Water: ", pos[1], pos[2])
	end
	
	MapGenerator.printMap(map)
	print("Trees: ", numTrees, "Water: ", numWater, "Units: ", numUnits)
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

function MapGenerator.getID(map, x, y)
	return map[x][y][1] + 2 * map[x][y][2]
end