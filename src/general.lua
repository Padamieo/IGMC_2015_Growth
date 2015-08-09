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

--determine n is number
function is_int(n)
  return (type(n) == "number") and (math.floor(n) == n)
end

--returns only positive number
function positive_num(value)
  if value > 0 then
    value = value*-1
  end
  return value
end

function set_zoom()
  --h = love.graphics.getHeight()
  local w = love.graphics.getWidth()
  return 1920 / w
end


--player things maybe handle elsewhere

function kick(player)
  --boo = player.body:getAngle()

  local xp, yp = player.body:getPosition( )

  xd = distance(xp,xb)
  yd = distance(yp,yb)

  f = 100

  local dis = math.sqrt((xd^2)+(yd^2))

  ball_size = objects.ball.shape:getRadius()

  valid_distance = ball_size + 60 --magic number for now

  if dis < valid_distance then

    local left_or_right = xp - xb

    local comp = (yp - yb) / (xp - xb)

    local rad = math.atan( comp )

    --ball_mass = objects.ball.body:getMass()
    --ac = f / ball_mass

    local v = f/dis

    if left_or_right > 0 then
      hemi = -1
    else
      hemi = 1
    end

    local xf = hemi*math.cos(rad)*v
    local yf = hemi*math.sin(rad)*v

    objects.ball.body:applyLinearImpulse( xf, yf ) --this is definatly wrong
      local old_radius = objects.ball.shape:getRadius()
      local new = old_radius*1.1;
      objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
      objects.ball.body:setMass(0.009)
      objects.ball.shape:setRadius(new)
    
  end
end
