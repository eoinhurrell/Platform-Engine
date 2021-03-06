Item = {}

-- Constructor
function Item:new(item_name,loc_x,loc_y,destruct,anim_frames)
	local object = {
		name = item_name,
		num_frames = anim_frames or 1,
		anim = Sprite:new("assets/items/"..item_name..".png", 32, 32, 1, 4),
		x = loc_x,
		y = loc_y,
		width = 32,
		height = 32,
		effects = {
			["health"] = 0,
			["damage"] = 0,
			["score"]  = 0,
			["items"]  = ""
		},
		is_visible = true,
		is_destructible = destruct or true,
		
		frame = math.random(1,2),
		delay = 200,
	}
	object.anim:load(object.delay)
	object.anim:start(object.frame)
	setmetatable(object, { __index = Item })
	return object
end

function Item:setEffect(effect_name,effect_value)
	if self.effects[effect_name] ~= nil then
		self.effects[effect_name] = effect_value
	end
end

function Item:getHealth()
	return self.effects["health"]
end
function Item:getDamage()
	return self.effects["damage"]
end
function Item:getScore()
	return self.effects["score"]
end

function Item:getEffect(effect_name)
	return self.effects[effect_name]
end

function Item:getEffects()
	return self.effects
end

function Item:update(dt)
	self.anim:update(dt)
end

function Item:draw()
	self.anim:draw(self.x - self.width / 2, self.y - self.height / 2)
end

function Item:isDestructible()
	return self.is_destructible
end

-- returns true if the tile given is empty
function Item:isColliding(map)
	--tile tile coords
	local tile_x = math.floor(self.x / map.tileWidth)
	local tile_y = math.floor(self.y / map.tileHeight)
	
	local layer = map.layers["Walls"]
	-- grab the tile at given point
	local tile = layer:get(tileX, tileY)
	-- return true if the point overlaps a solid tile
	return not(tile == nil)
end

-- returns true if the object intersects this Item
function Item:touchesObject(object)
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