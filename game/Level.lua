Level = {}

l = require "AdvTiledLoader/Loader"

-- Constructor
function Level:new(Level_name,s,player)
	local object = {
		name     = Level_name,
		state    = s,
		map      = nil,
		loader   = l,
		tiles    = {},
		items    = {},
		hazards  = {},
		triggers = {}
	}
	object.loader.path = "maps/"
	object.map = object.loader.load(object.name)
	--object.map:setDrawRange(0, 0, object.map.width * object.map.tileWidth, object.map.height * object.map.tileHeight)
	object.map:setDrawRange(0, 0, 200,200)--object.map.width * object.map.tileWidth, object.map.height * object.map.tileHeight)
	--To change the parallax speed you only need to set the values TileLayer.parallaxX and TileLayer.parallaxY. 1 equals 100% speed so if parallaxX was set to 2 then horizontal scrolling speed would be doubled.
	--object.map.layers["Background"].parallaxX = 2
	object.map.drawObjects = false
	--level setup
	--set collidible tiles
	local layer = object.map.layers["Walls"]   
	for tileX=1,object.map.width do
		for tileY=1,object.map.height do
			local tile = layer:get(tileX, tileY)
			if tile ~= nil then
				local ctile = {}
				ctile.x = (tileX)*object.map.tileWidth
				ctile.y = (tileY)*object.map.tileHeight
				ctile.w = object.map.tileWidth
				ctile.h = object.map.tileHeight
				table.insert(object.tiles, ctile)
			end
		end
	end
	-- Iterating over all objects in a layer
	for i, obj in pairs(object.map("Objects").objects ) do
		if obj.type == "item" then
			if obj.name == "coin" or obj.name == "bomb" then
				local item = Item:new(obj.name,obj.x+(obj.width/2),obj.y+(obj.height/2))
				for k,v in pairs(obj.properties) do 
					item:setEffect(k,v)
				end
				table.insert(object.items, item)
			end
		end
		if obj.type == "hazard" then
			local haz = Hazard:new(obj.name,obj.x+(obj.width/2),obj.y+(obj.height/2),obj.width,obj.height)
			haz:setDamage(obj.properties["damage"])
			table.insert(object.hazards, haz)
		end
		if obj.type == "trigger" then
			if obj.name == "level_start" then
				player.x = obj.x
				player.y = obj.y
			end
			if obj.name == "level_finish" then
				--place end of level thing here
				local trig = Trigger:new(obj.name,obj.x+(obj.width/2),obj.y+(obj.height/2),obj.width,obj.height)
				print("Current level:"..object.state.current_level)
				trig:setEffect("level",(object.state.current_level+1))
				print("Next level:"..object.state.current_level+1)
				if obj.properties["level"] ~= nil then
					trig:setEffect("level",obj.properties["level"])
				end
				table.insert(object.triggers, trig)
			end
		end
		-- if obj.name == "coin" or obj.name == "bomb" then
		-- 	local item = Item:new(obj.name,obj.x,obj.y)
		-- 	for k,v in pairs(obj.properties) do 
		-- 		item:setEffect(k,v)
		-- 	end
		-- 	table.insert(object.items, item)
		-- end
	end
	print("Level Loaded:" .. object.name)
	print("Items:" .. #object.items)
	print("Hazards:" .. #object.hazards)
	print("Triggers:" .. #object.triggers)
	setmetatable(object, { __index = Level })
	return object
end

function Level:restart() --for full restart
	self:placeItems()
end

function Level:update(dt)
end

function Level:getTile(x,y)
	-- get tile coordinates
   local layer = self.map.layers["Walls"]
   local tileX, tileY = math.floor(x / self.map.tileWidth), math.floor(y / self.map.tileHeight)
   
   -- grab the tile at given point
   local tile = layer:get(tileX, tileY)
   return tile
end

function Level:draw()
	local draw_x = camera.x-256
	local draw_y = camera.y-256
	local draw_w = (love.graphics.getWidth()*camera.scaleX)+256
	local draw_h = (love.graphics.getHeight()*camera.scaleY)+256
	self.map:setDrawRange(draw_x,draw_y,draw_w,draw_h)
	self.map:draw()
	for i in ipairs(self.items) do
		self.items[i]:draw()
	end
	for i in ipairs(self.hazards) do
		self.hazards[i]:draw()
	end
	for i in ipairs(self.triggers) do
		self.triggers[i]:draw()
	end
end