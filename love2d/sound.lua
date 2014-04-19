require "external/TEsound"

LOVE_SOUND_BGMUSICVOLUME 	= 0.5
LOVE_SOUND_SOUNDVOLUME		= 0.5

love.sounds = {}

-- old: soundNames = {}
envSounds = {} -- envSounds[name], look at addEnvSoundFile() for more details
bgm = {} -- bgm[name], look at addBgmFile() for more details
bgm.activeBgm = nil --this helps making sure that only one BGM plays at a time

-- bad example: envSounds.name = "name"
-- good example: love.sounds.addSoundFile("MainSound","sounds/MainSoundFile.mp3",true)

function love.sounds.addEnvSoundFile(sName,sFilePath,looping,playRand)
	print ("trying to add "..sName.." from "..sFilePath)
	local o = {}
	o.filePath = sFilePath
	o.loop = looping
	--o.playRandomly = playRand -- NYI
	--o.playPerSecond = pps --chance that this will play in a second, this might be more complicated than necessary
	envSounds.sName = o
	print(envSounds.sName.filePath)
end

function love.sounds.addBgmFile(sName,sFilePath,looping)
	bgm[sName].soundName = sName
	bgm[sName].filePath = sFilePath
	bgm[sName].loop = looping
end

local startTime = 0

-- Functions for playing sounds
-- Adds an BackgroundMusic
-- @param filepath to BackgroundMusicFile
function love.sounds.playBgm(sName)
	if bgm.activeBgm then 
		TEsound.stop(bgm.activeBgm,false) --Stopping old BackgroundMusic, this would be the perfect place for a soft transition from one bgm file to another
	end
	if bgm[sName].loop then
		TEsound.playLooping(bgm[sName].filePath,sName,nil,LOVE_SOUND_BGMUSICVOLUME)
	else
		TEsound.play(bgm[sName].filePath,sName,nil,LOVE_SOUND_BGMUSICVOLUME)
	end
	bgm.activeBgm = sName
end

--Stops the Background music
function love.sounds.stopSound(sName)
	TEsound.stop(sName,false)
end

-- Plays a Sound Once
-- @param sound name as specified in soundInit
-- @param  Time to Wait to Play the Sound in Milliseconds
function love.sounds.playSound(sName, timeInMilliSeconds)
	if envSounds.sName then
		if timeInMilliSeconds ~= nil then
			startTime = love.timer.getTime()
		else
			TEsound.play(envSounds.sName.filePath,sName,LOVE_SOUND_SOUNDVOLUME,nil,nil)
		end
	else
		print("There is no envSound called "..sName)
	end
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
