
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
  return a.body:getY() < b.body:getY()
end

--determines distance from figures
function distance(value,value2)
  d = value - value2
  d = math.abs(d)
  return d
end


function beginContact(a, b, coll)
  local a_name = a:getUserData()
  local b_name = b:getUserData()

  if a_name == "A" then
    if b_name == "Ball" then
      print("A goal")
      team_a_score = team_a_score + 1
    end
  end

  if b_name == "A" then
    if a_name == "Ball" then
      print("A goal")
      team_a_score = team_a_score + 1
    end
  end



  if a_name == "B" then
    if b_name == "Ball" then
      print("B goal")
      team_b_score = team_b_score + 1
    end
  end

  if b_name == "B" then
    if a_name == "Ball" then
      print("B goal")
      team_b_score = team_b_score + 1
    end
  end

end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)

end


-- Load some default values for our rectangle.
function game:enter()

  love.graphics.setBackgroundColor( 0, 10, 25 )

  g = 1

  world = {}
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  --text = "0-0"
  team_a_score = 0;
  team_b_score = 0;
  text = "0 - 0"
  --let's create a ball

  pitch = { x = 0, y = 0, img = nil }
  pitch.img = love.graphics.newImage('img/pitch.jpeg')

  objects = {} -- table to hold all our physical objects
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 0, 0, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape( 20 ) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0.9) --let the ball bounce
  objects.ball.fixture:setUserData("Ball")
  objects.ball.body:setMass(0.5)

  --probably needs to be rectangle
  objects.wall = {}
  objects.wall.body = love.physics.newBody(world, -1480, -0, "static")
  objects.wall.shape = love.physics.newRectangleShape(0, 0, 10, 1120)
  objects.wall.fixture = love.physics.newFixture(objects.wall.body, objects.wall.shape, 5) -- A higher density gives it more mass.

  objects.wall2 = {}
  objects.wall2.body = love.physics.newBody(world, 1480, -0, "static")
  objects.wall2.shape = love.physics.newRectangleShape(0, 0, 10, 1120)
  objects.wall2.fixture = love.physics.newFixture(objects.wall2.body, objects.wall2.shape, 5) -- A higher density gives it more mass.

  objects.wall3 = {}
  objects.wall3.body = love.physics.newBody(world, 0, 580, "static")
  objects.wall3.shape = love.physics.newRectangleShape(0, 0, 2980, 10)
  objects.wall3.fixture = love.physics.newFixture(objects.wall3.body, objects.wall3.shape, 5) -- A higher density gives it more mass.

  objects.wall4 = {}
  objects.wall4.body = love.physics.newBody(world, 0, -580, "static")
  objects.wall4.shape = love.physics.newRectangleShape(0, 0, 2980, 10)
  objects.wall4.fixture = love.physics.newFixture(objects.wall4.body, objects.wall4.shape, 5) -- A higher density gives it more mass.

  --goals for scoring
  objects.goal_A = {}
  objects.goal_A.body = love.physics.newBody(world, 1480, -0, "static")
  objects.goal_A.shape = love.physics.newRectangleShape(0, 0, 50, 300)
  objects.goal_A.fixture = love.physics.newFixture(objects.goal_A.body, objects.goal_A.shape, 5) -- A higher density gives it more mass.
  objects.goal_A.fixture:setUserData("A")

  objects.goal_B = {}
  objects.goal_B.body = love.physics.newBody(world, -1480, -0, "static")
  objects.goal_B.shape = love.physics.newRectangleShape(0, 0, 50, 300)
  objects.goal_B.fixture = love.physics.newFixture(objects.goal_B.body, objects.goal_B.shape, 5) -- A higher density gives it more mass.
  objects.goal_B.fixture:setUserData("B")

  --define selectable characters
  characters = {
    default = { height = 100, width = 100, image = 'img/player_placeholder.png' }
  }

  --this is roster of listed players
  character = {}
    character[1] = {x = 300, y = 0, c = "K", team = 0}
    character[2] = {x = -300, y = -0, c = 1, team = 1}

  player = {}
  bg = {}

  for i,v in ipairs(character) do
    player[i] = { x = character[i].x, y = character[i].y, c = character[i].c, speed = 100, image = nil }
    player[i].image = love.graphics.newImage('img/player_placeholder.png');
    bg[i] = anim8.newGrid(350, 350, player[i].image:getWidth(), player[i].image:getHeight())
    player[i].anim = {
      s = anim8.newAnimation(bg[i]('1-1', 1), 0.1),
        se = anim8.newAnimation(bg[i]('2-2', 1), 0.1),
      e = anim8.newAnimation(bg[i]('3-3', 1), 0.1),
        ne = anim8.newAnimation(bg[i]('4-4', 1), 0.1),
      n = anim8.newAnimation(bg[i]('5-5', 1), 0.1),
        nw = anim8.newAnimation(bg[i]('6-6', 1), 0.1),
      w = anim8.newAnimation(bg[i]('7-7', 1), 0.1),
        sw = anim8.newAnimation(bg[i]('8-8', 1), 0.1)
    }
    player[i].body = love.physics.newBody(world, player[i].x, player[i].y, "static")
    player[i].box = love.physics.newRectangleShape(100, 100)
    player[i].fixture = love.physics.newFixture(player[i].body, player[i].box)
  end

end

--Increase the size of the rectangle every frame.
function game:update(dt)

  --physics
  world:update(dt)

  table.sort(player, orderY)
  text = team_a_score.." - "..team_b_score


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

  for i,v in ipairs(player) do

    if player[i].c == "K" then
      --movement for keyboard character
      if love.keyboard.isDown('left','a') then
        --player.body:applyForce( -100, 0 )
        --player.body:setLinearVelocity( -player.speed, 0 )
        player[i].body:setX(player[i].body:getX() - (player[i].speed*dt))
        player[i].dir = 'w'
      elseif love.keyboard.isDown('right','d') then
        --player.body:applyForce( 100, 0 )
        --player.body:setLinearVelocity( player.speed, 0 )
        player[i].body:setX(player[i].body:getX() + (player[i].speed*dt))
        player[i].dir = 'e'
      else
        --player.body:setLinearVelocity( 0.9*dt, 0 )
        player[i].dir = ''
      end

      if love.keyboard.isDown('up','w') then
          player[i].body:setY(player[i].body:getY() - (player[i].speed*dt))
          player[i].dir = 'n'
      elseif love.keyboard.isDown('down','s') then
          player[i].body:setY(player[i].body:getY() + (player[i].speed*dt))
          player[i].dir = 's'
      end
      --movement end

      --kick action
      if love.keyboard.isDown('k') then
        --boo = player.body:getAngle()

        xp, yp = player[i].body:getPosition( )
        xb, yb = objects.ball.body:getPosition( )
        --objects.ball.body:applyForce( 100, 0 )

        xd = distance(xp,xb)
        yd = distance(yp,yb)

        f = 100

        d = math.sqrt((xd^2)+(yd^2))

        if d < 250 then

          pos = xp - xb
          print(pos)

          comp = (yp - yb) / (xp - xb)

          rad = math.atan( comp )

          --ball_mass = objects.ball.body:getMass()
          --ac = f / ball_mass

          v = f/d

          if pos > 0 then
            b = -1
          else
            b = 1
          end

          xf = b*math.cos(rad)*v
          yf = b*math.sin(rad)*v

          objects.ball.body:applyLinearImpulse( xf, yf ) --this is definatly wrong


        end
      end --kick end

      --experiment to determine rotation
      if love.keyboard.isDown('l') then
        --[[
        ang = player[i].body:getAngle()
        print(ang)
        new_ang = ang+0.001;
        player[i].body:setAngle(new_ang)
        ]]--
        player[i].body:setAngle(0)
      else
player[i].body:setAngle(0)
      end

    else
      --xbox360 controller movments for each
    end

  end--end iteration of players


  --zoom in and out, good start, It needs to be based on distance
  --[[
  xp, yp = player[1].body:getPosition( )
  xb, yb = objects.ball.body:getPosition( )
  width_distance = distance(xp,xb)
  yd = distance(yp,yb)
  width = love.graphics.getWidth( )
  width = width/2

  if width < width_distance then
    if g < 2 then
      g = g + dt
    else
      g = 2
    end
  else
    if g > 1 then
      g = g - dt
    else
      g = 1
    end
  end
  ]]--


  camera:setScale(g, g)

  spacey = (love.graphics.getHeight()/2)*-1
  spacex = (love.graphics.getWidth()/2)*-1
  --temp camera setup (currency causes jerky follow)

  for i,v in ipairs(player) do
    if player[i].c == "K" then
      camera:setPosition(player[i].body:getX()+spacex, player[i].body:getY()+spacey)
    end
  end

  --camera:setPosition(objects.ball.body:getX()+spacex, objects.ball.body:getY()+spacey)

  --iteration for players animation direction
  for i,v in ipairs(player) do
    if player[i].dir == 'w' then
      player[i].anim.w:update(dt)
    elseif player[i].dir == 'e' then
      player[i].anim.e:update(dt)
    elseif player[i].dir == 'n' then
      player[i].anim.n:update(dt)
    elseif player[i].dir == 's' then
      player[i].anim.s:update(dt)
    else
      player[i].anim.s:update(dt)
    end
  end


end

-- draw to the game state
function game:draw()
  camera:set()

  love.graphics.setColor(250, 250, 250);

  love.graphics.draw(pitch.img, (pitch.img:getWidth()/2)*-1, (pitch.img:getHeight()/2)*-1)

  love.graphics.polygon("fill", objects.wall.body:getWorldPoints(objects.wall.shape:getPoints()))
  love.graphics.polygon("fill", objects.wall2.body:getWorldPoints(objects.wall2.shape:getPoints()))
  love.graphics.polygon("fill", objects.wall3.body:getWorldPoints(objects.wall3.shape:getPoints()))
  love.graphics.polygon("fill", objects.wall4.body:getWorldPoints(objects.wall4.shape:getPoints()))

  love.graphics.setColor(250, 50, 50);
  love.graphics.polygon("fill", objects.goal_A.body:getWorldPoints(objects.goal_A.shape:getPoints()))
  love.graphics.polygon("fill", objects.goal_B.body:getWorldPoints(objects.goal_B.shape:getPoints()))

  love.graphics.setColor(250, 250, 250);

  local drawn = false -- true when the character has been drawn

  for i,v in ipairs(player) do

    if not drawn and player[i].body:getY() > objects.ball.body:getY() then
        love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
        drawn = true
    end

    if player[i].dir == 'w' then
      player[i].anim.w:draw(player[i].image, player[i].body:getX(), player[i].body:getY(), player[i].body:getAngle(),  1, 1, 175, 175)
    elseif player[i].dir == 'e' then
      player[i].anim.e:draw(player[i].image, player[i].body:getX(), player[i].body:getY(), player[i].body:getAngle(),  1, 1, 175, 175)
    elseif player.dir == 'n' then
      player[i].anim.n:draw(player[i].image, player[i].body:getX(), player[i].body:getY(), player[i].body:getAngle(),  1, 1, 175, 175)
    elseif player.dir == 's' then
      player[i].anim.s:draw(player[i].image, player[i].body:getX(), player[i].body:getY(), player[i].body:getAngle(),  1, 1, 175, 175)
    else
      player[i].anim.s:draw(player[i].image, player[i].body:getX(), player[i].body:getY(), player[i].body:getAngle(),  1, 1, 175, 175)
    end

  end

  if not drawn then -- if the person is below all objects it won't be drawn within the for loop
     love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
  end

  --love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball


  camera:unset()
  --love.graphics.rectangle('fill', 400, 80, w, h); -- gui not set by camera
  love.graphics.print(text, 10, 10)
end
