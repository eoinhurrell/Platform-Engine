Hud = {}

-- Constructor
function Hud:new(g,l)
	-- define our parameters here
	local object = {
		game = g,
		state = l
	}
	setmetatable(object, { __index = Hud })
	return object
end

function Hud:load()
end

-- Update function
function Hud:update(dt, gravity)
end

function Hud:draw()
	self:Background()
	self:Health()
	self:Score()
	if self.game:isDebug() then
		self:Debug()
	end
end

function Hud:Background()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	love.graphics.setColor(205,205,205)
	love.graphics.rectangle('fill', 0,0,width,45)
	love.graphics.setColor(255,255,255)
end

function Hud:Health()
	local health = self.game:getHealth()
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle('fill', 2,2,104,24)
   love.graphics.setColor(255,0,0)
   love.graphics.rectangle('fill', 4,4,health,20)
   love.graphics.setColor(255,255,255)
end

function Hud:Score()
	local score = self.game:getScore()
	love.graphics.setColor({0,0,0})	
   love.graphics.print("Score: " .. score, 2, 26)
	love.graphics.setColor({255,255,255})
end

function Hud:Debug()
	local tileX = math.floor(self.state.p.x / self.state.level.map.tileWidth)
	local tileY = math.floor(self.state.p.y / self.state.level.map.tileHeight)
	local height=love.graphics.getHeight()
	debug_info ={
		"FPS: " .. love.timer.getFPS(),
		--"Player coordinates: ("..self.state.p.x..","..self.state.p.y..")",
		"Current state: "..self.state.p.state,
		"Level " .. self.state.current_level .. ", ("..tileX..", "..tileY..") time:" .. self.game.statistics["level_time"],
		"Game  " .. self.game.statistics["game_time"]
	}
	--colour for messages
	love.graphics.setColor({0,0,255})
	for i,v in ipairs(debug_info) do 
		love.graphics.print(debug_info[i], 2, height-(i*10 + 7))
		-- print(i,v) 
	end
	love.graphics.setColor({255,255,255})
	
   
   --love.graphics.print("Player: (" .. player:getX() .. ",".. player:getY() .. ")", 2, 44)
   --love.graphics.print("Velocity: (" .. player:getVelX() .. ",".. player:getVelY() .. ")", 2, 62)
   --love.graphics.print("Status: (" .. player:getStatus() .. ")", 2, 74)
end