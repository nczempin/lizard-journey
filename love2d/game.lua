love.game = {}

require "external/gui/gui"
require "conf"
require "state/gameplay/world"
require "state/menus/main_menu"
require "state/menus/credits"
require "state/menus/menus"

function love.game.newGame()
	local o = {}
	o.world = nil
	o.menus = love.game.newMenus()
	o.init = function()

		--TODO: these are all states; they should be handled in the state manager
		o.world = love.game.newWorld()
		o.world.init()
		o.menus.init(o)

		print (o.menus)
		o.stateManager = love.game.newStateManager()

	end

	--called from main loop update
	o.update = function(dt)
		o.stateManager.update(dt)
	end

	--called from main loop draw
	o.draw = function()
		o.stateManager.draw()
	end



	return o
end
