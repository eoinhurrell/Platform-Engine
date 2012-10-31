Achievements = {}

notification_time = 200
--based on https://github.com/LiquidHelium/LoveAchievements/wiki/Additional-Config-Options
--[[ if needed, table copy function (unsure about the reference-y bits of copying to justUnlocked etc)
function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end
--]]
-- Constructor
function Achievements:new()
    -- define our parameters here
    local object = {
       achieves = {}, -- id = {name, desc, image, unlocked}
       justUnlocked = nil,  -- or most recent achievement
       notification = nil,  --achievement being used
       notifying = false,
       notifyTime = 200 --ms
    }
    setmetatable(object, { __index = Achievements })
    return object
end
 
function Achievements:register(id, name, description, image)
	--going to assume the person knows what they are doing, for now
	--table.insert(t, {id=id,name=name,desc=description,img=image,unlocked=false})
	self.achieves[id] = {name=name,desc=description,img=image,unlocked=false}
end

function Achievements:unlock(id)
	if not self.achieves[id].unlocked then
		self.achieves[id].unlocked = true
		self.justUnlocked = self.achieves[i]
		--anything else
	end
end
 
-- Set whether to notify on last achievement, and for how long.
function Achievements:update(dt)
	if self.justUnlocked != nil then
		self.notification = self.justUnlocked
		self.justUnlocked = nil
		self.notifying = true
	end
end

-- Draw achievement notification
function Achievements:draw(dt)
	if self.notifying then
		--display achievement info
		print self.notification.id .. ": " .. self.notification.name .. ", " .. self.notification.desc
		self.notifyTime -= dt
		if self.notifyTime <= 0 then
			self.notifying = false
			self.notifyTime = notification_time
		end
	end
end
