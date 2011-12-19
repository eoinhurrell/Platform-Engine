require('entity')
require('enemy')

world = {}
world.__index=world

function world.load()
   local wor = {}
   setmetatable(wor,world)
   wor.image = love.graphics.newImage("assets/world.png")
   wor.mapWidth = 60
   wor.mapHeight = 40
   wor.entities = {}
   wor.tileQuads={}
   
   wor.map = {}
   for x=1,wor.mapWidth do
     wor.map[x] = {}
     for y=1,wor.mapHeight do
       wor.map[x][y] = math.random(0,3)
     end
   end

   wor.mapX = 1
   wor.mapY = 1
   wor.tilesDisplayWidth = 32
   wor.tilesDisplayHeight = 32
  
   wor.zoomX = 1
   wor.zoomY = 1
   wor.tilesetImage = love.graphics.newImage("assets/tileset.png" )
   wor.tilesetImage:setFilter("nearest", "linear") -- this "linear filter" removes some artifacts if we were to scale the tiles
   wor.tileSize = 32
   -- grass
   wor.tileQuads[0] = love.graphics.newQuad(0 * wor.tileSize, 0 * wor.tileSize, wor.tileSize, wor.tileSize,
     wor.tilesetImage:getWidth(), wor.tilesetImage:getHeight())
   -- kitchen floor tile
   wor.tileQuads[1] = love.graphics.newQuad(1 * wor.tileSize, 0 * wor.tileSize, wor.tileSize, wor.tileSize,
     wor.tilesetImage:getWidth(), wor.tilesetImage:getHeight())
   -- parquet flooring
   wor.tileQuads[2] = love.graphics.newQuad(2 * wor.tileSize, 0 * wor.tileSize, wor.tileSize, wor.tileSize,
     wor.tilesetImage:getWidth(), wor.tilesetImage:getHeight())
   -- middle of red carpet
   wor.tileQuads[3] = love.graphics.newQuad(3 * wor.tileSize, 9 * wor.tileSize, wor.tileSize, wor.tileSize,
     wor.tilesetImage:getWidth(), wor.tilesetImage:getHeight())

   wor.tilesetLevel = love.graphics.newSpriteBatch(wor.tilesetImage, wor.tilesDisplayWidth * wor.tilesDisplayHeight)
   wor.tilesetBack = love.graphics.newSpriteBatch(wor.tilesetImage, wor.tilesDisplayWidth * wor.tilesDisplayHeight)
   wor.tilesetFore = love.graphics.newSpriteBatch(wor.tilesetImage, wor.tilesDisplayWidth * wor.tilesDisplayHeight)
   --entities!
   table.insert(wor.entities, enemy.load{score=1000,x=500,y=10,img='assets/enemy-slug.png'})
   table.insert(wor.entities, entity.load{kind='item',x=150,y=-60,w=100,h=100})
   table.insert(wor.entities, entity.load{kind='item',x=350,y=-110,w=50,h=50})
   table.insert(wor.entities, entity.load{kind='none',x=550,y=-110,w=50,h=50})
   table.insert(wor.entities, entity.load{kind='item',x=750, y=-160,w=600,h=40})
   table.insert(wor.entities, entity.load{kind='none',x=0, y=64,w=1600,h=640})
   return wor
end

function world:updatetilesetBack()
  self.tilesetBack:clear()
  for x=0, self.tilesDisplayWidth-1 do
    for y=0, self.tilesDisplayHeight-1 do
      self.tilesetBack:addq(self.tileQuads[self.map[x+self.mapX][y+self.mapY]], x*self.tileSize, y*self.tileSize)
    end
  end
end


function world:getCollosionObjects()
   return self.colliders
end

function world:getEntities()
   return self.entities
end


function world:update(dt)
   self:updateLevel(dt)
   self:updateBackground(dt)
   self:updateForeground(dt)
end

function world:updateLevel(dt) 
   for i,v in ipairs(self.entities) do 
      v.update(dt)
      if v:isDone() then
         table.remove(self.entities,i)
      end
   end
   self.tilesetLevel:clear()
   for x=0, self.tilesDisplayWidth-1 do
      for y=2, self.tilesDisplayHeight-1 do
         if y == 2 then
            self.tilesetLevel:addq(self.tileQuads[1], x*self.tileSize, y*self.tileSize)
         else
            self.tilesetLevel:addq(self.tileQuads[0], x*self.tileSize, y*self.tileSize)
         end
      end
   end
end


function world:updateBackground(dt) 
   self.tilesetBack:clear()
   for x=0, self.tilesDisplayWidth-1 do
      for y=0, self.tilesDisplayHeight-1 do
         self.tilesetBack:addq(self.tileQuads[3], x*self.tileSize, y*self.tileSize)
      end
   end
end

function world:updateForeground(dt)
   self.tilesetFore:clear()
   for x=0, self.tilesDisplayWidth-1 do
      for y=3, self.tilesDisplayHeight-1 do
         if math.random(0,4) == 0 then
            self.tilesetFore:addq(self.tileQuads[2], x*self.tileSize, y*self.tileSize)
         end
      end
   end
end

function world:drawLevel()
   --self:updateLevel()
   love.graphics.setColor(51,24,25)
   love.graphics.rectangle('fill', 0,64,1600,640)
   love.graphics.setColor(255,255,255)
   love.graphics.draw(self.tilesetLevel)
   --junk
   for i,v in ipairs(self.entities) do 
       v:draw()
   end
end

function world:drawBackground()
   --self:updateBackground()
   love.graphics.setColor(51,204,255)
   love.graphics.rectangle('fill', -10000,-10000,84000,84000)
   love.graphics.setColor(255,255,255)
   love.graphics.draw(self.tilesetBack)
end

function world:drawForeground()
   --self:updateForeground()
   love.graphics.draw(self.tilesetFore)
end

function world:draw()
end

