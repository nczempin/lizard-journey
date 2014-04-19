require "sound"
	-- as of yet each sound will have to be added manually once
function love.sounds.initSounds()
	----envSounds:----------------------------
	--parameters: name,location,isLoop,playRandomly(NYI)
	love.sounds.addEnvSoundFile("birdSound","res/sfx/birds.mp3",true,false)
	
	----Background music:---------------------
	--parameters: name,location,isLoop
	love.sounds.addBgmSoundFile("fireplace","res/sfx/fireplace.mp3",true) --this is not actually a music file but it is sufficient to demonstrate how this works
end
