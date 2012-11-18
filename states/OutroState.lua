DiedState = {}

-- Constructor
function DiedState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "died",
		input = Input:new(),
		from = nil,
		highlighted = 1,
		action_text={"Retry","Quit to Main Menu","Quit to Desktop"},
		action = nil
	}
	object.action = {
		function() object.from:restart() object.g:switch("level") end,
		function() object.g:switch("menus") end,
		function() love.event.quit() end
	}
	setmetatable(object, { __index = DiedState })
	return object
end

function DiedState:doAction()
	if self.action[self.highlighted] == nil then 
		error("Unknown command")
	else
		self.action[self.highlighted]()
	end
end

function DiedState:init()
	love.graphics.setNewFont("assets/DroidSans.ttf", 12)
	self.input = Input:new()
	self.input:addButton("press","up",function()self.highlighted = self.highlighted - 1 if self.highlighted < 1 then self.hightlighted = #self.action_text end end)
	self.input:addButton("press","down",function()self.highlighted = self.highlighted + 1 if self.highlighted > #self.action_text then self.hightlighted = 1 end end)
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","return",function()self:doAction()end)
	--self.input:addButton("press","`",function()self.game:switch("console")end)	
end --when state is first created, run only once
function DiedState:leave()end --when state is no longer active
function DiedState:enter(from, ...) --when state comes back from pause (or is transitioned into)
	self.from = from
end
function DiedState:finish()end --when state is finished
function DiedState:update(dt)
	self.input:update(dt)
end
function DiedState:draw()
	self.from:draw()
	self:drawMainPause()
end

function DiedState:drawMainPause()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width/2-150,height/2-150,300,300)
	love.graphics.setColor(255,255,255)
	love.graphics.print("You Died!", width/2-100,height/2-140,0,2,2)
	local numOptions = #self.action_text
	for i = 1, numOptions do
		love.graphics.print(self.action_text[i], width/2-80,(height/2-110)+(i*20))
	end
	love.graphics.print(">", width/2-90,(height/2-110)+(self.highlighted*20))
end

function DiedState:focus()end
function DiedState:keypressed(key)
	self.input:keypressed(key)
end
function DiedState:keyreleased(key)
	self.input:keyreleased(key)
end
function DiedState:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function DiedState:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function DiedState:joystickpressed()end
function DiedState:joystickreleased()end
function DiedState:quit()end