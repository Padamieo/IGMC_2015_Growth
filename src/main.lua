
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

-- orders y depth
function orderY(a,b)
  return a[2] < b[2]
end

--determines distance from figures
function distance(value,value2)
  d = value - value2
  d = math.abs(d)
  return d
end


-- Load some default values for our rectangle.
function game:enter()
  love.graphics.setBackgroundColor( 0, 10, 25 )

  x, y, w, h = 20, 20, 60, 20;

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
  objects.ball.body:setMass(0.6)

--[[
--probably needs to be rectangle
  objects.wall = {}
  objects.wall.body = love.physics.newBody(world, 1080, 200, "dynamic")
  objects.wall.shape = love.physics.newEdgeShape( 1080, 600, 1080, -600 )
  objects.wall.fixture = love.physics.newFixture(objects.wall.body, objects.wall.shape, 1)
  objects.wall.fixture:setRestitution(0.9)
  objects.wall.body:setMass(0.6)
]]--

    player = { x = 0, y = 0, speed = 100, image = nil }
    --player.image = love.graphics.newImage('img/player.png')
    player.image = love.graphics.newImage('img/player_placeholder.png');
    bg = anim8.newGrid(350, 350, player.image:getWidth(), player.image:getHeight())
    player.anim = {
      s = anim8.newAnimation(bg('1-1', 1), 0.1),
        se = anim8.newAnimation(bg('2-2', 1), 0.1),
      e = anim8.newAnimation(bg('3-3', 1), 0.1),
        ne = anim8.newAnimation(bg('4-4', 1), 0.1),
      n = anim8.newAnimation(bg('5-5', 1), 0.1),
        nw = anim8.newAnimation(bg('6-6', 1), 0.1),
      w = anim8.newAnimation(bg('7-7', 1), 0.1),
        sw = anim8.newAnimation(bg('8-8', 1), 0.1)
    }

    player.body = love.physics.newBody(world, 100, 100, "dynamic")
    --player.shape = love.physics.newRectangleShape(player.image:getWidth(), player.image:getHeight())
    player.box = love.physics.newRectangleShape(175, 350)
    player.fixture = love.physics.newFixture(player.body, player.box)



    yes = { x = 0, y = 0, speed = 100, image = nil }
    --player.image = love.graphics.newImage('img/player.png')
    yes.image = love.graphics.newImage('img/test.png');

  --these will be avatars
  p = love.graphics.newImage('img/test_image.png')
  pp = {}
  pp[1] = {550,370}
  pp[2] = {220,390}
  pp[3] = {600,410}
  pp[4] = {300,450}
  pp[5] = {400,530}

end

--Increase the size of the rectangle every frame.
function game:update(dt)

  table.sort(pp, orderY)
  --physics
  world:update(dt)

  if love.keyboard.isDown('escape') then
    love.event.push("quit")
  end

  --allowing for user entered controlls later
  keyboard_set = {
    s = 'down',
    e = 'right',
    n = 'up',
    w = 'left'
  }

  --character tontrols gotoFrame problem for animation
  --player.body:applyForce( 0, 0 )
  if love.keyboard.isDown('left','a') then

    --player.body:applyForce( -100, 0 )
    --player.body:setLinearVelocity( -player.speed, 0 )
    player.body:setX(player.body:getX() - (player.speed*dt))
    player.dir = 'w'

  elseif love.keyboard.isDown('right','d') then
    --player.body:applyForce( 100, 0 )
    --player.body:setLinearVelocity( player.speed, 0 )
    player.body:setX(player.body:getX() + (player.speed*dt))
    player.dir = 'e'
  else
    --player.body:setLinearVelocity( 0.9*dt, 0 )
    player.dir = ''

  end

  if love.keyboard.isDown('up','w') then
      player.body:setY(player.body:getY() - (player.speed*dt))
      player.dir = 'n'
  elseif love.keyboard.isDown('down','s') then
      player.body:setY(player.body:getY() + (player.speed*dt))
      player.dir = 's'
  end


  --kick action
  if love.keyboard.isDown('k') then
    --boo = player.body:getAngle()
    --print(boo)

    xp, yp = player.body:getPosition( )
    xb, yb = objects.ball.body:getPosition( )
    --objects.ball.body:applyForce( 100, 0 )

    xx = distance(xp,xb)
    yy = distance(yp,yb)

    angle = math.atan2(yp - yb, xp - xb)
    --print(angle)


    if xx < 500 and yy < 500 then
      print("banana factory")
      xf = math.sin(math.rad(angle)) * 1
      yf = math.cos(math.rad(angle)) * 1
      print(xf)

      objects.ball.body:applyForce( yf, xf )
      --objects.ball.body:applyAngularImpulse( angle )
      --objects.ball.body:applyLinearImpulse( xpi, ypi ) --this is definatly wrong

    end

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
  --camera:setPosition(player.body:getX()+spacex, player.body:getY()+spacey)
  camera:setPosition(objects.ball.body:getX()+spacex, objects.ball.body:getY()+spacey)
  --player.body:applyForce( 0, 0 )

  --update animation
  if player.dir == 'w' then
    player.anim.w:update(dt)
  elseif player.dir == 'e' then
    player.anim.e:update(dt)
  elseif player.dir == 'n' then
    player.anim.n:update(dt)
  elseif player.dir == 's' then
    player.anim.s:update(dt)
  else
    player.anim.s:update(dt)
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

  love.graphics.draw(yes.image, 1, 1)

  --love.graphics.draw(player.img, player.x, player.y)
  --player.anim.stand:draw(player.image, player.body:getX(), player.body:getY(), player.body:getAngle(),  1, 1, 175, 175)

    if player.dir == 'w' then
      player.anim.w:draw(player.image, player.body:getX(), player.body:getY(), 0,  1, 1, 175, 175)
    elseif player.dir == 'e' then
      player.anim.e:draw(player.image, player.body:getX(), player.body:getY(), 0,  1, 1, 175, 175)
    elseif player.dir == 'n' then
      player.anim.n:draw(player.image, player.body:getX(), player.body:getY(), 0,  1, 1, 175, 175)
    elseif player.dir == 's' then
      player.anim.s:draw(player.image, player.body:getX(), player.body:getY(), 0,  1, 1, 175, 175)
    else
      player.anim.s:draw(player.image, player.body:getX(), player.body:getY(), 0,  1, 1, 175, 175)
    end

    --love.graphics.rectangle('fill', player.body:getX(), player.body:getY(), 10, 10);

  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  camera:unset()
  --love.graphics.rectangle('fill', 400, 80, w, h); -- gui not set by camera
end
