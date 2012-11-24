GameState = {}

require "lib/Input"
require "lib/Camera"
require "lib/Sprite"
require "game/Hud"
require "game/Player"
require "game/Item"
require "game/Hazard"
require "game/Trigger"
require "game/Level"

-- Constructor
function GameState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "level",
		current_level = 1, 
		level_list = {"test.tmx","test2.tmx"},
		p = Player:new(),
		input = Input:new(),
		hud = nil,
		level = nil,
		--screen resolution
		width = 800,
		height = 600,
		gravity = 1800,
		grap = love.graphics,
		on_return = nil
	}
	setmetatable(object, { __index = GameState })
	return object
end

function GameState:handleItemCollision(item)   --all collision
	local effects = item:getEffects()
	for k,v in pairs(effects) do
		if k == "health" then
			self.game:addHealth(v)
		end
		if k == "damage" then
			self.game:takeDamage(v)
		end
		if k == "score" then
			self.game:addScore(v)
		end
		-- if k == "item" then
		-- self.game:addToInventory(v)
		-- end
	end
end

function GameState:handleHazardCollision(hazard)   --all collision
	local damage = hazard:getDamage()
	self.game:takeDamage(damage)
end

function GameState:handleTriggerCollision(trigger)   --all collision
	local effects = trigger:getEffects()
	for k,v in pairs(effects) do
		print(""..k..":"..v)
		if k == "scene" then 
			--play scene
		end
		if k == "event" then
			--activate event
		end
		if k == "tooltip" then
			--spawn tooltip at trigger location
		end
		if k == "health" then
			self.game:addHealth(v)
		end
		if k == "damage" then
			self.game:takeDamage(v)
		end
		if k == "score" then
			self.game:addScore(v)
		end
		-- if k == "item" then
		-- self.game:addToInventory(v)
		-- end
	end
	if effects["level"] ~= nil then
		self.on_return = function() self:changeLevel(effects["level"]) end
		self.game:switch("summary")
	end
end

function GameState:changeLevel(next_level)
	self.p:setRun(false)
	self.p:stop()
	camera:scale(1,1)
	self.game:resetLevelStats()
	if (next_level < #self.level_list + 1) then
		self.current_level = next_level
		self.level = Level:new(self.level_list[next_level],self,self.p)
	end
	
end

function GameState:init() --when state is first created, run only once
	self.height=love.graphics.getHeight()
	self.width=love.graphics.getWidth()
	--hud setup
	self.hud = Hud:new(self.game,self)
	--player setup
	self.p:load()
	--map setup
	-- Load up the map
	--self:loadLevel()
	self.level = Level:new(self.level_list[self.current_level],self,self.p)
	--camera setup
	camera:scale(1,1)
	-- restrict the camera
	camera:setBounds(0, 0, self.level.map.width * self.level.map.tileWidth - self.width, self.level.map.height * self.level.map.tileHeight - self.height)
	
	--inputs
	--player movement
	self.input:addButton("hold","left",function()self.p:moveLeft()end)
	self.input:addButton("release","left",function()self.p:stop()end)
	self.input:addButton("hold","right",function()self.p:moveRight()end)
	self.input:addButton("release","right",function()self.p:stop()end)
	self.input:addButton("hold","z",function()if camera.scaleX < 1.5 then camera:scale(1.1,1.1) end end)
	self.input:addButton("release","z",function()camera.scaleX = 1 camera.scaleY= 1 end)
	self.input:addButton("hold","lshift",function() self.p:setRun(true) end)			--run
	self.input:addButton("release","lshift",function() self.p:setRun(false) end)		--run
	self.input:addButton("press","x",function()self.p:jump()end)							--jump
	self.input:addButton("press","c",function()self:saveScreen()end)						--screenshot
	self.input:addButton("press","escape",function()self.game:switch("pause")end)		--pause menu
	self.input:addButton("press","`",function()self.game:switch("console")end)			--console
	--temp debug stuff
	--self.input:addButton("press","z",function()self.game.achievements:unlock("001")end)
end
function GameState:leave()
		self.p:stop()
end --when state is no longer active
function GameState:enter(from, ...) --when state comes back from pause (or is transitioned into)
	if self.on_return ~= nil then
		print("Returning")
		self.on_return()
		self.on_return = nil
	end
end
function GameState:finish()  --when state is finished
end
function GameState:update(dt) --update loop
	if not self.game:isAlive() then  --check if game over
		self.game:switch("died")
	end
	self.input:update(dt) --update input events
	--update movements with collison detection
	 local halfX = self.p.width / 2
    local halfY = self.p.height / 2
    
    -- apply gravity
    self.p.ySpeed = self.p.ySpeed + (self.gravity * dt)
    
    -- limit the player's speed
    self.p.xSpeed = math.clamp(self.p.xSpeed, -self.p.xSpeedMax, self.p.xSpeedMax)
    self.p.ySpeed = math.clamp(self.p.ySpeed, -self.p.ySpeedMax, self.p.ySpeedMax)
    
    -- calculate vertical position and adjust if needed
	local nextY = math.floor(self.p.y + (self.p.ySpeed * dt))
	if self.p.ySpeed < 0 then -- check upward
		if not(self.p:isColliding(self.level.map, self.p.x - halfX, nextY - halfY))
			and not(self.p:isColliding(self.level.map, self.p.x + halfX - 1, nextY - halfY)) then
			-- no collision, move normally
			self.p.y = nextY
			self.p.onFloor = false
		else
			-- collision, move to nearest tile border
			self.p.y = nextY + self.level.map.tileHeight - ((nextY - halfY) % self.level.map.tileHeight)
			--here we could check for pipes or other things he could hang from
			self.p:collide("ceiling")
		end
	elseif self.p.ySpeed > 0 then -- check downward
		if not(self.p:isColliding(self.level.map, self.p.x - halfX, nextY + halfY))
			and not(self.p:isColliding(self.level.map, self.p.x + halfX - 1, nextY + halfY)) then
			-- no collision, move normally
			self.p.y = nextY
			self.p.onFloor = false
		else
			-- collision, move to nearest tile border
			self.p.y = nextY - ((nextY + halfY) % self.level.map.tileHeight)
			self.p:collide("floor")
		end
	end
	-- calculate horizontal position and adjust if needed
	local nextX = math.floor(self.p.x + (self.p.xSpeed * dt))
	if self.p.xSpeed > 0 then -- check right
		if not(self.p:isColliding(self.level.map, nextX + halfX, self.p.y - halfY))
			and not(self.p:isColliding(self.level.map, nextX + halfX, self.p.y + halfY - 1)) then
			-- no collision
			self.p.x = nextX
		else
			-- collision, move to nearest tile
			-- here he's collided with a wall, if it is 'hangable' and if he's not on the ground the collide "hang_right"
			self.p.x = nextX - ((nextX + halfX) % self.level.map.tileWidth)
		end
	elseif self.p.xSpeed < 0 then -- check left
		if not(self.p:isColliding(self.level.map, nextX - halfX, self.p.y - halfY))
			and not(self.p:isColliding(self.level.map, nextX - halfX, self.p.y + halfY - 1)) then
			-- no collision
			self.p.x = nextX
		else
			-- collision, move to nearest tile
			-- here he's collided with a wall, if it is 'hangable' and if he's not on the ground the collide "hang_left"
			self.p.x = nextX + self.level.map.tileWidth - ((nextX - halfX) % self.level.map.tileWidth)
		end
	end
	
	-- update item animations and check for player collisions
	for i in ipairs(self.level.items) do
		self.level.items[i]:update(dt)
		-- if player collides, add to score and remove coin
		if self.level.items[i]:touchesObject(self.p) then
			print("Hit:".. self.level.items[i].name)
			self:handleItemCollision(self.level.items[i])
			if self.level.items[i]:isDestructible() then
				table.remove(self.level.items, i)
			end
		end
	end
	-- update hazard animations and check for player collisions
	for i in ipairs(self.level.hazards) do
		self.level.hazards[i]:update(dt)
		-- if player collides, add to score and remove coin
		if self.level.hazards[i]:touchesObject(self.p) then
			print("Hit:".. self.level.hazards[i].name)
			self:handleHazardCollision(self.level.hazards[i])
			if self.level.hazards[i]:isDestructible() then
				table.remove(self.level.hazards, i)
			end
		end
	end
	-- update trigger animations and check for player collisions
	for i in ipairs(self.level.triggers) do
		self.level.triggers[i]:update(dt)
		-- if player collides, add to score and remove coin
		if self.level.triggers[i]:touchesObject(self.p) then
			print("Hit:".. self.level.triggers[i].name)
			self:handleTriggerCollision(self.level.triggers[i])
			if self.level.triggers[i]:isDestructible() then
				table.remove(self.level.triggers, i)
			end
		end
	end
	
	self.p:update(dt) --update the player's position (only collision handled by player, to make sure they can move ok)
	self.level:update(dt) --update level
	camera:focusOn(math.floor(self.p.x), math.floor(self.p.y)) --center the camera on the player
	self:updateStats(dt) --update game statistics
	self.game.achievements:update(dt) --update achievement details
end
function GameState:draw()
	--go into relative camera mode
	camera:set()
	-- draw the map, limiting it to preserve resources
	self.level:draw()	
	-- draw the player
	self.p:draw()
	--leave relative camera mode
	camera:unset()
	self.hud:draw()
	self.game.achievements:draw()
end
function GameState:focus()
	self.game:switch("pause")
end
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
function GameState:quit()
end

function GameState:updateStats(dt)
	self.game.statistics["level_time"] = self.game.statistics["level_time"] + dt
	local key = "level_"
	key = key..self.p.state
	key = string.gsub(key, "Left", "")
	key = string.gsub(key, "Right", "")
	if self.game.statistics[key] ~= nil then
		self.game.statistics[key] = self.game.statistics[key] + dt
	end
	self.game.statistics["game_time"] = self.game.statistics["game_time"] + dt
	local key = "game_"
	key = key..self.p.state
	key = string.gsub(key, "Left", "")
	key = string.gsub(key, "Right", "")
	if self.game.statistics[key] ~= nil then
		self.game.statistics[key] = self.game.statistics[key] + dt
	end
end

function GameState:saveScreen()
	local s = love.graphics.newScreenshot() --ImageData
	s:encode("pic.png")
	error( "Screenshot: " .. love.filesystem.getSaveDirectory())
end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function GameState:checkCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end