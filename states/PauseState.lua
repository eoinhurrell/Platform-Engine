PauseState = {}

require 'lib/Input'
require 'lib/Menu'

-- Constructor
function PauseState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "pause",
		input = Input:new(),
		menu = Menu:new(120,100),
		from = nil,
	}
	setmetatable(object, { __index = PauseState })
	return object
end

function PauseState:doAction()

end

function PauseState:init()
	--love.graphics.setNewFont("assets/DroidSans.ttf", 12)
	self.menu:addItem{name="Resume Game",action=function()self.game:switch(self.from.name)end}
	self.menu:addItem{name="Save",action=function()end}
	self.menu:addItem{name="Load",action=function()end}
	self.menu:addItem{name="Options",action=function()end}
	self.menu:addItem{name="Achievements",action=function()end}
	self.menu:addItem{name="Quit Game",action=function()self.game:switch("menus")end}
	self.menu:addItem{name="Quit To Desktop",action=function()love.event.quit()end}
	self.input:addButton("press","up",function()self.menu:selectPrevious() end)
	self.input:addButton("press","down",function()self.menu:selectNext() end)
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","return",function()self.menu:select()end)
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
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	self.from:draw()
	love.graphics.print("Paused", width/2-100,height/2-140,0)
	self.menu:draw()
end

function PauseState:drawMainPause()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width/2-150,height/2-150,300,300)
	love.graphics.setColor(255,255,255)
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