require "GameInfo"

function love.load()
	game = GameInfo:new()
	game:load()
end
 
function love.update(dt)
	state = game:getState()
	state:update(dt)
end
 
function love.draw()
	state = game:getState()
	state:draw()
end

function love.keypressed(key)
	state = game:getState()
	state:keypressed(key)
end
 
function love.keyreleased(key)
	state = game:getState()
	state:keyreleased(key)
end

function love.mousepressed(x,y,button)
	state = game:getState()
	state:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
	state = game:getState()
	state:mousereleased(x,y,button)
end

