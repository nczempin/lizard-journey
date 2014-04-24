local o = {}

o.effectTimer = 0

o.update = function(dt)
	o.effectTimer = o.effectTimer + dt
end

o.draw = function()
	if o.effectTimer < 1.0 then
		local colorAberration1 = math.sin(love.timer.getTime() * 20.0) * (1.0 - o.effectTimer) * 4.0
		local colorAberration2 = math.cos(love.timer.getTime() * 20.0) * (1.0 - o.effectTimer) * 4.0
	else
		G.setFont(FONT)
		G.setColor(255, 0, 0, 127)
		G.printf("Game Over!", 0, 240, W.getWidth(), "center")
		G.setColor(255, 255, 255, 127)
		G.printf("Click to go to the main menu", 0, 320, W.getWidth(), "center")
	end
end

return o