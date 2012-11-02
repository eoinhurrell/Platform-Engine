PauseState = {}

-- Constructor
function PauseState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "pause",
		input = Input:new(),
		from = nil,
		highlighted = 0
	}
	setmetatable(object, { __index = PauseState })
	return object
end

function PauseState:init()
	self.input = Input:new()
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	--self.input:addButton("press","`",function()self.game:switch("console")end)	
end --when state is first created, run only once
function PauseState:leave()end --when state is no longer active
function PauseState:enter(from, ...) --when state comes back from pause (or is transitioned into)
	self.from = from
end
function PauseState:finish()end --when state is finished
function PauseState:update(dt)
	self.input:update(dt)
end
function PauseState:draw()
	self.from:draw()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width/2-200,height/2-200,400,400)	
end
function PauseState:focus()end
function PauseState:keypressed(key)
	self.input:keypressed(key)
end
function PauseState:keyreleased(key)
	self.input:keyreleased(key)
end
function PauseState:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function PauseState:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function PauseState:joystickpressed()end
function PauseState:joystickreleased()end
function PauseState:quit()end