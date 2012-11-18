MenuState = {}

-- Constructor
function MenuState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		input = Input:new(),
		name = "menus",
		title_image = nil,
	}
	--object.game:getInput():register("menus","z","released",function()object.game:changeState("level")end)
	--object.game:getInput():register("menus","x","down",function()object.game:changeState("level")end)
	setmetatable(object, { __index = MenuState })
	return object
end

function MenuState:init()
	self.title_image = love.graphics.newImage("assets/RebelGorilla.png")
	--self.input:addButton("press","d",function()error('hit, d')end)
	self.input:addButton("press","z",function()self.game:switch("level")end)
	--self.input:addButton("press","any",function()self.game:switch("level")end)
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
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", 0, screen_height - screen_height/4, screen_width, screen_height/8)
	love.graphics.setColor(0,0,0)
	love.graphics.print("New Game", 40, screen_height - screen_height/4 + 30)
	love.graphics.print("Rebel Gorilla", screen_width-165,screen_height - screen_height/3.2 + 10,0,2,2)
	love.graphics.setColor(255,255,255)
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