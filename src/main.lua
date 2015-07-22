
debug = true

gamestate = require "resources.gamestate"

--load in lick for better development
lick = require "resources.lick"
lick.reset = true

--define game states and functions to be included
menu = require "menu"
--game = require "game"

camera = require "camera"
anim8 = require 'resources.anim8'

function love.load()
    gamestate.registerEvents()
    --gamestate.switch(menu)
    gamestate.switch(game)
end

--following to go in game.lua but bellow for development
game = {}

function orderY(a,b)
  return a[2] < b[2]
end




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


    player = { x = 0, y = 0, speed = 100, image = nil }
    --player.image = love.graphics.newImage('img/player.png')
    player.image = love.graphics.newImage('img/player_placeholder.png');
    bg = anim8.newGrid(350, 350, player.image:getWidth(), player.image:getHeight())
    player.anim = {
      stand = anim8.newAnimation(bg('1-5', 1), 0.1),
      down = anim8.newAnimation(bg('5-7', 1), 0.5),
      up = anim8.newAnimation(bg('6-7', 1), 0.1)
    }

    player.body = love.physics.newBody(world, 100, 100, "dynamic")
    --player.shape = love.physics.newRectangleShape(player.image:getWidth(), player.image:getHeight())
    player.box = love.physics.newRectangleShape(175, 350)
    player.fixture = love.physics.newFixture(player.body, player.box)

  --these will be avatars
  p = love.graphics.newImage('img/test_image.png')
  pp = {}
  pp[1] = {550,370}
  pp[2] = {220,390}
  pp[3] = {600,410}
  pp[4] = {300,450}
  pp[5] = {400,530}

end

-- Increase the size of the rectangle every frame.
function game:update(dt)

  table.sort(pp, orderY)
  --physics
  world:update(dt)

  if love.keyboard.isDown('escape') then
    love.event.push("quit")
  end

  --character tontrols gotoFrame problem for animation
  --player.body:applyForce( 0, 0 )
  if love.keyboard.isDown('left','a') then
    --player.body:applyForce( -100, 0 )
    --player.body:setLinearVelocity( -player.speed, 0 )
    player.body:setX(player.body:getX() - (player.speed*dt))
    player.dir = 'right'
  elseif love.keyboard.isDown('right','d') then
    --player.body:applyForce( 100, 0 )
    --player.body:setLinearVelocity( player.speed, 0 )
    player.body:setX(player.body:getX() + (player.speed*dt))
    player.dir = 'left'
  else
      player.body:setLinearVelocity( 0.9*dt, 0 )
      player.dir = ''
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
  camera:scale(g)

  spacey = (love.graphics.getHeight()/2)*-1
  spacex = (love.graphics.getWidth()/2)*-1
  camera:setPosition(player.body:getX()+spacex, player.body:getY()+spacey)

  --player.body:applyForce( 0, 0 )

  --update animation
  if player.dir == 'left' then
    player.anim.up:update(dt)
  elseif player.dir == 'right' then
    player.anim.down:update(dt)
  else
    player.anim.stand:update(dt)
  end

end

-- draw to the game state
function game:draw()
  camera:set()
  love.graphics.setColor(250, 250, 250);

  love.graphics.draw(pitch.img, (pitch.img:getWidth()/2)*-1, (pitch.img:getHeight()/2)*-1)

  for i,v in ipairs(pp) do
    love.graphics.draw(p, pp[i][1] - p:getWidth()/2, pp[i][2]-p:getHeight())
  end

  --love.graphics.draw(player.img, player.x, player.y)
  --player.anim.stand:draw(player.image, player.body:getX(), player.body:getY(), player.body:getAngle(),  1, 1, 175, 175)

    if player.dir == 'left' then
      player.anim.up:draw(player.image, player.body:getX(), player.body:getY(), player.body:getAngle(),  1, 1, 175, 175)
    elseif player.dir == 'right' then
      player.anim.down:draw(player.image, player.body:getX(), player.body:getY(), player.body:getAngle(),  1, 1, 175, 175)
    else
      player.anim.stand:draw(player.image, player.body:getX(), player.body:getY(), player.body:getAngle(),  1, 1, 175, 175)
    end
--  love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), 20)

  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  camera:unset()
  --love.graphics.rectangle('fill', 400, 80, w, h); -- gui not set by camera
end
