
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

require 'general' -- not sure this helps with speed and performance

function love.load()
    dt = 0
    p1joystick = nil
    gamestate.registerEvents()
    --gamestate.switch(menu)
    gamestate.switch(game)
end

--following to go in game.lua but bellow for development
game = {}

function love.joystickadded(joystick)
    p1joystick = joystick
    print("joystic")
end

function beginContact(a, b, coll)
  local a_name = a:getUserData()
  local b_name = b:getUserData()

  if a_name == "A" then
    if b_name == "Ball" then
      print("A goal")
      goal()
      team_a_score = team_a_score + 1
    end
  end

  if b_name == "A" then
    if a_name == "Ball" then
      print("A goal")
      goal()
      team_a_score = team_a_score + 1
    end
  end

  if a_name == "B" then
    if b_name == "Ball" then
      print("B goal")
      goal()
      team_b_score = team_b_score + 1
    end
  end

  if b_name == "B" then
    if a_name == "Ball" then
      print("B goal")
      goal()
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

--needs work
function screen_message(text)
  size = 150
  local h = love.graphics.getHeight()
  local w = love.graphics.getWidth()
  love.graphics.setNewFont(size)
  local length = string.len(text)
  offset = size*length

  ww = love.graphics:getHeight( text )

  love.graphics.print(text, (w/2)-(offset/2), h/2)
end

function goal()
  objects.ball.hide = 1

end

function is_int(n)
  return (type(n) == "number") and (math.floor(n) == n)
end

function positive_num(value)
  if value > 0 then
    value = value*-1
  end
  return value
end

function moveto(obj, x, y, dt)

  local reached = 0
  local vv = obj.roster
  local object = obj.body
  local this_width = characters[roster[vv].char].width
  local this_height = characters[roster[vv].char].height

  print(object:getX())

  if positive_num(object:getX()) <= positive_num(x)-this_width or positive_num(object:getX()) >= positive_num(x)+this_width then
    if object.speed ~= nil then
      temp = object:getX() + (dt * object.speed)*((x - object:getX()) / math.abs(x - object:getX()))
      object:setX(temp)
    else
      temp = object:getX() + (dt * 200)*((x - object:getX()) / math.abs(x - object:getX()))
      object:setX(temp)
    end
  else
    reached = reached + 1;
  end

  if positive_num(object:getY()) <= positive_num(y)-this_height or positive_num(object:getY()) >= positive_num(y)+this_height then
    if object.speed ~= nil then
      temp = object:getY() + (dt * object.speed)*((y - object:getX()) / math.abs(y - object:getX()))
      object:setY(temp)
    else
      temp = object:getY() + (dt * 200)*((y - object:getY()) / math.abs(y - object:getY()))
      object:setY(temp)
    end
  else
    reached = reached + 1;
  end

  if reached >= 2 then
    return true
  else
    return false
  end

end

-- Load some default values for our rectangle.
function game:enter()

  dt = 0 -- helps with speeding up on auto refresh

  love.graphics.setBackgroundColor( 0, 10, 25 )

  h = love.graphics.getHeight()
  w = love.graphics.getWidth()
  i = 1920 / w

  --i = 1;
  g = i

  world = {}
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  team_a_score = 0;
  team_b_score = 0;
  text = "0 - 0"

  font = love.graphics.newFont("Capture_it.ttf", 15)
  love.graphics.setFont(font)
  love.graphics.setNewFont(30)

  pitch = { x = 0, y = 0, img = nil }
  pitch.img = love.graphics.newImage('img/pitch.jpeg')

  objects = {} -- table to hold all our physical objects
  objects.ball = {hide = 0}
  objects.ball.body = love.physics.newBody(world, 0, 0, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape( 20 ) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(0.9) --let the ball bounce
  objects.ball.fixture:setUserData("Ball")
  objects.ball.body:setLinearDamping( 0.4 )
  objects.ball.body:setMass(0.009)

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
    default = { height = 100, width = 100, kick = 150, speed = 170, image = 'img/player_placeholder.png' }
  }

  --this is roster of listed players, will be built elsewhere
  roster = {}
    roster[1] = {x = 300, y = 0, c = "K", team = 0, char = "default"}
    roster[2] = {x = -300, y = -0, c = 1, team = 1, char = "default"}
    roster[3] = {x = -400, y = -300, c = "C", team = 1, char = "default"}

  player = {}
  bg = {}

  for i,v in ipairs(roster) do

    player[i] = { roster = i, x = roster[i].x, y = roster[i].y, c = roster[i].c, speed = characters[roster[i].char].speed, image = nil }
    player[i].image = love.graphics.newImage(characters[roster[i].char].image);
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
    player[i].shape = love.physics.newRectangleShape(characters[roster[i].char].height, characters[roster[i].char].width)
    player[i].fixture = love.physics.newFixture(player[i].body, player[i].shape)
  end

end


function game:update(dt)

  --moveto(objects.ball.body, 500, 500, dt)

  world:update(dt)
  table.sort(player, orderY)
  text = team_a_score.." - "..team_b_score

  if love.keyboard.isDown('escape') then
    love.event.push("quit")
  end

  xb, yb = objects.ball.body:getPosition( ) --ball x and y used in everything

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
        kick(player[i])
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

    elseif is_int(player[i].c) then
      --xbox360 controller movments for each
      if p1joystick ~= nil then

        local x = p1joystick:getGamepadAxis("leftx")
        if x > 0.2 then
          player[i].body:setX(player[i].body:getX() + (player[i].speed*dt))
          player[i].dir = 'e'
        elseif x < -0.2 then
          player[i].body:setX(player[i].body:getX() - (player[i].speed*dt))
          player[i].dir = 'w'
        else
          player[i].dir = ''
        end

        local y = p1joystick:getGamepadAxis("lefty")
        if y > 0.2 then
          player[i].body:setY(player[i].body:getY() + (player[i].speed*dt))
          player[i].dir = 's'
        elseif y < -0.2 then
          player[i].body:setY(player[i].body:getY() - (player[i].speed*dt))
          player[i].dir = 'n'
        end

        if p1joystick:getGamepadAxis("triggerright") > 0.2 then
          kick(player[i])
        end

      end
    else
      --ai stuff here
      local arrived = moveto(player[i], 500, 500, dt) -- this will just move c for computer controlled player to x y specifyed.
      print(arrived)
    end

  end--end iteration of players

  --zoom in and out, good start, It needs to be based on distance


  local spacey = ((love.graphics.getHeight()*g)/2)*-1
  local spacex = ((love.graphics.getWidth()*g)/2)*-1

  xs, ys = objects.ball.body:getPosition( )
  spacex = spacex-(xs/6)
  spacey = spacey-(ys/4)
  --temp camera setup (currency causes jerky follow)

  --ensure all active players are on screen
  for i,v in ipairs(player) do
   --if tonumber(player[i].c) ~= nil then
     -- check payer is within current screen zoom out if needed
   --end
  end

  --[[
  for i,v in ipairs(player) do
    if player[i].c == "K" then
      camera:setPosition(player[i].body:getX()+spacex, player[i].body:getY()+spacey)
    end
  end
  --]]


  camera:setScale(g, g) -- gg

  --find way to soften follow of camera maybe add delay
  camera:setPosition(objects.ball.body:getX()+spacex, objects.ball.body:getY()+spacey)

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
      draw_ball()
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
    draw_ball()
  end

  --love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball

  camera:unset()
  --love.graphics.rectangle('fill', 400, 80, w, h); -- gui not set by camera
  love.graphics.print(text, 10, 10)
  --screen_message("AAA")
end

function draw_ball()
  if objects.ball.hide == 0 then
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
  else
    love.graphics.setColor(22, 250, 250);
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
    love.graphics.setColor(250, 250, 250);
  end
end
