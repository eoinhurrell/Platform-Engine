function assetload()
   image = love.graphics.newImage("assets/tileset.png" )
   image:setFilter("nearest", "linear") -- this "linear filter" removes some artifacts if we were to scale the tiles
   w = image:getWidth()
   h = image:getHeight()
   elems = {}
   --ground sprites are all at y=0
   elems[0] = love.graphics.newQuad(   0,   0,  32,  32,w,h)
   elems[1] = love.graphics.newQuad(  32,   0,  32,  32,w,h)
   elems[2] = love.graphics.newQuad(  64,   0,  32,  32,w,h)
   elems[3] = love.graphics.newQuad(  96,   0,  32,  32,w,h)
   elems[4] = love.graphics.newQuad( 128,   0,  32,  32,w,h)
end
