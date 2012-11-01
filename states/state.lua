State = {}

-- Constructor
function State:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "state",
		input = nil
	}
	setmetatable(object, { __index = State })
	return object
end

function State:init() --when state is first created, run only once
	self.input = Input:new()
end
function State:leave()end --when state is no longer active
function State:enter(from, ...)end --when state comes back from pause (or is transitioned into)
function State:finish()end --when state is finished
function State:update(dt)
	self.input:update(dt)
end
function State:draw()end
function State:focus()end
function State:keypressed(key)
	self.input:keypressed(key)
end
function State:keyreleased(key)
	self.input:keyreleased(key)
end
function State:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function State:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function State:joystickpressed()end
function State:joystickreleased()end
function State:quit()end


-- SNIPPET: Overwrite current callback
-- local old_update = love.update
-- function love.update(dt)
--     old_update(dt)
--     return Gamestate.current:update(dt)
-- end

-- SNIPPET: Switch between states
-- function GS.switch(to, ...)
-- 	assert(to, "Missing argument: Gamestate to switch to")
-- 	current:leave()
-- 	local pre = current
-- 	to:init()
-- 	to.init = __NULL__
-- 	current = to
-- 	return current:enter(pre, ...)
-- end

-- SNIPPET: FAR too advanced for me right now
-- -- holds all defined love callbacks after GS.registerEvents is called
-- -- returns empty function on undefined callback
-- local registry = setmetatable({}, {__index = function() return __NULL__ end})
-- 
-- local all_callbacks = {
-- 	'update', 'draw', 'focus', 'keypressed', 'keyreleased',
-- 	'mousepressed', 'mousereleased', 'joystickpressed',
-- 	'joystickreleased', 'quit'
-- }
-- 
-- function GS.registerEvents(callbacks)
-- 	callbacks = callbacks or all_callbacks
-- 	for _, f in ipairs(callbacks) do
-- 		registry[f] = love[f]
-- 		love[f] = function(...) return GS[f](...) end
-- 	end
-- end
-- 
-- -- forward any undefined functions
-- setmetatable(GS, {__index = function(_, func)
-- 	return function(...)
-- 		registry[func](...)
-- 		return current[func](current, ...)
-- 	end
-- end})