LoadState = {}

-- Constructor
function LoadState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		loading_image = "assets/loading.png",
		loadtime = 0,
		waiting_state = ""
	}
	object.loading_image = love.graphics.newImage(object.loading_image)
	setmetatable(object, { __index = LoadState })
	return object
end

function LoadState:update(dt)
	local dt = dt or 1
	t = self.game --gamestates
	for i,v in ipairs(t) do
		print(i,v) 
		if i == self.waiting_state then --it's been loaded
			if self.game.debug then 
				--print "Load time for "..self.waiting_state.." :"..self.loadtime 
			end
			self.game:setState(self.waiting_state)
		end
	end
	self.loadtime = self.loadtime + dt
	if self.loadtime > 1000 and self.game.debug then 
		--print "SLOW: "..self.waiting_state.." :"..self.loadtime 
	end
end

function LoadState:draw()
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	--love.graphics.draw(self.loading_image,screen_width/2 - self.loading_image.width/2,screen_height/2 - self.loading_image.height/2)	
	love.graphics.draw(self.loading_image,screen_width/2 - 800,screen_height/2 - 400)	
end

function LoadState:waitingFor(state)
	self.waiting_state = state
end