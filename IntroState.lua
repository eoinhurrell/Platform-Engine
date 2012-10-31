IntroState = {}

display_time = 0.5
-- Constructor
function IntroState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		splash_time = display_time, --ms
		splash_images = {},
		current_image_num = 1,
		current_image = nil
	}
	object.splash_images = {"assets/splash_title.png","assets/splash_credit_1.png"}
	object.current_image =love.graphics.newImage(object.splash_images[object.current_image_num])
	--set background colour
	love.graphics.setColor(255,255,255)
	setmetatable(object, { __index = IntroState })
	return object
end

function IntroState:setGame(game)
	self.game = game
end

function IntroState:update(dt)
	local dt = dt or 0
	self.splash_time = self.splash_time - dt
	if self.splash_time < 0 then
		self.current_image_num = self.current_image_num + 1
		self.splash_time = display_time
	end
	if self.current_image_num > #self.splash_images then
		self.game:defferedLoading()
		--error(print(self.game:getSoundVolume()))
		self.game:loadState("menus")
	else
		self.current_image = love.graphics.newImage(self.splash_images[self.current_image_num])
	end
end

function IntroState:draw()
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	love.graphics.draw(self.current_image,screen_width/2 - self.current_image:getWidth()/2,screen_height/2 - self.current_image:getHeight()/2)
end