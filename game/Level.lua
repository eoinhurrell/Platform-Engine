Level = {}

l = require "AdvTiledLoader/Loader"

-- Constructor
function Level:new()
	local object = {
		name = Level_name,
		player = nil,
		state = nil,
		map = nil,
		loader = l,
		items = {}
	}
	object.anim:load(object.delay)
	setmetatable(object, { __index = Level })
	return object
end

function Level:load()
	self.loader.path = "maps/"
	self.map = self.loader.load("test.tmx")
	self.map:setDrawRange(0, 0, self.map.width * self.map.tileWidth, self.map.height * self.map.tileHeight)
	--To change the parallax speed you only need to set the values TileLayer.parallaxX and TileLayer.parallaxY. 1 equals 100% speed so if parallaxX was set to 2 then horizontal scrolling speed would be doubled.
	--self.map.layers["Background"].parallaxX = 2
	self.map.drawObjects = false
	--level setup
	-- Place random coins around the map
	math.randomseed(os.time())
	numCoins = 25
	for i = 1, numCoins do
		local coinCollides = true
		while coinCollides do -- try to place a coin on a random spot around the map
			local coinX = math.random(1, self.map.width - 1) * self.map.tileWidth + self.map.tileWidth / 2
			local coinY = math.random(1, self.map.height - 1) * self.map.tileHeight + self.map.tileHeight / 2
			self.items[i] = Item:new("coin",coinX, coinY)
			-- if tile is occupied, try again
			coinCollides = self.items[i]:isColliding(self.map)
		end
	end
	-- Iterating over all objects in a layer
	for i, obj in pairs(self.map("Objects").objects ) do
	    print( "Hi, my name is " .. obj.name )
	end
end

function Level:reset() --for death
end

function Level:restart() --for full restart
end

function Level:update(dt)
	-- update coin animations and check for player collisions
	for i in ipairs(self.items) do
		self.items[i]:update(dt)
		-- if player collides, add to score and remove coin
		if self.items[i]:touchesObject(self.p) then
			self.game:addScore(100)
			table.remove(self.items, i)
		end
	end	
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
end