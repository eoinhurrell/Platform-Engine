require('camera')
require('player')
require('entity')
require('world')

console_lines = {}
console_input = ""
menu_selection = 0
player = player.load()
level = world.load()
debug = false
state = "alive"
game_state = "title" --title/running/dead/paused/high_score/console

function love.load(args)
end

function loadLevel(levelname)
   level = world.load()
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
   if game_state == "running" then
      level:update(dt)
      player:update(dt)
   end
   if game_state ~= "title" and game_state ~= "high_score" then
      x = player:getCenterX() - (player:getX()/(player.speed/3))
      y = player:getCenterY() - (player:getY()/(player.speed/3))
      camera:focusOn(x,(y/2))
   end
   --camera:setPosition(entity.x - (camera.x/(entity.speed*5)),entity.y - (camera.y/(entity.speed*5)))
end

function love.draw()
   camera:draw()
   --major game mechanics logic (i.e. what changes states)
   state = player:getState()
   if state == 'dead' then
      game_state = 'dead'
   end

   if game_state == 'title' then
      drawTitle()
   elseif game_state == 'dead' then
      drawDead()
   elseif game_state == 'paused' then
      drawPause()
   elseif game_state == 'console' then
      drawConsole()
   elseif game_state == 'high_score' then
      drawHighScore()
   elseif game_state == 'running' then
      hudHealth()
      hudScore()
   end
   if debug == true then
      hudDebug()
   end
end

function drawTitle()
   --would really like this to be animated
   image = love.graphics.newImage("assets/title.png")
   x = (love.graphics.getWidth()/2)-(image:getWidth()/2)
   y = (love.graphics.getHeight()/2)-(image:getHeight()/2)
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(),love.graphics.getHeight())
   love.graphics.setColor(255,255,255)
   love.graphics.draw(image,x,y)
   y = 300 
   x = x + 15
   love.graphics.print("PAUSE MENU", x, y)
   love.graphics.print("-------------------------", x, y+6)
   love.graphics.print("  New Game", x, y+19)
   love.graphics.print("  Load Game", x, y + 34)
   love.graphics.print("  Exit", x, y + 49)
   love.graphics.print(">",x, y+19+(menu_selection*15))
end

function drawDead()
   image = love.graphics.newImage("assets/game-over.png")
   x = (love.graphics.getWidth()/2)-(image:getWidth()/2)
   y = (love.graphics.getHeight()/2)-(image:getHeight()/2)
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle('fill', 0,0,love.graphics.getWidth(),love.graphics.getHeight())
   love.graphics.setColor(255,255,255)
   love.graphics.draw(image,x,y)
end

function drawPause()
   love.graphics.setColor(0,0,0,175)
   love.graphics.rectangle('fill', 0,0,800,600)
   love.graphics.setColor(255,255,255)
   love.graphics.print("PAUSE MENU", 5, 26)
   love.graphics.print("-------------------------", 5, 32)
   love.graphics.print("  Resume Game", 5, 45)
   love.graphics.print("  Save/Load Game", 5, 60)
   love.graphics.print("  Exit", 5, 75)
   love.graphics.print(">",5, 45+(menu_selection*15))
end

function drawConsole()
   love.graphics.setColor(0,0,0,175)
   love.graphics.rectangle('fill', 0,0,800,600)
   love.graphics.setColor(10,10,10)
   love.graphics.rectangle('fill', 0,0,800,300)
   love.graphics.setColor(255,255,255)
   love.graphics.print("CONSOLE", 5, 26)
   love.graphics.print("-------------------------", 5, 32)
   start = 50
   increment = 18
   x = 0
   for k,v in pairs(console_lines) do
      love.graphics.setColor(unpack(v[2]))
      love.graphics.print(v[1] or "",5,start+(increment*x))
      x = x + 1
   end
   love.graphics.setColor(255,255,255)
   love.graphics.print(">"..console_input,5,280)
end

function drawHighScore()
end

function love.keypressed(key, unicode)
   --handle state changes
   if key == 'escape' then
      love.event.push('q') --quit
   end
   --handle key presses in different states
   if game_state == "running" then
      pressedRunning(key,unicode)
   elseif game_state == "title" then
      pressedTitle(key,unicode)
   elseif game_state == "paused" then 
      pressedPaused(key,unicode)
   elseif game_state == "console" then
      pressedConsole(key,unicode)
   elseif game_state == "dead" then
      game_state = "title"
   end
end

function pressedRunning(key,unicode)
   if key == 'p' then
      game_state = 'paused'
      menu_selection = 0
   elseif key == '`' or key == '~' then
      game_state = 'console'
   elseif key == 'i' then
      debug = not debug
   end
   player:keypressed(key,unicode)
end

function pressedTitle(key,unicode)
   if key == 'up' then
      menu_selection = menu_selection - 1
      if menu_selection < 0 then
         menu_selection = 0
      end
   elseif key == 'down' then
      menu_selection = menu_selection + 1
      if menu_selection > 2 then
         menu_selection = 2
      end
   elseif unicode == 13 then --select choice
      if menu_selection == 0 then --new game
         loadLevel("")
         game_state = "running"
      elseif menu_selection == 1 then --save/load
      elseif menu_selection == 2 then --exit (give option to desktop or menu?)
         love.event.push('q') --quit
         return
      end
   end 
end

function pressedPaused(key,unicode)
   if key == 'p' then
      game_state = "running"
   elseif key == 'up' then
      menu_selection = menu_selection - 1
      if menu_selection < 0 then
         menu_selection = 0
      end
   elseif key == 'down' then
      menu_selection = menu_selection + 1
      if menu_selection > 2 then
         menu_selection = 2
      end
   elseif unicode == 13 then --select choice
      if menu_selection == 0 then --unpause
         game_state = "running"
      elseif menu_selection == 1 then --save/load
      elseif menu_selection == 2 then --exit (give option to desktop or menu?)
         love.event.push('q') --quit
         return
      end
   end
end

function pressedConsole(key,unicode)
   if key == '`' or key == '~' then
      game_state = "running"
   elseif key =="backspace" then 
      console_input=string.sub(console_input,1,#console_input-1)
   elseif unicode == 13 then --run command
      if console_input == 'quit' then
         love.event.push('q') --quit
         return
      elseif console_input == 'green' then
         result = {console_input .. " - GREEN COMMAND",{0,255,0}}
      else
         result = {console_input .. " - INVALID COMMAND",{255,0,0}}
      end
      table.insert(console_lines, result)
      if(#console_lines>13) then table.remove(console_lines,1) end
      console_input = ""
   elseif unicode ~= 0 then 
      console_input=console_input..string.char(unicode) 
   end
end

function love.keyreleased(key,unicode)
   if game_state == "running" then
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
