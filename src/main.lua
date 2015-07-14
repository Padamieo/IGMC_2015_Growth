debug = true

local socket = require("socket")

-- the address and port of the server
local address, port = "localhost", 12345

local entity -- entity is what we'll be controlling
local updaterate = 0.1 -- how long to wait, in seconds, before requesting an update

local world = {} -- the empty world-state
local t

-- Load some default values for our rectangle.
function love.load()

    udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(address, port)
    local dg = string.format("%s %s %d %d", entity, 'at', 320, 240)
    udp:send(dg) -- the magic line in question.
    -- t is just a variable we use to help us with the update rate in love.update.
    t = 0 -- (re)set t to 0

    x, y, w, h = 20, 20, 60, 20;

end

-- Increase the size of the rectangle every frame.
function love.update(dt)

  if w < 200 then
    w = w + 1;
    h = h + 1;
  end

end

-- Draw a coloured rectangle.
function love.draw()

    love.graphics.setColor(0, 100, 100);
    love.graphics.rectangle('fill', x, y, w, h);

end
