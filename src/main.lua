debug = true

--load in lick for better development
lick = require "resources.lick"
lick.reset = true

love.graphics.setBackgroundColor( 0, 10, 25 )

local world = {} -- the empty world-state

camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

function camera:mousePosition()
  return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

--camera.lua require("camera")

-- Load some default values for our rectangle.
function love.load()

    player = { x = 200, y = 200, speed = 150, img = nil }
    player.img = love.graphics.newImage('img/player.png')

    x, y, w, h = 20, 20, 60, 20;
g = 1;


end

-- Increase the size of the rectangle every frame.
function love.update(dt)

  if love.keyboard.isDown('left','a') then
    --if player.x > 0 then -- binds us to the map
      player.x = player.x - (player.speed*dt)
    --end
  elseif love.keyboard.isDown('right','d') then
    --if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
      player.x = player.x + (player.speed*dt)
    --end
  end

  if love.keyboard.isDown('up','w') then
    --if player.y > 0 then -- binds us to the map
      player.y = player.y - (player.speed*dt)
    --end
  elseif love.keyboard.isDown('down','s') then
    --if player.y < (love.graphics.getHeight() - player.img:getHeight()) then
      player.y = player.y + (player.speed*dt)
    --end
  end

    --zoom is broken
    if love.keyboard.isDown('-') then
      g = g - 0.01
    elseif love.keyboard.isDown('=') then
      g = g + 0.01
    else
      g = g
    end

    camera:scale(g) -- zoom by 3
    spacex = (player.img:getHeight()/2) - (love.graphics.getHeight()/2)
    spacey = (player.img:getWidth()/2) - (love.graphics.getWidth()/2)

    camera:setPosition(player.x+spacey, player.y+spacex)
    --g = g + 0.001;
end

-- Draw a coloured rectangle.
function love.draw()
    camera:set()
    love.graphics.setColor(0, 88, 200);
    love.graphics.rectangle('fill', x, y, w, h);
    love.graphics.rectangle('fill', 80, 80, w, h);
    love.graphics.rectangle('fill', 250, 250, w, h);
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(player.img, player.x, player.y)
    camera:unset()
    --love.graphics.rectangle('fill', 400, 80, w, h); -- gui not set by camera
end
