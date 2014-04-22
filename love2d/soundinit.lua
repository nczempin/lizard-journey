require "sound"
	-- as of yet each sound will have to be added manually once
function love.sounds.initSounds()
	----envSounds:----------------------------
	--parameters: name,location,isLoop,loopsPerPlay (if set to nil while isLoop is true, the sound will have to be stopped manually)

	love.sounds.addEnvSoundFile("bird","res/sfx/bird.mp3",true,nil)
	love.sounds.addEnvSoundFile("birds","res/sfx/birds.mp3",true,nil)
	love.sounds.addEnvSoundFile("caveAtmo","res/sfx/cave_atmo.mp3",true,nil)
	love.sounds.addEnvSoundFile("darkAtmo2","res/sfx/dark_atmo_2.mp3",true,nil)
	love.sounds.addEnvSoundFile("darkAtmo3","res/sfx/dark_atmo_3.mp3",true,nil)
	love.sounds.addEnvSoundFile("distortedAtmo","res/sfx/distorted_atmo.mp3",true,nil)
	love.sounds.addEnvSoundFile("fireplace","res/sfx/fireplace.mp3",true,nil)
	love.sounds.addEnvSoundFile("riverLoop1","res/sfx/river_loop_1.mp3",true,nil)
	love.sounds.addEnvSoundFile("spell","res/sfx/spell.mp3",false)
	love.sounds.addEnvSoundFile("tensionAtmo","res/sfx/tension_atmo.mp3",true,nil)
	--love.sounds.addEnvSoundFile("waterBirdsEnvironment","res/sfx/water_birds_environment.mp3",true,nil)
	love.sounds.addEnvSoundFile("windyCave","res/sfx/windy_cave.mp3",true,nil)

	----Background music:---------------------
	--parameters: name,location,isLoop
	love.sounds.addBgmSoundFile("desertCowboy","res/music/desert_cowboy.mp3",true)
	love.sounds.addBgmSoundFile("battleIntro","res/music/battle_intro.mp3",true)
	love.sounds.addBgmSoundFile("heroicMoments","res/music/Heroic_Moments.mp3",true)
	love.sounds.addBgmSoundFile("lizardGuitarFx","res/music/lizard_guitar_fx.mp3",true)
	love.sounds.addBgmSoundFile("lizardGuitarSlow","res/music/lizard_guitar_slow.mp3",true)
	love.sounds.addBgmSoundFile("lizardViolinSession","res/music/lizard_violin_session.mp3",true)
	love.sounds.addBgmSoundFile("magicalTale","res/music/Magical_Tale.mp3",true)
	love.sounds.addBgmSoundFile("lizardIndustrial","res/music/lizard_industrial.mp3",true)
end
