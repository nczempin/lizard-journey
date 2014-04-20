require "external/TEsound"

LOVE_SOUND_BGMUSICVOLUME 	= 0.5
LOVE_SOUND_SOUNDVOLUME		= 0.5

love.sounds = {}

-- old: soundNames = {}
envSounds = {} -- envSounds[name], look at addEnvSoundFile() for more details
bgm = {} -- bgm[name], look at addBgmFile() for more details
bgm.activeBgm = nil --this helps making sure that only one BGM plays at a time

-- example: love.sounds.addSoundFile("MainSound","sounds/MainSoundFile.mp3",true)
-- only use this function in soundinit.lua!
function love.sounds.addEnvSoundFile(sName,sFilePath,looping,loopsPerPlay)
	print ("trying to add sound "..sName.." from "..sFilePath)
	local o = {}
	o.filePath = sFilePath
	o.loop = looping
	o.loopsNo = loopsPerPlay
	o.isPlaying = false
	--o.playRandomly = playRand
	--o.loopTime = loopT --time from the end to the restart of a looped sound file 
	--o.randomTime = randT --time modifier to loopTime, restart of loop file will be loopTime+/-randomTime
	envSounds[sName] = o
	print(envSounds[sName].filePath)
end

-- mostly the same as addEnvSoundFile()
-- only use this function in soundinit.lua!
function love.sounds.addBgmSoundFile(sName,sFilePath,looping)
	print("trying to add bgm "..sName..", "..sFilePath)
	local o = {}
	o.filePath = sFilePath
	o.loop = looping
	o.isPlaying = false
	bgm[sName] = o
	print(bgm[sName].filePath)
end

-- local startTime = 0 -- this is not used right now

-- Functions for playing sounds
-- plays background music
-- example:
-- love.sounds.playBgm("battleIntro")
-- @param filepath to BackgroundMusicFile
function love.sounds.playBgm(sName)
	if not bgm[sName].isPlaying then
		if not bgm[sName] then
			print("Warning: No music file found for "..sName)
			return
		end
		if bgm[sName] and bgm.activeBgm then 
			TEsound.stop(bgm.activeBgm,false) --Stopping old BackgroundMusic, this would be the perfect place for a soft transition from one bgm file to another
		end
		if bgm[sName].loop then
			TEsound.playLooping(bgm[sName].filePath,sName,nil,LOVE_SOUND_BGMUSICVOLUME)
		else
			TEsound.play(bgm[sName].filePath,sName,nil,LOVE_SOUND_BGMUSICVOLUME)
		end
		bgm.activeBgm = sName
		bgm[sName].isPlaying = true
	end
end

-- Plays a Sound Once
-- example:
-- love.sounds.playSound("fireplace")
-- @param sound name as specified in soundInit
-- @param  Time to Wait to Play the Sound in Milliseconds, inactive at the moment (sound won't play if you set this to a value anyway)
function love.sounds.playSound(sName, timeInMilliSeconds)
	print(envSounds[sName].isPlaying)
	if envSounds[sName] and not envSounds[sName].isPlaying then
		if timeInMilliSeconds ~= nil then
			--startTime = love.timer.getTime()
		else
			--print("playing sound "..sName..", "..envSounds[sName].filePath)
			if envSounds[sName].loop then
				TEsound.play(envSounds[sName].filePath,sName,LOVE_SOUND_SOUNDVOLUME,nil,nil)
			else
				TEsound.playLooping(envSounds[sName].filePath,sName,envSounds[sName].loopsNo,LOVE_SOUND_SOUNDVOLUME,nil,nil)
			end
			envSounds[sName].isPlaying = true
		end
	else
		print("There is no sound file called "..sName)
	end
end

--Stops the Background music
function love.sounds.stopSound(sName)
	TEsound.stop(sName,false)
	envSounds.sName.isPlaying = false
end

--Sets the Background Volume
--@param volume from 0 to 1
function love.sounds.setBackgroundVolume(volume)
	LOVE_SOUND_BGMUSICVOLUME = volume
	TEsound.volume(bgm.activeBgm, volume)
end

--Sets the Volume for sounds
function love.sounds.setSoundVolume(volume)
	LOVE_SOUND_SOUNDVOLUME	= volume
	TEsound.volume("all", volume)
	TEsound.volume(bgm.activeBgm, LOVE_SOUND_BGMUSICVOLUME)
end
