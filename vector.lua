vector = {}
vector.__index=vector

function vector.load(x,y)
   local ply = {}             -- our new object
   ply.x = x
   ply.y = y
   setmetatable(ply,vector)  -- make Account handle lookup
   return ply
end

function isvector(v)
	return getmetatable(v) == vector
end

function vector:clone()
	return vector.load(self.x, self.y)
end

function vector.__add(a,b)
   assert(isvector(a) and isvector(b), "Add: wrong argument types (<vector> expected)")
	return vector.load(a.x+b.x, a.y+b.y)
end

function vector.__sub(a,b)
   assert(isvector(a) and isvector(b), "Sub: wrong argument types (<vector> expected)")
   return vector.load(a.x - b.x, a.y - b.y)
end

