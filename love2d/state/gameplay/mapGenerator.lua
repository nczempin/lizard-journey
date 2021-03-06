require('math')

MapGenerator = {}

MAP_UNDEFINED = 0
MAP_PLAIN = 1
MAP_MOUNTAIN = 2
MAP_PLAIN_DESERT = 3
MAP_MOUNTAIN_DARK = 4

MAP_OBJ_NOTHING = 0
MAP_OBJ_WATER = 1
MAP_OBJ_TREE = 2
MAP_OBJ_START = 3
MAP_OBJ_FIREPLACE = 4
MAP_OBJ_BUSH1 = 5
MAP_OBJ_BUSH2 = 6
MAP_OBJ_BUSH3 = 7
MAP_OBJ_BUSH4 = 8
MAP_OBJ_STONE = 9

MAP_WATER_PERCENTAGE = 0.15
MAP_TREE_PERCENTAGE = 0.1
MAP_FIREPLACE_PERCENTAGE = 0.1
MAP_STONE_PERCENTAGE = 0.1

function MapGenerator.newMap(width, height)
	math.randomseed( os.time() )
	local map = {}
	local plain = {}
	local mountain = {}
	local plainTypes = {MAP_PLAIN, MAP_PLAIN_DESERT}
	local mountainTypes = {MAP_MOUNTAIN, MAP_MOUNTAIN_DARK}
	local treeTypes = {MAP_OBJ_TREE, MAP_OBJ_BUSH1, MAP_OBJ_BUSH2, MAP_OBJ_BUSH3, MAP_OBJ_BUSH4}
	local countPlain = 0
	for x = 1, width do
		map[x] = {}
		for y = 1, height do
			if y/width < 0.5 * math.cos((x / height) * 2 * math.pi - 2*math.pi/3)  -math.abs(0.5 * math.cos((x / height) * 4 * math.pi - 2*math.pi/3)) + 0.5 then
				local ttype = math.random(#plainTypes)
				map[x][y] = {plainTypes[ttype], MAP_OBJ_NOTHING}
				countPlain = countPlain + 1
				plain[#plain + 1] = {x, y}
			else
				local ttype = math.random(#mountainTypes)
				map[x][y] = {mountainTypes[ttype], MAP_OBJ_NOTHING}
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
		local ttype = math.random(#plainTypes)
		map[pos[1]][pos[2]][2] = treeTypes[ttype]
		--print("Tree: ", pos[1], pos[2])
	end
	
	-- create start point
	local numUnits = 1
	for i = 1, numUnits do
		local idx = math.random(#plain)
		local pos = plain[idx]
		table.remove(plain, idx)
		map[pos[1]][pos[2]][2] = MAP_OBJ_START
		--print("Unit: ", pos[1], pos[2])
	end
	
	-- create water
	local numWater = MAP_WATER_PERCENTAGE * width * height
	local waterToPlace = numWater
	while waterToPlace > 0 do
		local pos
		local maxSize = math.random(1, math.min(15, waterToPlace))
		if (math.random() < numPlain/(numPlain + numMountains) and #plain > 0) or (#mountain == 0 and #plain > 0) then
			local idx = math.random(#plain)
			pos = plain[idx]
			waterToPlace = waterToPlace - MapGenerator.generateWater(pos[1], pos[2], {plain, mountain}, map, width, height, maxSize)
		else
			local idx = math.random(#mountain)
			pos = mountain[idx]
			waterToPlace = waterToPlace - MapGenerator.generateWater(pos[1], pos[2], {plain, mountain}, map, width, height, maxSize)
		end
		--print("Water: ", pos[1], pos[2], "@", maxSize)
	end
	
	--create fire places
	local numFirePlaces = MAP_FIREPLACE_PERCENTAGE * countPlain
	for i = 1, numFirePlaces do
		local pos
		local idx = math.random(#plain)
		local pos = plain[idx]
		table.remove(plain, idx)
		map[pos[1]][pos[2]][2] = MAP_OBJ_FIREPLACE
		--print("Fire place: ", pos[1], pos[2])
	end
	
	--create stones
	local numStonePlaces = MAP_STONE_PERCENTAGE * countPlain
	for i = 1, numStonePlaces do
		local pos
		local idx = math.random(#plain)
		local pos = plain[idx]
		table.remove(plain, idx)
		map[pos[1]][pos[2]][2] = MAP_OBJ_STONE
		--print("Stone: ", pos[1], pos[2])
	end
	
	MapGenerator.printMap(map)
	print("Trees: ", numTrees, "Water: ", numWater, "Units: ", numUnits, "Fire places: ", numFirePlaces, "Stones: ", numStonePlaces)
	return map
end

function MapGenerator.removePosFromTables(tables, x, y)
	for idx, tab in pairs(tables) do
		for i, v in pairs(tab) do
			if x == v[1] and y == v[2] then
				table.remove(tab, i)
				return
			end
		end
	end
end

function MapGenerator.canPlaceWater(map, x, y)
	if map[x][y][2] == MAP_OBJ_NOTHING then
		return true
	else
		return false
	end
end

function MapGenerator.placeWater(map, x, y)
	if map[x][y][2] == MAP_OBJ_NOTHING then
		map[x][y][2] = MAP_OBJ_WATER
		return true
	else
		return false
	end
end

function MapGenerator.isValidPosition(x, y, width, height)
	if x < 1 or x > width then
		return false
	end
	if y < 1 or y > height then
		return false
	end
	return true
end

function MapGenerator.checkWaterTarget(map, x, y, width, height)
	if MapGenerator.isValidPosition(x, y, width, height) then
		return MapGenerator.canPlaceWater(map, x, y)
	end
	return false
end

function MapGenerator.generateWater(x, y, tables, map, width, height, maxSize)
	local placed = 0
	if MapGenerator.placeWater(map, x, y) then
		MapGenerator.removePosFromTables(tables, x, y)
		placed = placed + 1
	else
		return placed
	end
	
	for i = 1, maxSize - 1 do
		-- locate possible targets
		local neighbours = {}
		if MapGenerator.checkWaterTarget(map, x - 1, y    , width, height) then neighbours[#neighbours + 1] = {x - 1, y    } end
		if MapGenerator.checkWaterTarget(map, x + 1, y    , width, height) then neighbours[#neighbours + 1] = {x + 1, y    } end
		if MapGenerator.checkWaterTarget(map, x    , y - 1, width, height) then neighbours[#neighbours + 1] = {x    , y - 1} end
		if MapGenerator.checkWaterTarget(map, x    , y + 1, width, height) then neighbours[#neighbours + 1] = {x    , y + 1} end
		
		if #neighbours < 1 then
			return placed
		end
		
		local idx = math.random(#neighbours)
		local pos = neighbours[idx]
		if MapGenerator.placeWater(map, pos[1], pos[2]) then
			MapGenerator.removePosFromTables(tables, pos[1], pos[2])
			placed = placed + 1
			x = pos[1]
			y = pos[2]
		else
			return placed
		end
	end
	return placed
end

function MapGenerator.printMap(map)
	for i,v in pairs(map) do
		local line = ""
		for j, v in pairs(v) do
			line = line .. (v[1] + 2 * v[2]) .. " "
		end
		--print(line)
	end
end


function MapGenerator.getID(map, x, y)
	return map[x][y][1]
end

function MapGenerator.getObject(map, x, y)
	return map[x][y][2]
end

function MapGenerator.setID(map, x, y, id)
	map[x][y][1] = id
end

function MapGenerator.setObject(map, x, y, obj)
	map[x][y][2] = obj
end
