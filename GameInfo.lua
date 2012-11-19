GameInfo = {}
require "states/IntroState"
require "states/LoadState"
require "states/MenuState"
require "states/GameState"
require "states/PauseState"
require "states/SummaryState"
require "states/DiedState"
require "lib/Achievements"
require "lib/Console"

-- Constructor
function GameInfo:new()
	-- define our parameters here
	local object = {
		volume_sound = 100,
		volume_music = 100,
		debug = true,
		log_file = "debug.log",
		achievements = Achievements:new(),

		--gameplay variables
		diff_modifier = {easy=0.5,normal=1.0,hard=2.0},
		difficulty = "normal",
		god = false,
		health = 100,
		score = 0,
		gravity = 1800,
		
		--state info
		current_state = nil,
		state = "menus", --starting state
		state_stack = {},
		gamestates = {},
		statistics = {
			["level_score"] = 0,
			["level_time"]  = 0,
			["level_idle"]  = 0,
			["level_walk"]  = 0,
			["level_jump"]  = 0,
			["level_fall"]  = 0,
			["level_hang"]  = 0,
			["level_stand"] = 0,
			["level_move"] = 0,
			["level_"]      = 0,
			["game_score"] = 0,
			["game_time"]  = 0,
			["game_idle"]  = 0,
			["game_walk"]  = 0,
			["game_jump"]  = 0,
			["game_fall"]  = 0,
			["game_hang"]  = 0,
			["game_stand"] = 0,
			["game_move"] = 0,
			["game_"] = 0,
			["jumps"] = 0,
			["fall_damage"] = 0
		}
	}
	setmetatable(object, { __index = GameInfo })
	return object
end

function GameInfo:load()
	--t = love.timer.getMicroTime()
	self.gamestates["console"]  = Console:new(self)
	self.gamestates["intro"]    = IntroState:new(self)
	self.gamestates["menus"]    = MenuState:new(self)
	self.gamestates["loading"]  = LoadState:new(self)
	self.gamestates["level"]    = GameState:new(self)
	self.gamestates["summary"]  = SummaryState:new(self)
	self.gamestates["pause"]    = PauseState:new(self)
	self.gamestates["died"]     = DiedState:new(self)

	self.current_state = self.gamestates[self.state]
	self.current_state:init()
	self.current_state.init = self.current_state.enter--__NULL__ --Can't be called again?
	
	self.achievements:register("001","ZZZ","Caught some z!","assets/player.png")
	--s = "Loaded states in "..(love.timer.getMicroTime()-t).."seconds." NIL APPARENTLY
	--self.logMsg(s)
end

function GameInfo:switch(to, ...)
	to_state = self.gamestates[to]
	self.current_state:leave()
	local pre = self.current_state
	to_state:init()
	to_state.init = to_state.enter--__NULL__ --Can't be called again?
	self.current_state = to_state
	return self.current_state:enter(pre, ...)
end

--FILE OPERATIONS
--Loads the list of levels, playingState will handle the actual loading of a level
function GameInfo:loadLevels()
	self.level_files[1] = "level_list.xml"
end

function GameInfo:loadSettings()
end

function GameInfo:saveSettings()
end

function GameInfo:resetLevelStats()
	self.statistics["level_score"] = 0
	self.statistics["level_time"] = 0
	self.statistics["level_idle"] = 0
	self.statistics["level_walk"] = 0
	self.statistics["level_jump"] = 0
	self.statistics["level_fall"] = 0
	self.statistics["level_hang"] = 0
	self.statistics["level_"] = 0
	self.statistics["level_stand"] = 0
	self.statistics["level_move"] = 0
end

function GameInfo:loadAchievements()
end

function GameInfo:saveAchievements()
end
--END FILE OPERATIONS

--gameplay variables
function GameInfo:getHealth()
	return self.health
end

function GameInfo:setHealth(amount)
	if tonumber(amount) ~= "nil" then
		if tonumber(amount) <= 100 then
			self.health = tonumber(amount)
		end
	end
end

function GameInfo:takeDamage(damage)
	if tonumber(damage) ~= "nil" and not self.god then
		self.health = self.health - tonumber(damage)
		if self.health < 0 then
			self.health = 0
		end
	end
end

function GameInfo:addHealth(health)
	if tonumber(health) ~= "nil" then
		self.health = self.health + tonumber(health)
	end
end

function GameInfo:isAlive()
	if self.health > 0 then return true end
	return false
end

function GameInfo:getScore()
	return self.statistics["game_score"]
end

function GameInfo:addScore(amount)
	if tonumber(amount) ~= "nil" then
		self.statistics["game_score"] = self.statistics["game_score"] + tonumber(amount)
		self.statistics["level_score"] = self.statistics["level_score"] + tonumber(amount)
	end
end

--returns state object, not name
function GameInfo:getState()
	return self.current_state
end

--returns
function GameInfo:getDiffModifier()
	--diff_modifier = {easy=0.5,normal=1.0,hard=2.0}
	--difficulty = "normal"
	return diff_modifier[difficulty]
end

function GameInfo:getConsole()
	return self.hud_console
end

function GameInfo:getAchievements()
	return self.achievements
end

--Accessors for console accessible stuff that needs to be safe
function GameInfo:setGravity(gravity)
	if tonumber(gravity) ~= "nil" then
		self.gravity = gravity
	end
end

function GameInfo:getGravity()
	return self.gravity
end

function GameInfo:resetGravity()
	self.gravity = 1800
end

function GameInfo:setGod(is_god)
	--if type(is_god) == "boolean" then	
	self.god = is_god
	--end
end

function GameInfo:isGod()
	return self.god
end

function GameInfo:getVolume()
	return self.volume_sound
end

function GameInfo:setVolume(volume)
	self.volume_sound = volume
	self.volume_music = volume
	return "Volume is now " .. self.volume_sound
end

function GameInfo:getSoundVolume()
	return self.volume_sound
end

function GameInfo:setSoundVolume(volume)
	self.volume_sound = volume
end

function GameInfo:getMusicVolume()
	return self.volume_music
end

function GameInfo:setMusicVolume(volume)
	self.volume_music = 100
end

function GameInfo:isDebug()
	return self.debug
end

function GameInfo:setDebugStatus(set_debug)
	self.debug = set_debug
end

function GameInfo:logMsg(msg)
	love.filesystem.write(self.log_file, msg,string.byte(msg))
	if self.debug then
		print(msg)
	end
end

--clamp function: http://nova-fusion.com/2011/04/19/cameras-in-love2d-part-1-the-basics/
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end