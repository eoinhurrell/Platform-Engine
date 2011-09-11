require('camera')
require('player')
require('entity')
require('world')

player = player.load()
level = world.load()
debug = false
state = "alive"

function love.load(args)
   player:placeIn(level)
   player:setPosition(0,0)
   camera.layers = {}
   camera:newLayer(0.5, function()
      level:drawBackground()
   end)
   camera:newLayer(1,function()
      level:drawLevel()
   end)
   camera:newLayer(1,function()
      player:draw()
   end)
   camera:newLayer(1.2, function()
      level:drawForeground()   
   end)
end

function love.update(dt)
   --decide on state

   if state ~= "dead" then
      level:update(dt)
      player:update(dt)
      x = player:getCenterX() - (player:getX()/(player.speed/3))
      y = player:getCenterY() - (player:getY()/(player.speed/3))
      camera:focusOn(x,(y/2))
   end
   --camera:setPosition(entity.x - (camera.x/(entity.speed*5)),entity.y - (camera.y/(entity.speed*5)))
end

function love.draw()
   camera:draw()
   --major game mechanics logic (i.e. what changes states
   state = player:getState()
   if state == 'dead' then
      --state = "dead"
      image = love.graphics.newImage("assets/game-over.png")
      x = (love.graphics.getWidth()/2)-(image:getWidth()/2)
      y = (love.graphics.getHeight()/2)-(image:getHeight()/2)
      love.graphics.setColor(0,0,0)
      love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(),love.graphics.getHeight())
      love.graphics.setColor(255,255,255)
      love.graphics.draw(image,x,y)
   else
      hudHealth()
      hudScore()
   end
   if debug == true then
      hudDebug()
   end
end

function love.keypressed(key, unicode)
   if key == 'escape' then
      love.event.push('q')
   elseif key == 'i' then
      debug = not debug
   end
   if state ~= "dead" then
      player:keypressed(key,unicode)
   end
end

function love.keyreleased(key,unicode)
   if state ~= "dead" then
      player:keyreleased(key,unicode)
   end
end

function hudHealth()
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle('fill', 2,2,104,24)
   love.graphics.setColor(255,0,0)
   love.graphics.rectangle('fill', 4,4,player:getHealth(),20)
   love.graphics.setColor(255,255,255)
end
function hudScore()
   love.graphics.print("Score: " .. player:getScore(), 2, 26)
end

function hudDebug()
   love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 26)
   love.graphics.print("Player: (" .. player:getX() .. ",".. player:getY() .. ")", 2, 44)
   love.graphics.print("Velocity: (" .. player:getVelX() .. ",".. player:getVelY() .. ")", 2, 62)
   love.graphics.print("Status: (" .. player:getStatus() .. ")", 2, 74)
end
