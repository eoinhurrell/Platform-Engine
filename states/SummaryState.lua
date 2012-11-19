SummaryState = {}

-- Constructor
function SummaryState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "pause",
		input = Input:new(),
		from = nil,
		highlighted = 1,
		action_text={"Quit to Desktop"},
		action = {function() love.event.quit() end}
	}
	setmetatable(object, { __index = SummaryState })
	return object
end

function SummaryState:init()
	love.graphics.setNewFont("assets/DroidSans.ttf", 12)
	self.input = Input:new()
	self.input:addButton("press","space",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","escape",function()self.game:switch(self.from.name)end)
	self.input:addButton("press","return",function()self.game:switch(self.from.name)end)
	--self.input:addButton("press","`",function()self.game:switch("console")end)	
end --when state is first created, run only once
function SummaryState:leave()end --when state is no longer active
function SummaryState:enter(from, ...) --when state comes back from pause (or is transitioned into)
	self.from = from
end
function SummaryState:finish()end --when state is finished
function SummaryState:update(dt)
	self.input:update(dt)
end
function SummaryState:draw()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width,height,300,300)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Level Summary", width/2-100,height/2-240,0,2,2)
	-- local i = 1
	-- for k,v in pairs(self.game.statistics) do
	-- 	local name = "" .. k .. string.rep(' ', 20-#k)
	-- 	love.graphics.print(name..v, width/2-100,height/2-140 +(22*i),0,1,1)
	-- 	i = i + 1
	-- end
	love.graphics.print("Score",width/2-100,height/2-165,0,1,1)
	love.graphics.print(""..self.game.statistics["level_score"],width/2-300,height/2-165,0,1,1)
	love.graphics.print("Time",width/2-100,height/2-190,0,1,1)
	love.graphics.print(""..self.game.statistics["level_time"],width/2-300,height/2-190,0,1,1)
	love.graphics.print("Time Idle",width/2-100,height/2-215,0,1,1)
	love.graphics.print(""..self.game.statistics["level_idle"],width/2-300,height/2-215,0,1,1)
	love.graphics.print("Time Walking",width/2-100,height/2-240,0,1,1)
	love.graphics.print(""..self.game.statistics["level_walk"],width/2-300,height/2-240,0,1,1)
	love.graphics.print("Time Jumping",width/2-100,height/2-265,0,1,1)
	love.graphics.print(""..self.game.statistics["level_jump"],width/2-300,height/2-265,0,1,1)
	love.graphics.print("Time Falling",width/2-100,height/2-290,0,1,1)
	love.graphics.print(""..self.game.statistics["level_fall"],width/2-300,height/2-290,0,1,1)
	love.graphics.print("Time Hanging",width/2-100,height/2-315,0,1,1)
	love.graphics.print(""..self.game.statistics["level_hang"],width/2-300,height/2-315,0,1,1)
end

function SummaryState:focus()end
function SummaryState:keypressed(key)
	self.input:keypressed(key)
end
function SummaryState:keyreleased(key)
	self.input:keyreleased(key)
end
function SummaryState:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function SummaryState:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function SummaryState:joystickpressed()end
function SummaryState:joystickreleased()end
function SummaryState:quit()end