 GameState = {}

l = require "AdvTiledLoader/Loader"
require "lib/Input"
require "lib/Camera"
require "lib/Sprite"
require "game/Hud"
require "game/Player"
require "game/Coin"

-- Constructor
function GameState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "level",
		p = Player:new(),
		input = Input:new(),
		coins = {},
		hud = nil,
		loader = l,
		map = nil,
		--screen resolution
		width = 800,
		height = 600,
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
	self.hud = Hud:new(self.game,self)
	--player setup
	self.p:load()
	
	--level setup
	-- Place random coins around the map
	math.randomseed(os.time())
	numCoins = 25
	for i = 1, numCoins do
		local coinCollides = true
		while coinCollides do -- try to place a coin on a random spot around the map
			local coinX = math.random(1, self.map.width - 1) * self.map.tileWidth + self.map.tileWidth / 2
			local coinY = math.random(1, self.map.height - 1) * self.map.tileHeight + self.map.tileHeight / 2
			self.coins[i] = Coin:new(coinX, coinY)
			-- if tile is occupied, try again
			coinCollides = self.coins[i]:isColliding(self.map)
		end
	end
	
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
	-- update level
	-- update coin animations and check for player collisions
	for i in ipairs(self.coins) do
		self.coins[i]:update(dt)
		-- if player collides, add to score and remove coin
		if self.coins[i]:touchesObject(self.p) then
			self.game:addScore(100)
			table.remove(self.coins, i)
		end
	end
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
	self.p:draw()
	--draw level details
	for i in ipairs(self.coins) do
		self.coins[i]:draw()
	end
	--leave relative camera mode
	camera:unset()
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

