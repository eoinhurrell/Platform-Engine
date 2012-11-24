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
		menus = {},
		current_menu = "main",
		from = nil,
	}
	setmetatable(object, { __index = PauseState })
	return object
end

function PauseState:doAction()

end

function PauseState:init()
	--love.graphics.setNewFont("assets/DroidSans.ttf", 12)
	self.menus["main"] = Menu:new(120,100)
	self.menus["save"] = Menu:new(120,100)
	self.menus["load"] = Menu:new(120,100)
	self.menus["options"] = Menu:new(120,100)
	
	--Main Menu
	self.menus["main"]:addItem{name="Resume Game",action=function()self.game:switch(self.from.name)end}
	self.menus["main"]:addItem{name="Save",action=function()self.current_menu="save"end}
	self.menus["main"]:addItem{name="Load",action=function()self.current_menu="load"end}
	self.menus["main"]:addItem{name="Options",action=function()self.current_menu="options"end}
	self.menus["main"]:addItem{name="Toggle Debug",action=function()self.game:setDebugStatus(not self.game:isDebug())end}
	self.menus["main"]:addItem{name="Achievements",action=function()end}
	self.menus["main"]:addItem{name="Quit Game",action=function()self.game:switch("menus")end}
	self.menus["main"]:addItem{name="Quit To Desktop",action=function()love.event.quit()end}
	
	
	--Save Menu
	self.menus["save"]:addItem{name="Back",action=function()self.current_menu="main"end}
	
	--Load Menu
	self.menus["load"]:addItem{name="Back",action=function()self.current_menu="main"end}
	
	--Options Menu
	self.menus["options"]:addItem{name="Back",action=function()self.current_menu="main"end}	
	
	--INPUTS
	self.input:addButton("press","up",function()self.menus[self.current_menu]:selectPrevious() end)
	self.input:addButton("press","down",function()self.menus[self.current_menu]:selectNext() end)
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","return",function()self.menus[self.current_menu]:select()end)
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
	self:printTitle()
	self.menus[self.current_menu]:draw()
end

function PauseState:printTitle()
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill",120,80,120,60)
	love.graphics.setColor(0,0,0)
	love.graphics.print("Paused", 130,85,0)
	love.graphics.setColor(255,255,255)
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