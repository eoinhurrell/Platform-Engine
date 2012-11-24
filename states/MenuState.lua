MenuState = {}

require 'lib/Menu'

-- Constructor
function MenuState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		input = Input:new(),
		menus = {},
		current_menu = "main",
		name = "menus",
		title_image = nil,
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	self.title_image = love.graphics.newImage("assets/RebelGorilla.png")
	self.menus["main"] = Menu:new(600,400)
	self.menus["options"] = Menu:new(600,400)
	self.menus["video"] = Menu:new(600,400)
	self.menus["audio"] = Menu:new(600,400)
	self.menus["controls"] = Menu:new(600,400)
	--MAIN MENU
	--Here's where we decide if CONTINUE GAME akes sense
	self.menus["main"]:addItem{name='Start Game', action=function()self.game:switch("level")end}
	self.menus["main"]:addItem{name='Options', action=function()self.current_menu="options"end}
	self.menus["main"]:addItem{name='Quit Game', action=function()love.event.quit()end}
	
	--OPTIONS MENU
	self.menus["options"]:addItem{name='Video', action=function()self.current_menu="video"end}
	self.menus["options"]:addItem{name='Audio', action=function()self.current_menu="audio"end}
	self.menus["options"]:addItem{name='Controls', action=function()self.current_menu="controls"end}
	self.menus["options"]:addItem{name='Back', action=function()self.current_menu="main"end}
	
	--VIDEO MENU
	self.menus["video"]:addItem{name='Back', action=function()self.current_menu="options"end}

	--AUDIO MENU
	self.menus["audio"]:addItem{name='Back', action=function()self.current_menu="options"end}

	--CONTROLS MENU
	self.menus["controls"]:addItem{name='Back', action=function()self.current_menu="options"end}

	--INPUTS
	self.input:addButton("press","z",function()self.game:switch("level")end)
	self.input:addButton("press","up",function()self.menus[self.current_menu]:selectPrevious()end)
	self.input:addButton("press","down",function()self.menus[self.current_menu]:selectNext()end)
	self.input:addButton("press","return",function()self.menus[self.current_menu]:select()end)
end --when state is first created, run only once

function MenuState:leave()end --when state is no longer active
function MenuState:enter(from, ...)end --when state comes back from pause (or is transitioned into)
function MenuState:finish()end --when state is finished
function MenuState:update(dt)
	self.input:update(dt)
end
function MenuState:draw()
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	love.graphics.setColor(255,255,255)
	love.graphics.clear()
	love.graphics.draw(self.title_image,screen_width/2 - self.title_image:getWidth()/2,screen_height/2 - self.title_image:getHeight()/2)
	self.menus[self.current_menu]:draw()
end
function MenuState:focus()end
function MenuState:keypressed(key)
	self.input:keypressed(key)
end
function MenuState:keyreleased(key)
	self.input:keyreleased(key)
end
function MenuState:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function MenuState:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function MenuState:joystickpressed()end
function MenuState:joystickreleased()end
function MenuState:quit()end