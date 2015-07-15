-- Configuration
function love.conf(t)
	t.title = "Grow-oal Football" -- The title of the window the game is in (string)
	t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 480        -- we want our game to be long and thin.
	t.window.height = 800
	t.window.fullscreen = false        -- Enable fullscreen (boolean)
	t.window.resizable = true
	-- For Windows debugging
	t.console = true
end
