local team = {}

--will this work here?
function love.joystickadded(joystick)
  --p1joystick = joystick
  if gamepad  ~= nil then
    local value = table.getn(gamepad)
    print(value)
    gamepad[value+1] = joystick
  else
    gamepad = {}
    gamepad[1] = joystick
  end

end

function team:enter()
  love.graphics.setBackgroundColor( 0, 10, 25 )

  gui = {}
  gui.keyboard = {x = (love.graphics.getWidth()/2)-25, y = 25}
  gui.keyboard.shape = love.physics.newRectangleShape(0, 0, 50, 25)

  roster = {}

  gui.pad = {}

  if gamepad ~= nil then
    for i,v in ipairs(gamepad) do
      --just print out 10 make them invisible in draw
      gui.pad[i] = {x = (love.graphics.getWidth()/2)-25, y = 75}
      gui.pad[i].shape = love.physics.newRectangleShape(0, 0, 50, 25)
    end
  end

end

function team:update()

  if love.keyboard.isDown('left','a') then
    gui.keyboard.x = (love.graphics.getWidth()/4)-25
    roster[1] = {x = 0, y = 0, c = "K", team = 0, char = "default"}
  elseif love.keyboard.isDown('right','d') then
    gui.keyboard.x = (love.graphics.getWidth()/2)+(love.graphics.getWidth()/4)-25
    roster[1] = {x = 0, y = 0, c = "K", team = 1, char = "default"}
  end

  if gamepad ~= nil then
    for i,v in ipairs(gamepad) do
      local x = gamepad[i]:getGamepadAxis("leftx")
      if x < -0.2 then
        gui.pad[i].x = (love.graphics.getWidth()/4)-25
        roster[i+1] = {x = 0, y = 0, c = i, team = 0, char = "default"}
      elseif x > 0.2 then
        gui.pad[i].x = (love.graphics.getWidth()/2)+(love.graphics.getWidth()/4)-25
        roster[i+1] = {x = 0, y = 0, c = i, team = 1, char = "default"}
      end
    end
  end

end

function team:draw()
  love.graphics.setColor(250, 250, 250);
  love.graphics.print("Press g to continue", 10, 10)
  love.graphics.setColor(250, 50, 50);

  love.graphics.rectangle( "fill", gui.keyboard.x, gui.keyboard.y, 50, 25 )

  if gamepad ~= nil then
    for i,v in ipairs(gamepad) do
      love.graphics.rectangle( "fill", gui.pad[i].x, gui.pad[i].y, 50, 25 )
    end
  end

end

function team:keyreleased(key, code)

  if key == 'g' then
      print(table.getn(roster)) --list number of players, 10 need in total computer assigned.

      gamestate.switch(game)
  end
end

return team;
