require "Player"
require "GameInfo"
--assigning state
--gamestate = gamestates[3]
--calling functions for state
--gamestate:stuff()

function love.load()
	game = GameInfo:new()
    -- g = love.graphics
    -- playerColor = {255,0,128}
    -- groundColor = {25,200,25}
    
    -- instantiate our player and set initial values

    -- p = Player:new()
    -- 
    -- p.x = 300
    -- p.y = 300
    -- p.width = 25
    -- p.height = 40
    -- p.jumpSpeed = -800
    -- p.runSpeed = 500
    -- 
    -- gravity = 1800
    -- 
    -- yFloor = 500
end
 
function love.update(dt)
	state = game:getState()
	state:update(dt)
    -- if love.keyboard.isDown("right") then
    --     p:moveRight()
    -- end
    -- if love.keyboard.isDown("left") then
    --     p:moveLeft()
    -- end
    -- 
    -- -- if the x key is pressed...
    -- if love.keyboard.isDown("x") then
    -- -- make the player jump
    --     p:jump()
    -- end
    --  
    -- -- update the player's position
    -- p:update(dt, gravity)
    --  
    -- -- stop the player when they hit the borders
    -- if p.x > 800 - p.width then p.x = 800 - p.width end
    -- if p.x < 0 then p.x = 0 end
    -- if p.y < 0 then p.y = 0 end
    -- if p.y > yFloor - p.height then
    --     p:land(yFloor)
    -- end
end
 
function love.draw()
	state = game:getState()
	state:update(dt)
    -- -- round down our x, y values
    -- local x = math.floor(p.x)
    -- local y = math.floor(p.y)
    -- 
    -- -- draw the player shape
    -- g.setColor(playerColor)
    -- g.rectangle("fill", x, y, p.width, p.height)
    -- 
    -- -- draw the ground
    -- g.setColor(groundColor)
    -- g.rectangle("fill", 0, yFloor, 800, 100)
    -- 
    -- -- debug information
    -- g.setColor(255, 255, 255)
    -- local isTrue = ""
    -- g.print("Player coordinates: ("..x..","..y..")", 5, 5)
    -- g.print("Current state: "..p.state, 5, 20)
end
 
function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()  -- actually causes the app to quit
    end
    if (key == "right") or (key == "left") then
        p:stop()
    end
end