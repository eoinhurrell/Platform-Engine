Achievements = {}
notification_time = 2
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
		justUnlocked = nil,  -- most recent achievement
		notification = nil,  --achievement being used
		notifying = false,
		notify_time = 2, --ms
		notif_width = 160,
		notif_height= 100,
		slide_time = 0.2
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
		self.justUnlocked = self.achieves[id]
		--anything else
	end
end
 
-- Set whether to notify on last achievement, and for how long.
function Achievements:update(dt)
	if self.notifying then
		self.notify_time = self.notify_time - dt
		--if self.slide_time = self.slide_time - dt 
		if self.notify_time <= 0 then
			self.notifying = false
			self.notify_time = notification_time
			self.slide_time = 0.2
		end
	end
	if self.justUnlocked ~= nil then
		self.notification = self.justUnlocked
		self.justUnlocked = nil
		self.notifying = true
	end
end

-- Draw achievement notification
function Achievements:draw()
	if self.notifying then
		--display achievement info
		self:display()
	end
end

function Achievements:display()
	local height=love.graphics.getHeight()
	local width=love.graphics.getWidth()
	love.graphics.setColor(126,126,126)
	love.graphics.rectangle("fill",width-160,height-100,160,100)
	love.graphics.setColor(0,0,0)
	love.graphics.print(self.notification.name,width-110,height-70)
	love.graphics.print(self.notification.desc,width-110,height-50)
	love.graphics.print(self.notification.img,width-110,height-30)
	love.graphics.setColor({255,255,255})
end
