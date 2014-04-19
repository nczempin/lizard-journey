require "sound"
	-- as of yet each sound will have to be added manually once
function love.sounds.initSounds()
	----envSounds:----------------------------
	--parameters: name,location,isLoop,loopsPerPlay (if set to nil while isLoop is true, the sound will have to be stopped manually)
	love.sounds.addEnvSoundFile("birds","res/sfx/birds.mp3",true,1)
	love.sounds.addEnvSoundFile("windyCave","res/sfx/windy_cave.mp3",true,-1)
	love.sounds.addEnvSoundFile("fireplace","res/sfx/fireplace.mp3",true,-1)
	love.sounds.addEnvSoundFile("spell","res/sfx/spell.mp3",false)
	----Background music:---------------------
	--parameters: name,location,isLoop
	love.sounds.addBgmSoundFile("fireplace","res/sfx/fireplace.mp3",true) --this is not actually a music file but it is sufficient to demonstrate how this works
end
