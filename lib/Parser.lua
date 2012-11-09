Parser={}

function Parser:new(g)
	-- define our parameters here
	local object = {
		game = g,
		action = nil --table with refs to all functions we can do
	}
	object.action = {
	  ["set"]     = function(tab) ret_msg = object:command_set(tab)     return ret_msg end,
	  ["reset"]   = function(tab) ret_msg = object:command_reset(tab)   return ret_msg end,
	  ["volume"]  = function(tab) ret_msg = object:command_volume(tab)  return ret_msg end,
	  ["sound"]   = function(tab) ret_msg = object:command_sound(tab)   return ret_msg end,
	  ["music"]   = function(tab) ret_msg = object:command_music(tab)   return ret_msg end,
	  ["health"]  = function(tab) ret_msg = object:command_health(tab)  return ret_msg end,
	  ["gravity"] = function(tab) ret_msg = object:command_gravity(tab) return ret_msg end,
	  ["god"]     = function(tab) ret_msg = object:command_god(tab)     return ret_msg end,
	  ["die"]     = function(tab) object.game:setHealth(0)              return "died!" end,
	  ["kill"]    = function(tab) object.game:setHealth(0)              return "died!" end
	}
	setmetatable(object, { __index = Parser })
	return object
end

function Parser:parse(text) -- right now does nothing
	self.game:setHealth(50)
	local parts = {}
	for bit in text:gmatch("%S+") do
		table.insert(parts,bit)
	end
	if self.action[parts[1]] == nil then 
		-- if the command is valid pass all parameters to it
		return "Unknown command:"..text
	else
		command = parts[1]
		table.remove(parts,1)
		return self.action[command](parts)
	end
end

function Parser:command_set(params)
	local command = params[1]
	table.remove(params,1)
	if self.action[command] == nil then
		return "Command not recognized: "..command
	else
		return self.action[command](params)
	end
end

function Parser:command_reset(params)
	local command = params[1]
	table.remove(params,1)
	if self.action[command] == nil then
		return "Command not recognized: "..command
	else
		return self.action[command](params)
	end
end

function Parser:command_volume(params)
	local value = params[1]
	if tonumber(value) == "nil" then
		return "Cannot change volume: number expected"
	end
	self.game:setVolume(value)
	return "Master volume is ".. self.game:getVolume()
end

function Parser:command_sound(params)
	local value = params[1]
	if tonumber(value) == "nil" then
		return "Cannot change sound volume: number expected"
	end
	self.game:setSoundVolume(value)
	return "Sound volume is ".. self.game:getSoundVolume()
end

function Parser:command_music(params)
	local value = params[1]	
	if tonumber(value) == "nil" then
		return "Cannot change music volume: number expected"
	end
	self.game:setMusicVolume(value)
	return "Music volume is ".. self.game:getMusicVolume()	
end

function Parser:command_health(params)
	local value = params[1]	
	if tonumber(value) == "nil" then
		return "Cannot change health: number expected"
	end
	self.game:setHealth(value)
	return "Health is " ..self.game:getHealth()
end

function Parser:command_gravity(params)
	local value = params[1]	
	if tonumber(value) == "nil" then
		return "Cannot change gravity: number expected"
	end
	self.game:setGravity(value)
	return "Gravity is " ..self.game:getGravity()
end

function Parser:command_gravity(params)
	local value = params[1]	
	if tonumber(value) == "nil" then
		return "Cannot change gravity: number expected"
	end
	self.game:setGravity(value)
	if self.game:isGod() then
		return "god mode is ON"
	else
		return "god mode is OFF"
	end
end
