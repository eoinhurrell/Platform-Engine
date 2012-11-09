Bomb = {}

-- Constructor
function Bomb:new(loc_x,loc_y)
	local object = {
		anim = Sprite:new("assets/bomb.png", 32, 32, 4, 1),
		x = loc_x,
		y = loc_y,
		width = 32,
		height = 32,
		frame = math.random(1,4),
		delay = 200,
		delta = 0,
		maxDelta = 40
	}
	object.anim:load(object.delay)
	setmetatable(object, { __index = Bomb })
	return object
end

function Bomb:update(dt)
	self.delta = self.delta + self.delay *dt
	
	--loop
	if self.delta >= self.maxDelta then
		self.frame = self.frame % 4 + 1
		self.delta = 0
	end
end

function Bomb:draw()
	self.anim:start(self.frame)
	self.anim:draw(self.x - self.width / 2, self.y - self.height / 2)
end

-- returns true if the tile given is empty
function Bomb:isColliding(map)
	--tile tile coords
	local tile_x = math.floor(self.x / map.tileWidth)
	local tile_y = math.floor(self.y / map.tileHeight)
	
	local layer = map.layers["Walls"]
	-- grab the tile at given point
	local tile = layer:get(tileX, tileY)
	-- return true if the point overlaps a solid tile
	return not(tile == nil)
end

-- returns true if the object intersects this Bomb
function Bomb:touchesObject(object)
	local cx1 = self.x - self.width / 2
	local cx2 = self.x + self.width / 2 - 1
	local cy1 = self.y - self.height / 2
	local cy2 = self.y + self.height / 2 - 1
	local px1 = object.x - object.width / 2 
	local px2 = object.x + object.width / 2 - 1
	local py1 = object.y - object.height / 2 
	local py2 = object.y + object.height / 2 - 1
	return ((cx2 >= px1) and (cx1 <= px2) and (cy2 >= py1) and (cy1 <= py2))
end