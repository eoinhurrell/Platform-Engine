SummaryState = {}

-- Constructor
function SummaryState:new(g)
	-- define our parameters here
	local object = {
		game        = g,
		name        = "pause",
		input       = Input:new(),
		from        = nil,
		highlighted = 1,
		info        = Menu:new(120,100),
		options     = Menu:new(250,love.graphics.getHeight()-150)
	}
	setmetatable(object, { __index = SummaryState })
	return object
end

function SummaryState:init()
	--love.graphics.setNewFont("assets/DroidSans.ttf", 12)
	self.info:setSelectable(false)
	local str = "Score"
	str = str .. string.rep(' ', 45 - #str) .. self.game.statistics["level_score"]
	self.info:addItem{name=str,action=function()end}
	str = "Time"
	str = str .. string.rep(' ', 45 - #str) .. self.game.statistics["level_time"]
	self.info:addItem{name=str,action=function()end}
	str = "Time Walking"
	str = str .. string.rep(' ', 45 - #str) .. self.game.statistics["level_walk"]
	self.info:addItem{name=str,action=function()end}
	str = "Time Jumping"
	str = str .. string.rep(' ', 45 - #str) .. self.game.statistics["level_jump"]
	self.info:addItem{name=str,action=function()end}
	str = "Time Falling"
	str = str .. string.rep(' ', 45 - #str) .. self.game.statistics["level_fall"]
	self.info:addItem{name=str,action=function()end}
	str = "Time Hanging"
	str = str .. string.rep(' ', 45 - #str) .. self.game.statistics["level_hang"]
	self.info:addItem{name=str,action=function()end}
	
	self.options:addItem{name="Continue",action=function()self.game:switch(self.from.name)end}
	self.options:addItem{name="Quit to Menu",action=function()self.game:switch(self.from.name)end}
	self.options:addItem{name="Quit to Desktop",action=function()self.game:switch(self.from.name)end}
	
	self.input = Input:new()
	self.input:addButton("press","up",function()self.options:selectPrevious()end)
	self.input:addButton("press","down",function()self.options:selectNext()end)
	self.input:addButton("press","spacebar",function()self.options:select()end)
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","return",function()self.options:select()end)
	--self.input:addButton("press","`",function()self.game:switch("console")end)	
end --when state is first created, run only once
function SummaryState:leave()end --when state is no longer active
function SummaryState:enter(from, ...) --when state comes back from pause (or is transitioned into)
	self.from = from
end
function SummaryState:finish()end --when state is finished
function SummaryState:update(dt)
	self.input:update(dt)
end
function SummaryState:draw()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width,height,300,300)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Level Summary", width/2-100,height/2-240,0,2,2)
	self.info:draw()
	self.options:draw()
end

function SummaryState:focus()end
function SummaryState:keypressed(key)
	self.input:keypressed(key)
end
function SummaryState:keyreleased(key)
	self.input:keyreleased(key)
end
function SummaryState:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function SummaryState:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function SummaryState:joystickpressed()end
function SummaryState:joystickreleased()end
function SummaryState:quit()end