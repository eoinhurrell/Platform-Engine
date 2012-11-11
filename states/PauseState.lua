PauseState = {}

-- Constructor
function PauseState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "pause",
		input = Input:new(),
		from = nil,
		highlighted = 1,
		action_text={"Quit to Desktop"},
		action = {function() love.event.quit() end}
	}
	setmetatable(object, { __index = PauseState })
	return object
end

function PauseState:doAction()
	if self.action[self.highlighted] == nil then 
		error("Unknown command")
	else
		self.action[self.highlighted]()
	end
end

function PauseState:init()
	self.input = Input:new()
	self.input:addButton("press","up",function()self.highlighted = self.highlighted - 1 if self.highlighted < 1 then self.hightlighted = #self.action_text end end)
	self.input:addButton("press","down",function()self.highlighted = self.highlighted + 1 if self.highlighted > #self.action_text then self.hightlighted = 1 end end)
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","return",function()self:doAction()end)
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
	self:drawMainPause()
end

function PauseState:drawMainPause()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width/2-150,height/2-150,300,300)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Paused", width/2-100,height/2-140,0,2,2)
	local numOptions = #self.action_text
	for i = 1, numOptions do
		love.graphics.print(self.action_text[i], width/2-80,(height/2-110)+(i*20))
	end
	love.graphics.print(">", width/2-90,(height/2-110)+(self.highlighted*20))
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