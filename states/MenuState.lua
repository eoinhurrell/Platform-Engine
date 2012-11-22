MenuState = {}

require 'lib/Menu'

-- Constructor
function MenuState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		input = Input:new(),
		menu = Menu:new(100,100),
		name = "menus",
		title_image = nil,
	}
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	self.title_image = love.graphics.newImage("assets/RebelGorilla.png")
	--self.input:addButton("press","d",function()error('hit, d')end)
	self.menu:addItem{name='Start Game', action=function()self.game:switch("level")end}
	self.menu:addItem{name='Options LOLOLOLOLOLOL', action=function()error('No Options :( ')end}
	self.menu:addItem{name='Quit Game', action=function()self.game:switch("level")end}
	self.input:addButton("press","z",function()self.game:switch("level")end)
	self.input:addButton("press","up",function()self.menu:selectPrevious()end)
	self.input:addButton("press","down",function()self.menu:selectNext()end)
	self.input:addButton("press","return",function()self.menu:select()end)
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
	self.menu:draw()
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