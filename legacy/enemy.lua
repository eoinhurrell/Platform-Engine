require('entity')

enemy = {}
enemy.__index=enemy

function enemy.load(info)
   -- first create the superclass
   local self = entity.load(info)
   -- rest of initialization here
   if info.score ~= nil then
      self.score = info.score
   else
      self.score = 300
   end
   self:setKind('enemy')
   --override methods
   self.contact = enemy.contact
   self.update = enemy.update
   return self 
end

function enemy:contact(args)
   if args.axis == 'y' and args.y > 0 then --hit from above
      effects.score = self.score
      self:finish()
   else
      effects.damage = 5
   end
   return effects
end

function enemy:update(dt)
   
end
