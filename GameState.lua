GameState = {}

require "Player"

-- Constructor
function GameState:new(g)
	-- define our parameters here
	local object = {
		game = g
	}
	self.loadLevel()
	setmetatable(object, { __index = GameState })
	return object
end

function GameState:update(dt)
	
end

function GameState:draw()
	
end

function GameState:loadLevel()
	if self.game.debug then
		--print "Loading level :" .. self.game.level 
		--print "	level file  :" .. self.game.level_files[self.game.level]
	end
end
