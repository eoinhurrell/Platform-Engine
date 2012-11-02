Player = {}

require "lib/Sprite"

-- Constructor
function Player:new()
	-- define our parameters here
	local object = {
		anim = nil,
		x = 100,
		y = 0,
		width = 0,
		height = 0,
		xSpeed = 0,
		ySpeed = 0,
		xSpeedMax = 800,
		ySpeedMax = 800,		
		state = "",
		jumpSpeed = 0,
		runSpeed = 0,
		canJump = false,
		onFloor = false,
		c_x = 0,
		c_y = 0,
		c_w = 0,
		c_h = 0
	}
	setmetatable(object, { __index = Player })
	return object
end

function Player:load()
	self.x = 300
	self.y = 300
	self.width = 32
	self.height = 32
	self.jumpSpeed = -800
	self.runSpeed = 500
	self.anim = Sprite:new("assets/robosprites.png", 32, 32, 4, 4)
	self.anim:load(200)
end

-- Movement functions
function Player:jump()
    if self.canJump then
        self.ySpeed = self.jumpSpeed
        self.canJump = false
    end
end
 
function Player:moveRight()
	self.xSpeed = self.runSpeed
	self.anim:flip(false, false)
end
 
function Player:moveLeft()
	self.xSpeed = -1 * (self.runSpeed)
	self.anim:flip(true, false)
end
 
function Player:stop()
	self.xSpeed = 0
end


-- Do various things when the player hits a tile
function Player:collide(event)
	if event == "floor" then
		self.ySpeed = 0
		self.onFloor = true
		self.canJump = true
	end
	if event == "ceiling" then
		self.ySpeed = 0
	end
end 
function Player:land(maxY)
	self.y = maxY - self.height
	self.ySpeed = 0
	--self.xSpeed = 0 --added to stop a stat transition bug
	self.canJump = true
end
 
-- Update function
function Player:update(dt, gravity,map)
	local halfX = self.width / 2
	local halfY = self.height / 2	
	-- apply gravity
	self.ySpeed = self.ySpeed + (gravity * dt)
	
	-- limit the player's speed
	self.xSpeed = math.clamp(self.xSpeed, -self.xSpeedMax, self.xSpeedMax)
	self.ySpeed = math.clamp(self.ySpeed, -self.ySpeedMax, self.ySpeedMax)
	
	-- update the player's position
	-- calculate vertical position and adjust if needed
	local nextY = math.floor(self.y + (self.ySpeed * dt))
	self.c_y = nextY+halfY
	if self.ySpeed < 0 then -- check upward
		if not(self:isColliding(map, self.x - halfX, nextY - halfY))
		and not(self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
			-- no collision, move normally
			self.y = nextY
			self.onFloor = false
		else
			-- collision, move to nearest tile border
			self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
			self:collide("ceiling")
		end
	elseif self.ySpeed > 0 then -- check downward
		if not(self:isColliding(map, self.x - halfX, nextY + halfY))
		and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
			-- no collision, move normally
			self.y = nextY
			self.onFloor = false
		else
			-- collision, move to nearest tile border
			self.y = nextY - ((nextY + halfY) % map.tileHeight)
			self:collide("floor")
		end
	end
	-- calculate horizontal position and adjust if needed
	local nextX = math.floor(self.x + (self.xSpeed * dt))
	self.c_x = self.x
	if self.xSpeed > 0 then -- check right
		if not(self:isColliding(map, nextX + halfX, self.y - halfY))
		and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1)) then
			-- no collision
			self.x = nextX
		else
			-- collision, move to nearest tile
			self.x = nextX - ((nextX + halfX) % map.tileWidth)
		end
	elseif self.xSpeed < 0 then -- check left
		if not(self:isColliding(map, nextX - halfX, self.y + halfY - 1))
		and not(self:isColliding(map, nextX - halfX, self.y - halfY)) then
			-- no collision
			self.x = nextX
		else
			-- collision, move to nearest tile
			self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
		end
	end

	--update state
	self:updateState()
	--update animation 
	self.anim:update(dt)
end

function Player:draw()
	local x, y = math.floor(self.x), math.floor(self.y)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill",self.c_x,self.c_y,self.width,self.height)
	self.anim:draw(x, y)
end

function Player:getState()
	return self.state
end

function Player:updateState()
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
	elseif self.ySpeed > 0 then
		myState = "fall"
	end
	self.state = myState
end

-- returns true if the coordinates given intersect a map tile
function Player:isColliding(map, x, y)
	-- get tile coordinates
	local layer = map.layers["Walls"]
	local tileX, tileY = math.floor(x/map.tileWidth), math.floor(y / map.tileHeight)

	-- grab the tile at given point
	local tile = layer:get(tileX, tileY)

	-- return true if the point overlaps a solid tile
	return not(tile == nil)
end

--clamp function: http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end