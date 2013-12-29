--https://github.com/karai17/love2d-input-manager/blob/master/input.lua
--https://github.com/mrcharles/love2d-xinput - XBOX support
Menu = {}

-- Constructor
function Menu:new(loc_x,loc_y)
    -- define our parameters here
    local object = {
		items	= {},
		selectable = true,
		selected = 1,
		x = loc_x,
		y = loc_y,
		width = 0,
		height = 0
    }
    setmetatable(object, { __index = Menu })
    return object
end

function Menu:addItem(item) --mane:addItem{name='Name',action=function()end}
	table.insert(self.items,item)
	self.height = #self.items * 25 + 50
	if self.height > love.graphics.getHeight() then
		error('menu too tall')
	end
	if #item.name*7+50 > self.width then
		self.width = #item.name*7+50
	end
end

function Menu:select()
	if self.items[self.selected].action then
		self.items[self.selected]:action()
	end
end


function Menu:selectNext()
	self.selected = self.selected + 1
	if self.selected > #self.items then
		self.selected = 1
	end
end

function Menu:selectPrevious()
	self.selected = self.selected - 1
	if self.selected < 1 then
		self.selected = #self.items
	end
end

function Menu:setSelectable(is_selectable)
	self.selectable = is_selectable
end

function Menu:draw()
	local screen_width = love.graphics.getWidth()
	local screen_height = love.graphics.getHeight()
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(0,0,0)
	local offset = 30
	for i,item in pairs(self.items) do
		love.graphics.print(item.name, self.x + 25, self.y+offset)
		if i == self.selected and self.selectable then 
			-- Arrow highlighter
			love.graphics.print(">", self.x + 10, self.y+offset)
			--Underline
			--local chars = (self.width-50)/7
			--love.graphics.print(string.rep("_",chars), self.x + 25, self.y+offset+1)
		end
		offset = offset + 25
	end
	love.graphics.setColor(255,255,255)	

end

function Menu:update(dt)
	--unneeded
end