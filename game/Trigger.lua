Trigger = {}

-- Constructor
function Trigger:new(hazard_name,loc_x,loc_y,w,h,visible,destruct,anim_frames)
	local object = {
		name = hazard_name,
		num_frames = anim_frames or 1,
		anim = nil,
		x = loc_x,
		y = loc_y,
		width = w,
		height = h,
		effects = {
			["level"]  = nil,
			["scene"]  = nil,
			["event"]  = nil,
			["tooltip"]= nil, 
			["health"] = 0,
			["damage"] = 0,
			["score"]  = 0,
			["items"]  = ""
		},
		is_visible = visible or false,
		is_destructible = destruct or false,
		
		frame = math.random(1,2),
		delay = 200,
	}
	if object.is_visible then 
		object.anim = Sprite:new("assets/hazards/"..object.hazard_name..".png", 32, 32, 1, 4)
		object.anim:load(object.delay)
		object.anim:start(object.frame)
	end
	setmetatable(object, { __index = Trigger })
	return object
end

function Trigger:setEffect(effect_name,effect_value)
	self.effects[effect_name] = effect_value
end

function Trigger:getHealth()
	return self.effects["health"]
end
function Trigger:getDamage()
	return self.effects["damage"]
end
function Trigger:getScore()
	return self.effects["score"]
end

function Trigger:getEffect(effect_name)
	return self.effects[effect_name]
end

function Trigger:getEffects()
	return self.effects
end

function Trigger:update(dt)
	if self.anim ~= nil then
		self.anim:update(dt)
	end
end

function Trigger:draw()
	if self.anim ~= nil and self.is_visible then	
		self.anim:draw(self.x - self.width / 2, self.y - self.height / 2)
	end
end

function Trigger:isDestructible()
	return self.is_destructible
end

-- returns true if the tile given is empty
function Trigger:isColliding(map)
	--tile tile coords
	local tile_x = math.floor(self.x / map.tileWidth)
	local tile_y = math.floor(self.y / map.tileHeight)
	
	local layer = map.layers["Walls"]
	-- grab the tile at given point
	local tile = layer:get(tileX, tileY)
	-- return true if the point overlaps a solid tile
	return not(tile == nil)
end

-- returns true if the object intersects this Trigger
function Trigger:touchesObject(object)
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