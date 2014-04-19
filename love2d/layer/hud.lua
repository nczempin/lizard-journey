
function love.game.newHudLayer()
	local o = {}


	-- set font
	o.fontTitle = G.newFont(FONT_SIZE_LARGE)
	o.fontDescription = G.newFont(FONT_SIZE_MEDIUM)

	--o.player = player

	o.update = function(dt)
	--		o.guiGame.update(dt)

	--		if o.btnTower1.isHit() then
	--			love.turris.selectedtower = 1
	--		elseif o.btnTower2.isHit() then
	--			love.turris.selectedtower = 3
	--		elseif o.btnTower3.isHit() then
	--			love.turris.selectedtower = 4
	--		end
	--
	--		if love.keyboard.isDown("1") then
	--			love.turris.selectedtower = 1
	--			o.btnTower1.setChecked(true)
	--		--elseif love.keyboard.isDown("2") then
	--			--love.turris.selectedtower = 2 --2 would be the main base which should not be available for manual building
	--			--o.guiGame.flushRadioButtons()
	--		elseif love.keyboard.isDown("2") then
	--			love.turris.selectedtower = 3
	--			o.btnTower2.setChecked(true)
	--		elseif love.keyboard.isDown("3") then
	--			love.turris.selectedtower = 4
	--			o.guiGame.flushRadioButtons()
	--			o.btnTower3.setChecked(true)
	--		--elseif love.keyboard.isDown("5") then
	--			--love.turris.selectedtower = 5
	--			--o.guiGame.flushRadioButtons()
	--		end
	end

	o.draw = function()
		G.setFont(FONT_MEDIUM)
		G.setColor(0, 206, 209)
		G.print("Water: 100", FONT_SIZE_MEDIUM, FONT_SIZE_MEDIUM)
	end

	return o
end