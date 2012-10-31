MenuState = {}

-- Constructor
function MenuState:new(g)
	-- define our parameters here
	local object = {
		game = g
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:update(dt)
	
end

function MenuState:draw()
	
end