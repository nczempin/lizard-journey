function love.game.newCreditsScreen()
	local o = {}
	o.draw = function()
		o.drawCredits()

	end
	-- TODO own class for credits
	o.setupCredits = function()
		if not o.peopleTextual then
			o.people = {
				"Markus Vill (Code)", "Nicolai Czempin (Code)", "Bernd Hildebrandt (Graphics)",
				"Marcus Ihde (Code)", "Meral Leyla (Sound, Music)", "Aldo Briessmann (Code)", "Terence-Lee Davis (Graphics)", "Francisco Pinto (Code)",
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
		lizGame.menus.drawBackgroundImage() --TODO no globals
		lizGame.menus.drawTitle("Credits")--TODO no globals

		local hh = W.getHeight()/2
		local w = W.getWidth()
		G.setFont(o.peopleFont)
		G.setColor(0.318, 0.318, 0.318)
		G.printf(o.peopleTextual, 0, o.creditsHPos, w, "center")
		G.setColor(1, 1, 1)

		--		G.setFont(FONT_LARGE)
		--		G.setColor(120, 118, 112)
		--		G.printf("Click anywhere to exit.", 0, W.getHeight()*.85, w, "center")

		G.setColor(1, 1, 1)
	end


	return o
end
function love.game.newCrState(sm)
	local creditsState = {name = "credits"}
	creditsState.actions = {}
	local crUp = function(dt)
	--o.states.CREDITS.update(dt)
	end
	local crDraw = function()
		lizGame.menus.credits.drawCredits()
	end


	local crMousepressed = function()
		print "firing gotoMainMenu"
		sm.fsm:fire("gotoMainMenu")
	end
	local crKeypressed = function()
		print "firing gotoMainMenu"
		sm.fsm:fire("gotoMainMenu")
	end
	creditsState.actions["keypressed"] = crKeypressed
	creditsState.actions["mousepressed"] = crMousepressed


	creditsState.actions["update"] = crUp
	creditsState.actions["draw"] = crDraw
	return creditsState
end