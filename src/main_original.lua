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
  --physics
  --love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  --let's create a ball
  objects = {} -- table to hold all our physical objects
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 200, 200, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape( 20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0.9) --let the ball bounce

  player = { x = 200, y = 200, speed = 250, img = nil }
  --player.img = love.graphics.newImage('img/player.png')

  --player = {}
  player.image = love.graphics.newImage('img/player.png')
  player.body = love.physics.newBody(world, 200, 200, "dynamic")
  player.shape = love.physics.newRectangleShape(player.image:getWidth(), player.image:getHeight())
  player.fixture = love.physics.newFixture(player.body, player.shape)

  x, y, w, h = 20, 20, 60, 20;
  g = 1;
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
  --print(player.body:getY())


  --physics
  world:update(dt) --this puts the world into motion

  if love.keyboard.isDown('left','a') then
    player.body:setX(player.body:getX() - (player.speed*dt))
    --player.body:applyForce( 200, 200 )

  elseif love.keyboard.isDown('right','d') then
      player.body:setX(player.body:getX() + (player.speed*dt))
  end

  if love.keyboard.isDown('up','w') then
      player.body:setY(player.body:getY() - (player.speed*dt))
  elseif love.keyboard.isDown('down','s') then
      player.body:setY(player.body:getY() + (player.speed*dt))
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
    spacex = (player.image:getHeight()) - (love.graphics.getHeight()/2)
    spacey = (player.image:getWidth()) - (love.graphics.getWidth()/2)
    camera:setPosition(player.body:getX()+spacey, player.body:getY()+spacex)

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
    --love.graphics.draw(player.img, player.x, player.y)
    love.graphics.draw(player.image, player.body:getX(), player.body:getY(), player.body:getAngle(),  1, 1, player.image:getWidth()/2, player.image:getHeight()/2)
  --  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), 20)

    love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

    camera:unset()
    --love.graphics.rectangle('fill', 400, 80, w, h); -- gui not set by camera
end
