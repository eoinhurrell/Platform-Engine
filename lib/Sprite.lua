Sprite = {}

-- Constructor
function Sprite:new(from_file,width, height, num_rows, num_frames)
	-- define our parameters here
	local object = {
		file = from_file,
		image = nil,
		sprites = {},
		height = height,
		width = width,
		current_frame = 1,
		num_frames = num_frames,
		current_row = 1,
		num_rows = num_rows,
		delta = 0,
		delay = 200,
		loop = true,
		flipX = false,
		flipY = false,
		isRunning = true
	}
	setmetatable(object, { __index = Sprite })
	return object
end

function Sprite:load(delay)
	-- Set the time between frames
	self.delay = delay
	-- Load up our images into a table from quads, and set our SpriteRow
	self.image = love.graphics.newImage(self.file)
	local sourceImage = love.graphics.newImage(self.file)
	for i = 1, self.num_rows, 1 do
		self.sprites[i] = {}
		local high = self.height * (i - 1)
		for j = 1, self.num_frames, 1 do
			-- Create a matrix of all our sprites
			local wide = self.width * (j - 1)
			-- print("--------------------->>>>>>>")
			-- 		   print(""..self.file)
			-- 		   print("("..wide..","..high..")")
			-- 		   print("("..i..","..j..")")
			-- 		   print("--------------------->>>>>>>")
			self.sprites[i][j] = love.graphics.newQuad(wide, high, self.width, self.height, sourceImage:getWidth(), sourceImage:getHeight())
			-- if self.sprites[i][j] == nil then
			-- 	print("ERROR: ("..wide..","..high..")")
			-- end
		end
	end
end
 
function Sprite:update(dt)
	if self.isRunning then -- skip this if animation is stopped
		-- add in our accumulated delta
		self.delta = self.delta + dt
		-- see if it's time to advance the frame
		if self.delta >= (self.delay/1000) then
			-- if set to not loop, keep the frame at the last frame
			if (self.current_frame == self.num_frames) and not(self.loop) then
				self.current_frame = self.num_frames - 1
			end
			-- advance one frame, then reset delta counter
			self.current_frame = (self.current_frame % self.num_frames) + 1
			self.delta = 0
		end
	end
end
 
function Sprite:draw(x, y)
	-- define temporary offsets for drawing
	local xScale = 1
	local yScale = 1
	local xOffset = 0
	local yOffset = 0

	if self.flipX then
		xScale = -1
		xOffset = self.width
	end
	if self.flipY then
		yScale = -1
		yOffset = self.height
	end
	-- draw the quad
   -- print("------------------------------")
   -- print(""..self.file)
   -- print(""..self.current_row)
   -- print(""..self.current_frame)
   -- if (self.sprites[self.current_row][self.current_frame] == nil) then
   -- 	print("nil")
   -- end
   -- print("------------------------------")
	love.graphics.drawq(self.image, self.sprites[self.current_row][self.current_frame], x, y, 0, xScale, yScale, xOffset, yOffset)
end
 
function Sprite:switch(newRow, newMax, newDelay)
	-- Optional: assign a new number of animation frames
	if newMax then
		self.num_frames = newMax
	end

	-- Optional: assign a new delta
	if newDelay then
		self.delay = newDelay
	end

	-- Switch to the new row
	self.current_row = newRow

	-- If we're beyond the maximum frame, reset
	if self.current_frame > self.num_frames then
		self:reset()
	end
end

function Sprite:reset()
	self.current_frame = 1
end

function Sprite:start(frame)
	if frame then 
		self.current_frame = frame
	end
end

function Sprite:stop(frame)
	if frame then 
		self.current_frame = frame
	end
end

function Sprite:flip(flip_x,flip_y)
   self.flipX = flip_x
   self.flipY = flip_y
end