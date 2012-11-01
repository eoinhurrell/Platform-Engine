--https://github.com/karai17/love2d-input-manager/blob/master/input.lua
--https://github.com/mrcharles/love2d-xinput - XBOX support
Input = {}

-- Constructor
function Input:new()
    -- define our parameters here
    local object = {
		keyboard	= {},
		mouse= {}
    }
	 object.keyboard = {press = {},release = {},hold = {}}
	 object.mouse = {press = {},release = {},hold = {}}
    setmetatable(object, { __index = Input })
    return object
end

function Input:flush()
	for k,v in pairs(self.keyboard.press) do
		self:removeButton("press",k)
	end
	for k,v in pairs(self.keyboard.release) do
		self:removeButton("release",k)
	end
end

function Input:addButton(toggle, button, action, joystick)
	self.keyboard[toggle][button] = action
end

function Input:removeButton(toggle, button, joystick)
	self.keyboard[toggle][button] = nil
end

function Input:keypressed(key, unicode)
	local action = self.keyboard.press[key]
	if type(action) == "function" then action() end
end

function Input:keyreleased(key, unicode)
	local action = self.keyboard.release[key]
	if type(action) == "function" then action() end
end

function Input:keyboardisdown(dt)
	-- Update keys
	for key, action in pairs(self.keyboard.hold) do
		if type(action) == "function" and love.keyboard.isDown(key) then
			action(dt)
		end
	end
end

function Input:mousepressed(x, y, button)
	local action = self.mouse.press[button]
	if type(action) == "function" then action(x, y) end
end

function Input:mousereleased(x, y, button)
	local action = self.mouse.release[button]
	if type(action) == "function" then action(x, y) end
end

function Input:mouseisdown(dt)
	local x, y = love.mouse.getPosition()
	-- Update buttons
	for button, action in pairs(self.mouse.hold) do
		if type(action) == "function" and love.mouse.isDown(button) then
			action(x, y, dt)
		end
	end
end

function Input:update(dt)
	self:keyboardisdown(dt)
	self:mouseisdown(dt)
end