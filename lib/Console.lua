--https://love2d.org/forums/viewtopic.php?f=5&t=3223
--Console here is a special state, drawn over everything else that takes input etc
Console={}

require "lib/Parser"
require "lib/Input"

function Console:new(g)
	-- define our parameters here
	local object = {
		game = g,
		name = "console",
		height = 300,
		input = Input:new(),
		from = nil,
		lines={},
		text = "",
		capitals = false,
		parser = nil
	}
	setmetatable(object, { __index = Console })
	return object
end

function Console:init() --when state is first created, run only once
	--define input
	self.input = Input:new()
	--execute command
	self.input:addButton("press","return",function()if (#self.text>0) then self:parse(self.text)end end)
	--capital letter triggers
	self.input:addButton("press","capslock",function()self.capitals = true end)
	self.input:addButton("release","capslock",function()self.capitals = false end)
	self.input:addButton("hold","lshift",function()self.capitals = true end)
	self.input:addButton("release","lshift",function()self.capitals = false end)
	self.input:addButton("hold","rshift",function()self.capitals = true end)
	self.input:addButton("release","rshift",function()self.capitals = false end)

	--exit console
	self.input:addButton("press","`",function()self.game:switch(self.from.name)end)
	
	--define the parser
	self.parser = Parser:new(self.game)
	local height=love.graphics.getHeight()
	self.height = height/3	
end
function Console:leave()end --when state is no longer active
function Console:enter(from, ...) --when state comes back from pause (or is transitioned into)
	self.from = from
end
function Console:finish()end --when state is finished
function Console:update(dt)
	self.input:update(dt)
end
function Console:draw()
	self.from:draw()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126,240)
	love.graphics.rectangle("fill",0,0,width,self.height)
	for k,v in pairs(self.lines) do
		love.graphics.setColor(unpack(v[2]))
		love.graphics.print(v[1] or "",0,k*16-16)
	end
	love.graphics.setColor(255,255,255)
	love.graphics.line(0,self.height-16,width,self.height-16)
	love.graphics.setColor(255,255,255)
	love.graphics.print(self.text,0,self.height-16)
end
function Console:focus()
end
function Console:keypressed(key)
	self.input:keypressed(key)
	--typing, haven't found an easy way to account for this with input
	if(key=="backspace") then  --delete char
		self.text=string.sub(self.text,1,#self.text-1) 
		return 
	--need to find a better way to do this!
	elseif ( key ~= "numlock" and 
		key ~= "return" and 
		key ~= "capslock" and 
		key ~= "tab" and 
		key ~= "`" and 
		key ~= "scrollock" and 
		key ~= "rshift" and 
		key ~= "lshift" and 
		key ~= "rctrl" and 
		key ~= "lctrl" and 
		key ~= "ralt" and 
		key ~= "lalt" and 
		key ~= "rmeta" and 
		key ~= "lmeta" and 
		key ~= "lsuper" and 
		key ~= "rsuper" and 
		key ~= "mode" and 
		key ~= "compose" and 
		key ~= "end" and 
		key ~= "pause" and 
		key ~= "escape" and 
		key ~= "help" and 
		key ~= "print" and 
		key ~= "sysreq" and 
		key ~= "break" and 
		key ~= "menu" and 
		key ~= "power" and 
		key ~= "euro" and 
		key ~= "undo"
	) then
		self.text=self.text..key
	end
end
function Console:keyreleased(key)
	self.input:keyreleased(key)
	if key == "capslock" or key == "lshift" or key == "rshift" then
		self.capitals = false
	end
end
function Console:mousepressed(x,y,button)
	self.input:mousepressed(x,y,button)
end
function Console:mousereleased(x,y,button)
	self.input:mousereleased(x,y,button)
end
function Console:joystickpressed()
end
function Console:joystickreleased()
end
function Console:quit()
end

function Console:parse(command) -- right now does nothing
	local result = self.parser:parse(command)
	self:WriteLine(result,255,255,255)	
	self.text=""
end

function Console:WriteLine(txt,r,g,b)
   r=r or 255 g=g or 255 b=b or 255
   if(#self.lines>(self.height/16)-2) then table.remove(self.lines,1) end
   table.insert(self.lines,{txt,{r,g,b}})
end

function Console:command_set(params)
	-- ["set"] = function (x)	if type(self.action[x[1]]) ~= nil then
	-- 	self.action[x[1]](x[2])
	-- else
	-- 	self:WriteLine("Unknown command:"..x[1],255,255,255)
	-- end
end

function Console:command_volume(params)
	  -- ["volume"] = function (x) y = self.game:setVolume(x) self:WriteLine(y,255,255,255) end,
end

function Console:command_sound(params)
	  -- ["sound"] = function (x) y = self.game:setSoundVolume(x) self:WriteLine(y,255,255,255) end,
end

function Console:command_music(params)
	  -- ["music"] = function (x) y = self.game:setMusicVolume(x) self:WriteLine(y,255,255,255) end,
end

function Console:command_health(params)
	  -- ["health"] = function (x) y = self.game:setHealth(x) end,
end