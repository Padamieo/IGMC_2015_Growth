
debug = true

gamestate = require "resources.gamestate"

--load in lick for better development
lick = require "resources.lick"
lick.reset = true

--define game states and functions to be included
menu = require "menu"
--game = require "game"

camera = require "camera"

function love.load()
    gamestate.registerEvents()
    --gamestate.switch(menu)
    gamestate.switch(game)
end

--following to go in game.lua but bellow for development
game = {}
-- Load some default values for our rectangle.
function game:enter()
  love.graphics.setBackgroundColor( 0, 10, 25 )

  x, y, w, h = 20, 20, 60, 20;
  g = 1

  world = {}
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  --let's create a ball

  pitch = { x = 0, y = 0, img = nil }
  pitch.img = love.graphics.newImage('img/pitch.jpeg')

  objects = {} -- table to hold all our physical objects
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 200, 200, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape( 20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0.9) --let the ball bounce

  player = { x = 0, y = 0, speed = 80, image = nil }
  player.image = love.graphics.newImage('img/player.png')
  player.body = love.physics.newBody(world, 0, 0, "dynamic")
  player.shape = love.physics.newRectangleShape(player.image:getWidth(), player.image:getHeight())
  player.fixture = love.physics.newFixture(player.body, player.shape)


end

-- Increase the size of the rectangle every frame.
function game:update(dt)

  world:update(dt) --this puts the world into motion

  if love.keyboard.isDown('escape') then
    love.event.push("quit")
  end

  --player.body:applyForce( 0, 0 )

  if love.keyboard.isDown('left','a') then
    player.body:setX(player.body:getX() - (player.speed*dt))
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

  camera:scale(g) -- zoom by 3
  spacey = (love.graphics.getHeight()/2)*-1
  spacex = (love.graphics.getWidth()/2)*-1
  camera:setPosition(player.body:getX()+spacex, player.body:getY()+spacey)

end

-- Draw a coloured rectangle.
function game:draw()
  camera:set()
  love.graphics.setColor(250, 250, 250);
  --print()
  love.graphics.draw(pitch.img, (pitch.img:getHeight()/2)*-0.1, ((pitch.img:getWidth()/2)*-0.1))

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
