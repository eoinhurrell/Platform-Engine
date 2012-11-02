Hud = {}

-- Constructor
function Hud:new(g)
	-- define our parameters here
	local object = {
		game = g,
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
	self:Health()
	self:Score()
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
   love.graphics.print("Score: " .. score, 2, 26)
end

function Hud:Debug()
   love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 26)
   love.graphics.print("Player: (" .. player:getX() .. ",".. player:getY() .. ")", 2, 44)
   love.graphics.print("Velocity: (" .. player:getVelX() .. ",".. player:getVelY() .. ")", 2, 62)
   love.graphics.print("Status: (" .. player:getStatus() .. ")", 2, 74)
end