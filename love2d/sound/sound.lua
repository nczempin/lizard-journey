require "external/TEsound"
require "sound/ambientsound"

LOVE_SOUND_BGMUSICVOLUME 	= 0.3
LOVE_SOUND_SOUNDVOLUME		= 1.0

love.sounds = {}

-- old: soundNames = {}
love.sounds.envSounds = {} -- envSounds[name], look at addEnvSoundFile() for more details
love.sounds.ambientSound = getAmbientSoundGenerator()
love.sounds.bgm = {} --love.sounds.bgm[name], look at addBgmFile() for more details
love.sounds.bgm.activeBgm = nil --this helps making sure that only one BGM plays at a time
love.sounds.soundRandomizer = love.math.newRandomGenerator(os.time())
for i = 1,35 do
	love.sounds.soundRandomizer:random()
end

-- example: love.sounds.addSoundFile("MainSound","sounds/MainSoundFile.mp3",true)
-- only use this function in soundinit.lua!
function love.sounds.addEnvSoundFile(sName,sFilePath,looping,loopsPerPlay)
	--print ("trying to add sound "..sName.." from "..sFilePath)
	local o = {}
	o.filePath = sFilePath
	o.loop = looping
	o.loopsNo = loopsPerPlay
	o.isPlaying = false
	--o.playRandomly = playRand --NYI
	--o.loopTime = loopT --time from the end to the restart of a looped sound file
	--o.randomTime = randT --time modifier to loopTime, restart of loop file will be loopTime+/-randomTime
	love.sounds.envSounds[sName] = o
	--print(love.sounds.envSounds[sName].filePath)
end

-- mostly the same as addEnvSoundFile()
-- only use this function in soundinit.lua!
function love.sounds.addBgmSoundFile(sName,sFilePath,looping)
	--print("trying to add bgm "..sName..", "..sFilePath)
	local o = {}
	o.filePath = sFilePath
	o.loop = looping
	o.isPlaying = false
	love.sounds.bgm[sName] = o
	--print(love.sounds.bgm[sName].filePath)
end

-- local startTime = 0 -- this is not used right now

-- Functions for playing sounds
-- plays background music

-- example:
-- love.sounds.playBgm("battleIntro")
-- @param filepath to BackgroundMusicFile, or nil to stop playing bgm
function love.sounds.playBgm(sName)
	if not sName or not love.sounds.bgm[sName].isPlaying then
		if sName and not love.sounds.bgm[sName] then
			print("Warning: No music file found for "..sName)
		end
		if love.sounds.bgm.activeBgm  then
			TEsound.stop(love.sounds.bgm.activeBgm,false) --Stopping old BackgroundMusic, this would be the perfect place for a soft transition from one bgm file to another
			love.sounds.bgm[love.sounds.bgm.activeBgm].isPlaying = false
		end
		if not sName then
		--do nothing; nil means "stop playing"
		elseif love.sounds.bgm[sName].loop then
			TEsound.playLooping(love.sounds.bgm[sName].filePath,sName,nil,LOVE_SOUND_BGMUSICVOLUME)
		else
			TEsound.play(love.sounds.bgm[sName].filePath,sName,nil,LOVE_SOUND_BGMUSICVOLUME)
		end
		love.sounds.bgm.activeBgm = sName
		if sName then
			love.sounds.bgm[sName].isPlaying = true
		end
	else
		print ("Already playing "..sName)
	end
end

-- Plays a Sound Once
-- example:
-- love.sounds.playSound("fireplace")
-- @param sound name as specified in soundInit
-- @param  Time to Wait to Play the Sound in Milliseconds, inactive at the moment (sound won't play if you set this to a value anyway)
function love.sounds.playSound(sName, timeInMilliSeconds,pitch)
	--print(love.sounds.envSounds[sName].isPlaying)
	if love.sounds.envSounds[sName] then
		---if not love.sounds.envSounds[sName].isPlaying then
		if timeInMilliSeconds ~= nil then
		--startTime = love.timer.getTime()
		else
			if love.sounds.envSounds[sName].loop then
				TEsound.play(love.sounds.envSounds[sName].filePath,sName,LOVE_SOUND_SOUNDVOLUME,pitch,nil)
			else
				TEsound.playLooping(love.sounds.envSounds[sName].filePath,sName,love.sounds.envSounds[sName].loopsNo,LOVE_SOUND_SOUNDVOLUME,pitch,nil)
			end
			---love.sounds.envSounds[sName].isPlaying = true
		end
		print("playing sound "..sName..", "..love.sounds.envSounds[sName].filePath)
		---else
		---	print("Sound "..sName.." is already playing!")
		---end
	else
		print("There is no sound file called "..sName)
	end
end

--Stops the Background music
function love.sounds.stopBgm()
	if love.sounds.bgm.activeBgm then
		TEsound.stop(love.sounds.bgm.activeBgm,true)
		if love.sounds.envSounds[love.sounds.bgm.activeBgm] then
			love.sounds.envSounds[love.sounds.bgm.activeBgm].isPlaying = false
		end
	end
end

function love.sounds.stopSound(sName)
	TEsound.stop(sName,false)
	love.sounds.envSounds[sName].isPlaying = false
end
--[[ TODO
function love.sounds.stopAllSounds()
for k,v in pairs(TEsound.findTag("all")) do
print ("k, v:"..k..", "..v)
TEsound.stop(v, true)
love.sounds.envSounds[k].isPlaying = false
end
end
--]]

--Sets the Background Volume
--@param volume from 0 to 1
function love.sounds.setBackgroundVolume(volume)
	LOVE_SOUND_BGMUSICVOLUME = volume
	TEsound.volume(love.sounds.bgm.activeBgm, volume)
end

--Sets the Volume for sounds
function love.sounds.setSoundVolume(volume)
	LOVE_SOUND_SOUNDVOLUME	= volume
	TEsound.volume("all", volume)
	TEsound.volume(love.sounds.bgm.activeBgm, LOVE_SOUND_BGMUSICVOLUME)
end
