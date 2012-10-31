GameInfo = {}

require "IntroState"
require "LoadState"
require "MenuState"
require "GameState"
require "PauseState"
-- Constructor
function GameInfo:new()
	-- define our parameters here
	local object = {
		volume_sound = 100,
		volume_music = 100,
		debug = true,
		--hud_console = Console:new(),
		--achievements = Achievements:new(),

		--gameplay variables
		player = Player:new(),
		level = 1, --index down the list of levels available.
		level_files = {},
		diff_modifier = {easy=0.5,normal=1.0,hard=2.0},
		difficulty = "normal",
		god = false,
		health = 100,
		gravity = 1800,
		
		--state info
		state = "intro",
		state_stack = {},
		intro = nil,
		loads = nil,
		menus = nil,
		level = nil,
		pause = nil,
		gamestates = {},
	}
	object.intro = IntroState:new(self)
	object.loads = LoadState:new(self)
	object.gamestates["intro"] = {object.intro:update(dt) , object.intro:draw()}
	object.gamestates["loading"] = {object.loads:update(dt) , object.loads:draw()}
	setmetatable(object, { __index = GameInfo })
	return object
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

function GameInfo:getLevel()
	return self.level
end

function GameInfo:setLevel(lvl)
	self.level = lvl
end

--deferred loading
function GameInfo:defferedLoading()
	self:setState("loading")
	loads:waitingFor("menus")
	-- menus = MenuState:new(self)
	-- level = GameState:new(self)
	-- pause = PauseState:new(self)
	-- self:addGamestate("menus",menus)
	-- self:addGamestate("level",level)
	-- self:addGamestate("pause",pause)
end

function GameInfo:getGamestates()
	return self.gamestates
end

--add stack, for deferred loading of states
function GameInfo:addGamestate(state_name, obj)
	self.gamestates[state_name] = {obj:update() , obj:draw()}
end

--will want to go back
function GameInfo:changeState(current_state,new_state_name)
	self:pushState(current_state)
	self.state = new_state_name
end

--resets stack! Won't want to return
function GameInfo:setState(state_name)
	self.state = state_name
	self.state_stack = {}
end

--returns state object, not name
function GameInfo:getState()
	return self.gamestates[self.state]
end

--pushes a state object onto the stack
function GameInfo:pushState(state)
	--table.insert(self.state_stack,state)
	self.state_stack[#self.state_stack+1] = state
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

function GameInfo:getDebugStatus()
	return self.debug
end

function GameInfo:setDebugStatus(set_debug)
	self.debug = set_debug
end