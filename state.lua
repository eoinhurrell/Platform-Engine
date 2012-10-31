State = {}

-- Constructor
function State:new(g)
	-- define our parameters here
	local object = {
		game = g
	}
	setmetatable(object, { __index = State })
	return object
end

function State:update(dt)
	
end

function State:draw()
	
end