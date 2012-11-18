IntroState = {}

display_time = 2.5
-- Constructor
function IntroState:new(g)
	-- define our parameters here
	local object = {
		game = g,
		input= Input:new(),
		name = "intro",
		splash_time = display_time, --ms
		splash_opacity = 5,
		splash_images = {"assets/splash_title.png","assets/splash_credit_1.png"},
		current_image_num = 1,
		current_image = nil
	}
	setmetatable(object, { __index = IntroState })
	return object
end

function IntroState:init() --when state is first created, run only once
	self.current_image =love.graphics.newImage(self.splash_images[self.current_image_num])
	--set background colour
	love.graphics.setColor(255,255,255)	
end 
function IntroState:leave()end --when state is no longer active
function IntroState:enter(from, ...)end --when state comes back from pause (or is transitioned into)
function IntroState:finish()end --when state is finished
function IntroState:update(dt)
	local dt = dt or 0
	self.splash_time = self.splash_time - dt
	self.splash_opacity = (255-(self.splash_time*(250/(display_time+1))))
	if self.splash_opacity > 255 then self.splash_opacity = 255 end
	if self.splash_time < 0 then
		self.current_image_num = self.current_image_num + 1
		self.splash_time = display_time
		self.splash_opacity = 5
	end
	if self.current_image_num > #self.splash_images then
		self.game:switch("menus")
	else
		self.current_image = love.graphics.newImage(self.splash_images[self.current_image_num])
	end
	self.input:update(dt)	
end
function IntroState:draw()
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	love.graphics.setColor(255,255,255,self.splash_opacity)
	love.graphics.clear()
	love.graphics.draw(self.current_image,screen_width/2 - self.current_image:getWidth()/2,screen_height/2 - self.current_image:getHeight()/2)
	love.graphics.setColor(255,255,255,255)
end
function IntroState:focus()end
function IntroState:keypressed()
	self.input:keypressed(key)
end
function IntroState:keyreleased()
	self.input:keyreleased(key)
end
function IntroState:mousepressed()
	self.input:mousepressed(x,y,button)
end
function IntroState:mousereleased()
	self.input:mousereleased(x,y,button)
end
function IntroState:joystickpressed()end
function IntroState:joystickreleased()end
function IntroState:quit()end