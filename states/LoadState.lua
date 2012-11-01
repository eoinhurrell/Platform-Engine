LoadState = {}
--This'll want to be some sort of observer that gets called when big loading is going to happen, then signaled again when loading is done.
-- Constructor
function LoadState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		input = Input:new(),
		name = "loading",
		loading_image = "assets/loading.png",
		loadtime = 0,
		waiting_state = ""
	}
	object.loading_image = love.graphics.newImage(object.loading_image)
	setmetatable(object, { __index = LoadState })
	return object
end

function LoadState:init()end --when state is first created, run only once
function LoadState:leave()end --when state is no longer active
--will need to pass a variable to the loading screen to know what is upcoming
function LoadState:enter(from, ...)end --when state comes back from pause (or is transitioned into)
function LoadState:finish()end --when state is finished
--checks if whatever has loaded (currently just checks if the state available)
function LoadState:update(dt)
	local dt = dt or 1
	t = self.game:getGamestates()
	for i = 1,#t do 
		if t[i] == self.waiting_state then --it's been loaded
			if self.game.debug then 
				--print "Load time for "..self.waiting_state.." :"..self.loadtime 
			end
			self.game:setState(self.waiting_state)
		end
	end
	-- self.loadtime = self.loadtime + dt
	-- 	if self.loadtime > 3 then
	-- 		self.game:setState(self.waiting_state)
	-- 		if self.game.debug then 
	-- 		--print "SLOW: "..self.waiting_state.." :"..self.loadtime 
	-- 		end
	-- 	end
end
function LoadState:draw()
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	love.graphics.draw(self.loading_image,screen_width/2 - self.loading_image:getWidth()/2-100,screen_height/2 - self.loading_image:getHeight()/2)	
	-- love.graphics.draw(self.loading_image,screen_width/2 - 800,screen_height/2 - 400)
end
function LoadState:focus()end
function LoadState:keypressed()end
function LoadState:keyreleased()end
function LoadState:mousepressed()end
function LoadState:mousereleased()end
function LoadState:joystickpressed()end
function LoadState:joystickreleased()end
function LoadState:quit()end
function LoadState:waitFor(state)
	self.waiting_state = state
end
