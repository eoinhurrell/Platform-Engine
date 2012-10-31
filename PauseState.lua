PauseState = {}

-- Constructor
function PauseState:new(g)
	-- define our parameters here
	local object = {
		game = g
	}
	setmetatable(object, { __index = PauseState })
	return object
end

function PauseState:update(dt)
	
end

function PauseState:draw()
	
end