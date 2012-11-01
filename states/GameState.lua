 GameState = {}

require "lib/Input"
require "game/Player"
-- Constructor
function GameState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "level",
		p = Player:new(),
		input = Input:new(),

		--temp level width variable
		width = 400,
		gravity = 1800,
		yFloor = 500,	
		playerColor = {255,0,128},
		groundColor = {25,200,25},
		grap = love.graphics
	}
	setmetatable(object, { __index = GameState })
	return object
end
function GameState:init() --when state is first created, run only once
	self.p:load()
	self.input:addButton("hold","left",function()self.p:moveLeft()end)
	self.input:addButton("release","left",function()self.p:stop()end)
	self.input:addButton("hold","right",function()self.p:moveRight()end)
	self.input:addButton("release","right",function()self.p:stop()end)
	self.input:addButton("press","x",function()self.p:jump()end)
	self.input:addButton("press","p",function()self.game:switch("pause")end)
	self.input:addButton("press","`",function()self.game:switch("console")end)
	--self.input:addButton("press","escape",love.event.quit())
end 
function GameState:leave()end --when state is no longer active
function GameState:enter(from, ...) --when state comes back from pause (or is transitioned into)
	self.p:stop()
end
function GameState:finish()end --when state is finished
function GameState:update(dt)
	-- update the player's position
	self.p:update(dt, self.gravity)
	-- stop the player when they hit the borders
	self.p.x = math.clamp(self.p.x, 0, self.width * 2 - self.p.width)
	if self.p.y < 0 then self.p.y = 0 end
	if self.p.y > self.yFloor - self.p.height then
		self.p:land(self.yFloor)
	end
   -- stop the player when they hit the borders
   -- if self.p.x > 800 - self.p.width then self.p.x = 800 - self.p.width end
   -- if self.p.x < 0 then self.p.x = 0 end
   -- if self.p.y < 0 then self.p.y = 0 end
   -- if self.p.y > self.yFloor - self.p.height then
   --     self.p:land(self.yFloor)
   -- end

	self.input:update(dt)
end
function GameState:draw()
	-- draw the player shape
	-- self.grap.setColor(self.playerColor)
	-- self.grap.rectangle("fill", self.p.x, self.p.y, self.p.width, self.p.height)
	self.p:draw()

	-- draw the ground
	self.grap.setColor(self.groundColor)
	self.grap.rectangle("fill", 0, self.yFloor, 800, 100)
	if game:isDebug() then
		local height=love.graphics.getHeight()
		self.grap.setColor({0,0,0})
		love.graphics.print("Player coordinates: ("..self.p.x..","..self.p.y..")", 5, height-26)
		love.graphics.print("Current state: "..self.p.state, 5, height-16)
	end
end
function GameState:focus()end
function GameState:keypressed(key)
	self.input:keypressed(key)
end
function GameState:keyreleased(key)
	self.input:keyreleased(key)
end
function GameState:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function GameState:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function GameState:joystickpressed()
end
function GameState:joystickreleased()
end
function GameState:quit()end

function GameState:loadLevel()
	if self.game.debug then
		--print "Loading level :" .. self.game.level 
		--print "	level file  :" .. self.game.level_files[self.game.level]
	end
end

--clamp function: http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end

