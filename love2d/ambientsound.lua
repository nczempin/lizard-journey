require "mapGenerator"
-- world map: lizGame.world.map.*
-- THIS IS ONLY THE SOUND PRODUCED BY THE AMBIENT (TODO the ambient consists of everything that is on the normal world map right now)
-- for sound produced by objects (e.g. the player or a door or an enemy) look at objectsound.lua (NYI)
--[[ possible sound sources:
	1. player/selected character
	2. map center
--]]
--[[ possible values for the SoundMap:
	nil/0: no sound at all -- other tile or out of map
	1: birds -- just for testing
--]]

function getAmbientSoundGenerator() --not nice but this cannot be part of the namespace "love.sounds.*"
	local o = {}
	o.soundActive = false
	o.listeningRadius = 4 -- this will be used for determining how far a tile may be for the player to hear a sound
	o.origX = 0
	o.origY = 0
	o.soundMap = {}
	-- call this method once at initialization and every time the listening radius is changed 
	o.resetSoundMap = function()
		local tempSoundMap = {}
		for i = 1,2*o.listeningRadius+1 do 
			tempSoundMap[i] = {}
			for j = 1, 2*o.listeningRadius+1 do
				tempSoundMap[i][j] = 0 --this variable should hold the sound name
			end
		end
		o.soundMap = tempSoundMap
	end


	o.updateSoundMap = function()
		o.resetSoundMap()
		for i = 1,2*o.listeningRadius+1 do
			if i+o.origX-o.listeningRadius < 1 or i+o.origX-o.listeningRadius>lizGame.world.mapWidth then
				for j = 1, 2*o.listeningRadius+1 do
					o.soundMap[i][j] = 0
				end
			else
				for j = 1, o.listeningRadius+o.origY do
					if j+o.origY-o.listeningRadius < 1 or j+o.origY-o.listeningRadius>lizGame.world.mapHeight then
						o.soundMap[i][j] = 0
					else
						local t = MapGenerator.getObject(lizGame.world.mapG,i+o.origX-o.listeningRadius,j+o.origY-o.listeningRadius)
						--print ("tile to add:"..t)
						--TODO change this when 3D world is implemented
						o.soundMap[i][j] = t
						--print ("tile added? "..o.soundMap[i][j])
					end
				end
			end
		end
	end

	o.setOrigin = function()
		--TODO, default for now: look at pawn #1
		local tempx,tempy = lizGame.world.pawns[1].getPosition()
		o.origX = math.floor(tempx+0.5)
		o.origY = math.floor(tempy+0.5)
	end

	o.playAmbient = function()
		if o.soundActive and lizGame.state == states.GAME_PLAY then
			o.setOrigin()
			o.updateSoundMap()
			local tileAmount = {}
			for i=0,9 do
				tileAmount[i]=0
			end
			for i = 1,2*o.listeningRadius+1 do
				for j = 1, 2*o.listeningRadius+1 do
					--print("trying to insert "..o.soundMap[i][j])
					--tileAmount[o.soundMap[i][j]] and 
					local soundMapValue = o.soundMap[i][j]
					if soundMapValue>0 then
						tileAmount[soundMapValue] = tileAmount[soundMapValue] + 1
					end
				end
			end
			-- quick algorithm to find the most used tile within listener range
			local mostUsed = 0
			local mostUsedAmount = 0
			local secondMostUsed = 0
			for i=1,#tileAmount do
				if tileAmount[i]>mostUsedAmount then
					secondMostUsed = mostUsed
					mostUsed = i
					mostUsedAmount = tileAmount[i]
				end
				--print("Amount of "..i..":"..tileAmount[i])
			end
			--print("Most used: "..mostUsed..", "..secondMostUsed)
			-- play the right music file
			if mostUsed == 1 then
				love.sounds.playSound("riverLoop1")
			elseif mostUsed == 2 then
				love.sounds.playSound("birds")
			elseif mostUsed == 4 then
				love.sounds.playSound("fireplace")
			elseif mostUsed == 5 then
				love.sounds.playSound("bird")
			end
		end
	end
	return o
end
