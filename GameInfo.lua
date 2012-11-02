GameInfo = {}

require "states/IntroState"
require "states/LoadState"
require "states/MenuState"
require "states/GameState"
require "states/PauseState"
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
		level = 1, --index down the list of levels available.
		level_files = {},
		diff_modifier = {easy=0.5,normal=1.0,hard=2.0},
		difficulty = "normal",
		god = false,
		health = 100,
		score = 0,
		gravity = 1800,
		
		--state info
		current_state = nil,
		state = "intro",
		state_stack = {},
		gamestates = {}
	}
	setmetatable(object, { __index = GameInfo })
	return object
end

function GameInfo:load()
	--t = love.timer.getMicroTime()
	self.gamestates["console"]= Console:new(self)
	self.gamestates["intro"]  = IntroState:new(self)
	self.gamestates["loading"]= LoadState:new(self)
	self.gamestates["level"]  = GameState:new(self)
	self.gamestates["pause"]  = PauseState:new(self)
	self.gamestates["menus"]  = MenuState:new(self)
	self.current_state = self.gamestates[self.state]
	
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
	self.level_files[1] = "test.xml"
end

function GameInfo:loadSettings()
end

function GameInfo:saveSettings()
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
	self.health = amount
end

function GameInfo:takeDamage(damage)
	self.health = self.health - damage
end

function GameInfo:isAlive()
	if self.health > 0 then return true end
	return false
end

function GameInfo:getScore()
	return self.score
end

function GameInfo:addScore(amount)
	self.score = self.score + amount
end

function GameInfo:getLevel()
	return self.level
end

function GameInfo:setLevel(lvl)
	self.level = lvl
end

--deferred loading
function GameInfo:defferedLoading()
	self:setState("loading")
	self.gamestates["loading"]:waitFor("menus")

	-- self:addGamestate("menus",menus)
	-- self:addGamestate("level",level)
	-- self:addGamestate("pause",pause)
end
-- goes through loading state to get to wanted state
function GameInfo:loadState(state_name)	
	self:changeState("loading")
	self.gamestates["loading"]:waitFor(state_name)
end

--returns state object, not name
function GameInfo:getState()
	return self.current_state
end

--pushes a state object onto the stack
function GameInfo:pushState(state)
	--table.insert(self.state_stack,state)
	--self.state_stack[1] = state
	
end

function GameInfo:popState() -- for now can only go one step back
	-- return table
	local return_state = self.state_stack[#self.state_stack]
	table.remove(self.state_stack)
	return return_state
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
	self.gravity = gravity
end

function GameInfo:resetGravity()
	self.gravity = 1800
end

function GameInfo:setGod(is_god)
	self.god = is_god
end

function GameInfo:getSoundVolume()
	return self.volume_sound
end

function GameInfo:setSoundVolume(volume)
	self.volume_sound = 100
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
