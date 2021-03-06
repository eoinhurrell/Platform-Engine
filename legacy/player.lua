require('vector')

--CONTROLS
PLAYER_MOVE_LEFT = 'left'
PLAYER_MOVE_RIGHT = 'right'
PLAYER_JUMP = 'z'

player = {}
player.__index=player
function player.load()
   local ply = {}             -- our new object
   setmetatable(ply,player)    
   ply.pos = vector.load(0,0)
   ply.velocity = vector.load(0,0)
   ply.health = 100
   ply.gravity = 290
   ply.jumpVal = vector.load(0,0)
   ply.image = love.graphics.newImage("assets/player.png")
   ply.state = 'alive'
   ply.score = 0
   ply.speed = 200
   ply.jumping = false
   ply.running = false
   ply.hangTime = 20
   ply.entities = {}
   ply.onGround = true
   ply.scaleX = 1
   ply.scaleY = 1
   ply.rotation = 0
   ply.s = ""
   return ply
end
function player:placeIn(level)
   self.entities = level:getEntities()
end

function player:getState()
   return self.state
end

function player:setState(state)
   self.state = state
end

function player:getScore()
   return self.score
end

function player:setAnim(anim)
   --really bad for memory usage, get ready for tileset!
   if anim == "left" then
      self.image = love.graphics.newImage("assets/player-left.png")
   elseif anim == "right" then
      self.image = love.graphics.newImage("assets/player-right.png")
   elseif anim == "stand" then
      self.image = love.graphics.newImage("assets/player.png")
   elseif anim == "dead" then
      self.image = love.graphics.newImage("assets/player-dead.png")
   end 
end

-- Collision detection function.
-- Checks if box1 and box2 overlap.
-- w and h mean width and height.
function player:collides(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
    if box1x > (box2x + box2w - 1) or -- Is box1 on the right side of box2?
       box1y > (box2y + box2h - 1) or -- Is box1 under box2?
       box2x > (box1x + box1w - 1) or -- Is box2 on the right side of box1?
       box2y > (box1y + box1h - 1)    -- Is b2 under b1?
    then
        return false                -- No collision. Yay!
    else
        return true                 -- Yes collision. Ouch!
    end
end

function player:getHealth()
   return self.health
end
function player:getStatus()
   if self.jumping then
      jump = 'Y'
   else
      jump = 'N'
   end
   if self.collideY or self.collideX then
      coll = 'Y'
   else
      coll = 'N'
   end
   if self.onGround then
      ground = 'Y'
   else
      ground = 'N'
   end
   return "\ngravity:"..self.gravity.."\nhT:"..self.hangTime.."\njump:"..jump.."\nonground:"..ground.."\ncollide:"..coll.."\n"..self.s..""
end

function player:move(dx, dy)
  --can check if collides, velocity determines collision direction
  self.pos.x = self.pos.x + dx
  for i,object in ipairs(self.entities) do
      if self:collides(self.pos.x, self.pos.y,self.image:getWidth(),self.image:getHeight(),object:getX(),object:getY(),object:getW(),object:getH()) then
         effects = object:contact{axis='x',y=self.velocity.y,pos=self.pos.x}
         if effects.score ~= nil then 
            self.score = self.score + effects.score
         end
         if effects.health ~= nil then
            self.health = self.health + effects.health
            if self.health > 100 then
               self.health = 100
            end
         end
         if effects.damage ~= nil then
            self.health = self.health - effects.damage
            --knockback
            if self.velocity.x < 0 then
               self.pos.x = self.pos.x + 20
            else
               self.pos.x = self.pos.x - 20
            end
            --self.velocity.x = self.velocity.x - 50 --some knockback
         end
         if effects.land ~= nil then
            self.onGround = true
         end
         self.pos.x = self.pos.x - dx
      end
   end

  self.pos.y = self.pos.y + dy
  for i,object in ipairs(self.entities) do
      if self:collides(self.pos.x, self.pos.y,self.image:getWidth(),self.image:getHeight(),object:getX(),object:getY(),object:getW(),object:getH()) then
         effects = object:contact{axis='y',y=self.velocity.y,pos=self.pos.y}
         if effects.score ~= nil then 
            self.score = self.score + effects.score
         end
         if effects.health ~= nil then
            self.health = self.health + effects.health
            if self.health > 100 then
               self.health = 100
            end
         end
         if effects.damage ~= nil then
            self.health = self.health - effects.damage
         end
         if effects.land ~= nil then
            self.onGround = true
         end
         self.pos.y = self.pos.y - dy
         self.velocity.y = self.velocity.y/2
      end
   end
   self.s = "{"..dx..","..dy.."}"
end

function player:hurt(damage)
   self.health = self.health - damage
   if self.health < 0 then
      self.health = 0
   end
end

function player:rotate(dr)
  self.rotation = self.rotation + dr
end

function player:scale(sx, sy)
  sx = sx or 0
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function player:setPosition(x, y)
  self.pos.x = x or self.pos.x
  self.pos.y = y or self.pos.y
end

function player:getX()
   return self.pos.x
end

function player:getY()
   return self.pos.y
end

function player:getWidth()
   return self.image:getWidth()
end

function player:getHeight()
   return self.image:getHeight()
end

function player:getCenterX()
   return self.pos.x + (self:getWidth()/2)
end

function player:getCenterY()
   return self.pos.y + (self:getHeight()/2)
end

function player:getVelX()
   return self.velocity.x
end

function player:getVelY()
   return self.velocity.y
end

--set velocity/action alterations based on controls
function player:keypressed(key,unicode)
   if key == "rshift" or key == "lshift" then
      self.running = true
   end
   if key == "right" or key == 'd' then
      self.velocity = self.velocity + vector.load(self.speed,0)
      self:setAnim("right")
   elseif key == "left" or key == 'a' then
      self.velocity = self.velocity - vector.load(self.speed,0)
      self:setAnim("left")
   end
   if key == "down" or key == "s" then
      --crouch
       self.velocity = self.velocity + vector.load(0,self.speed)
   elseif key == "up" then
      --jump
      if self.onGround then
         self.jumping = true
         self.onGround = false
         self:setAnim("jump")
      end
   end
end

--return to the status quo after buttons are released 
function player:keyreleased(key,unicode)
   if key == "rshift" or key == "lshift" then
      self.running = false
   end
   if (key == "right" or key == 'd') and self.velocity.x ~= 0 then
      self.velocity = self.velocity - vector.load(self.speed,0)
   elseif (key == "left" or key == 'a') and self.velocity.x ~= 0  then
      self.velocity = self.velocity + vector.load(self.speed,0)
   elseif (key=="down" or key =="s") and self.velocity ~= 0 then
      self.velocity = self.velocity - vector.load(0,self.speed) --crouch?
   end
end

--Main update loop
function player:update(dt) 
   --update animation

   --update position
   if self.onGround then
      if self.gravity > 20 then
         self.gravity = self.gravity - 10
      end
   else 
      self.gravity = 190
   end
   --running
   if self.running then
      self.speed = 400
   else
      self.speed = 200
   end
   --gravity
   self.velocity.y = self.gravity

   --jumping?
   if self.jumping then
      if self.hangTime <= 0 then --no longer jumping, either on ground or soon to be in freefall
         self.jumping = false
         self.hangTime = 20
      else --still in air, legitmate jump
         self.hangTime = self.hangTime - 1
         --self.jumpVal = (self.gravity * 30 * self.hangTime)
         self.pos.y = self.pos.y - 800*dt --vertical speed of jump.slower and longer hangtime = more horizontal movement         
      end
   end

   --move
   self:move(self.velocity.x*dt,self.velocity.y*dt)
   --HACK: reapply gravity if you've walked off the edge of something
   if self.velocity.y == self.gravity then
      self.onGround = false
   end
   --pit damage
   if self.pos.y >= 100 then
      self:hurt(1)
      if self.pos.y >= 500 then
         self:hurt(1000)
      end
   end

   --check health, stop if dead
   if self.health <= 0 then
      self.state = 'dying'
      self:setAnim("dead")
   end

   if self.state == 'dying' then
      self.hangTime = self.hangTime + 1
      if self.hangTime >= 60 then
         self.state = 'dead'
         self:setAnim("dead")
      end
   end

   if self.velocity.x == 0 and not self.jumping then
      self:setAnim("stand")
   end
end

function player:draw()
   love.graphics.draw(self.image, self.pos.x, self.pos.y)
end
