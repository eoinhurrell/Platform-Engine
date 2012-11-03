 GameState = {}

l = require "AdvTiledLoader/Loader"
require "lib/Input"
require "lib/Camera"
require "lib/Sprite"
require "game/Player"
require "game/Hud"

-- Constructor
function GameState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "level",
		p = Player:new(),
		input = Input:new(),
		anim = nil,
		hud = nil,
		loader = l,
		map = nil,
		--temp level width variable
		width = 400,
		height = 800,
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
	self.height=love.graphics.getHeight()
	self.width=love.graphics.getWidth()
	--map setup
	-- Load up the map
	self.loader.path = "maps/"
	self.map = self.loader.load("test.tmx")
	self.map:setDrawRange(0, 0, self.map.width * self.map.tileWidth, self.map.height * self.map.tileHeight)
	--hud setup
	self.hud = Hud:new(self.game)
	--player setup
	--self.p:load()
	self.p.x = 300
   self.p.y = 300
   self.p.width = 32
   self.p.height = 32
   self.p.jumpSpeed = -800
   self.p.runSpeed = 500
   self.p.hasJumped = false
   delay = 120
	self.anim = Sprite:new("assets/robosprites.png", 32, 32, 4, 4)
   self.anim:load(delay)

   
   gravity = 1800
	
	--camera setup
	-- restrict the camera
	camera:setBounds(0, 0, self.map.width * self.map.tileWidth - self.width, self.map.height * self.map.tileHeight - self.height)
	--inputs
	--player movement
	self.input:addButton("hold","left",function()self.p:moveLeft()end)
	self.input:addButton("release","left",function()self.p:stop()end)
	self.input:addButton("hold","right",function()self.p:moveRight()end)
	self.input:addButton("release","right",function()self.p:stop()end)
	self.input:addButton("press","x",function()self.p:jump()end)
	--pause menu
	self.input:addButton("press","escape",function()self.game:switch("pause")end)
	--console
	self.input:addButton("press","`",function()self.game:switch("console")end)
	--temp debug stuff
	self.input:addButton("press","z",function()self.game.achievements:unlock("001")end)
end 
function GameState:leave()
		self.p:stop()
end --when state is no longer active
function GameState:enter(from, ...) --when state comes back from pause (or is transitioned into)
end
function GameState:finish()end --when state is finished
function GameState:update(dt)
	self.input:update(dt)	
	-- update the player's position
	self.p:update(dt, self.gravity,self.map)
	-- update the sprite self.anim
	if (self.p.state == "stand") then
		self.anim:switch(1, 4, 200)
	end
	if (self.p.state == "moveRight") or (self.p.state == "moveLeft") then
		self.anim:switch(2, 4, 120)
	end
	if (self.p.state == "jump") or (self.p.state == "fall") then
		self.anim:reset()
		self.anim:switch(3, 1, 300)
	end

	self.anim:update(dt)
	
	-- stop the player when they hit the borders
	-- self.p.x = math.clamp(self.p.x, 0, self.width * 2 - self.p.width)
	-- if self.p.y < 0 then self.p.y = 0 end
	-- if self.p.y > self.yFloor - self.p.height then
	-- 	self.p:land(self.yFloor)
	-- end
	-- center the camera on the player
	camera:setPosition(math.floor(self.p.x - self.width / 2), math.floor(self.p.y - self.height / 2))
	self.game.achievements:update(dt)	
end
function GameState:draw()
	--go into relative camera mode
	camera:set()
	-- draw the map
	self.map:draw()
	-- draw the player
	--self.p:draw()
   local x, y = math.floor(self.p.x), math.floor(self.p.y)	
	self.anim:draw(x - self.p.width / 2, y - self.p.height / 2)
	--leave relative camera mode
	camera:unset()
	if game:isDebug() then
		local tileX = math.floor(self.p.x / self.map.tileWidth)
		local tileY = math.floor(self.p.y / self.map.tileHeight)
		local height=love.graphics.getHeight()
		self.grap.setColor({0,0,255})
		love.graphics.print("Player coordinates: ("..self.p.x..","..self.p.y..")", 5, height-36)
		love.graphics.print("Current state: "..self.p.state, 5, height-26)
		love.graphics.print("Current tile: ("..tileX..", "..tileY..")", 5, height-16)
		self.grap.setColor({0,0,0})		
	end
	self.hud:draw()
	self.game.achievements:draw()
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

