entity = {}
entity.__index=entity

function entity.load(info)
   local ent = {}             -- our new object
   setmetatable(ent,entity)  -- make Account handle lookup
   ent.x = info.x or 0
   ent.y = info.y or 0
   if info.img ~= nil then
      ent.image = love.graphics.newImage(info.img)
      ent.w = ent.image:getWidth()
      ent.h = ent.image:getHeight()
   else
      ent.image = nil
      ent.w = info.w 
      ent.h = info.h
   end
   ent.kind = info.kind or 'none'
   ent.done = false
   return ent
end
function entity:getX()
   return self.x
end

function entity:getY()
   return self.y
end

function entity:getW()
   return self.w
end

function entity:getH()
   return self.h
end

function entity:getKind()
   return self.kind
end

function entity:setKind(k)
   self.kind = k
end

function entity:isDone() -- has served its purpose
   if self.done then 
      return true
   else
      return false
   end
end

function entity:finish()
   self.done = true
end

function entity:contact(args)
   effects = {}
   if self.kind == 'none' then
      effects.land = true
      return effects 
   end
   if self.kind == 'item' then 
      if args.axis == 'y' and args.y < 0 then   --hit from below 
         effects.score = 100
         effects.health = 30
         self:finish()
         return effects
      elseif args.axis == 'y' then
         effects.land = true
      end
   elseif self.kind == 'enemy' then
      if args.axis == 'y' and args.y > 0 then --hit from above
         effects.score = 300
         self:finish()
         return effects
      else
         effects.damage = 5
      end
   end
   return effects
end

function entity:update(dt)
end

function entity:draw()
   --invisible entity
   if self.kind == 'none' then
      --do nothing
   --dummy drawing, blocks
   elseif self.image == nil then
      if self.kind == 'enemy' then
        love.graphics.setColor(255,0,0)
      elseif self.kind == 'item' then
         love.graphics.setColor(0,255,0)
      end
      love.graphics.rectangle('fill', self.x,self.y,self.w,self.h)
      love.graphics.setColor(255,255,255)
   else
      love.graphics.draw(self.image, self.x, self.y)
   end
end


