function love.game.newCreditsScreen()
	local o = {}
	o.draw = function()
		o.drawCredits()

	end
	-- TODO own class for credits
	o.setupCredits = function()
		if not o.peopleTextual then
			o.people = {
				"Markus Vill", "Nicolai Czempin", "Bernd Hildebrandt",
				"Marcus Ihde", "Meral Leyla", "Aldo Briessmann", "Terence-Lee Davis", "Francisco Pinto",
			}
			table.sort(o.people) -- 2lazy

			o.peopleTextual = ""
			for i, person in ipairs(o.people) do
				o.peopleTextual = o.peopleTextual .. person
				if i ~= #o.people then
					o.peopleTextual = o.peopleTextual .. "\n\n"
				end
			end

			o.peopleFont = FONT_MEDIUM
			local nLines = select(2, o.peopleTextual:gsub('\n', '\n'))
			o.creditsHPos = W.getHeight()/2 - .75*nLines/2*o.peopleFont:getHeight()
		end
	end

	o.drawCredits = function()
		lizGame.drawBackgroundImage() --TODO no globals
		lizGame.drawTitle("Credits")--TODO no globals

		local hh = W.getHeight()/2
		local w = W.getWidth()
		G.setFont(o.peopleFont)
		G.setColor(81, 81, 81)
		G.printf(o.peopleTextual, 0, o.creditsHPos, w, "center")
		G.setColor(255, 255, 255)

		--		G.setFont(FONT_LARGE)
		--		G.setColor(120, 118, 112)
		--		G.printf("Click anywhere to exit.", 0, W.getHeight()*.85, w, "center")

		G.setColor(255, 255, 255)
	end


	return o
end