Player = {}

-- Constructor
function Player:new()
	local object = {
		anim = nil,
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		xSpeed = 0,
		ySpeed = 0,
		xSpeedMax = 800,
		ySpeedMax = 800,
		state = "",
		state_anims = nil,
		jumpSpeed = 0,
		moveSpeed = 0,
		isRunning = false,
		hasJumped = false,
		onFloor = false,
	}
	object.state_anims = {
		["stand"]     = function() object.anim:switch(1, 4, 200) end,
		["moveRight"] = function() object.anim:switch(2, 4, 120) end,
		["moveLeft"]  = function() object.anim:switch(2, 4, 120) end,
		["jump"]      = function() object.anim:reset() object.anim:switch(3, 1, 300) end,
		["fall"]      = function() object.anim:reset() object.anim:switch(3, 2, 800) end, --need something here to count fall damage
		["hang"]      = function() object.anim:switch(4, 2, 200) end,
		[""]          = function() object.anim:switch(4, 2, 200) end
	}
	setmetatable(object, { __index = Player })
	return object
end

function Player:load()
	self.x = 300
	self.y = 0
	self.width = 36
	self.height = 64
	self.jumpSpeed = -800
	self.moveSpeed = 500
	self.hasJumped = false
	delay = 120
	self.anim = Sprite:new("assets/player-sprite.png", 36, 64, 4, 8)
	self.anim:load(delay)
end

function Player:restart()
	self.x = 300
	self.y = 0	
end

-- Movement functions
function Player:jump()
    if self.onFloor then
        self.ySpeed = self.jumpSpeed
        self.onFloor = false
    end
end

function Player:setRun(isRun)
	self.isRunning = isRun
	if self.isRunning then
		self.jumpSpeed = -1000
		self.moveSpeed = 800
	else
		self.jumpSpeed = -800
		self.moveSpeed = 500
	end
end

function Player:moveRight()
    self.xSpeed = self.moveSpeed
end

function Player:moveLeft()
    self.xSpeed = -1 * (self.moveSpeed)
end

function Player:stop()
	self.xSpeed = 0
end

-- Do various things when the player hits a tile
function Player:collide(event)
    if event == "floor" then
        self.ySpeed = 0
        self.onFloor = true
    end
    if event == "ceiling" then
        self.ySpeed = 0
    end
end

-- Update function
function Player:update(dt)
	-- update the player's state
	self.state = self:getState()
	-- update the sprite self.anim
	self.state_anims[self.state]()
	if self.xSpeed < 0  then
		self.anim:flip(true,false)
	elseif self.xSpeed > 0  then
		self.anim:flip(false,false)
	end
	self.anim:update(dt)
end

function Player:draw()
	local x, y = math.floor(self.x), math.floor(self.y)	
	self.anim:draw(x - self.width / 2, y - self.height / 2)
end

-- returns true if the coordinates given intersect a map tile
function Player:isColliding(map, x, y)
    -- get tile coordinates
    local layer = map.layers["Walls"]
    local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
    
    -- grab the tile at given point
    local tile = layer:get(tileX, tileY)
    
    -- return true if the point overlaps a solid tile
    return not(tile == nil)
end

-- returns player's state as a string
function Player:getState()
    local myState = ""
    if self.onFloor then
        if self.xSpeed > 0 then
            myState = "moveRight"
        elseif self.xSpeed < 0 then
            myState = "moveLeft"
        else
            myState = "stand"
        end
    end
    if self.ySpeed < 0 then
        myState = "jump"
    elseif self.ySpeed > 0 and not self.onFloor then
        myState = "fall"
    end
    return myState
end