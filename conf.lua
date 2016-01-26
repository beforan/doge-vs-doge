function love.conf(t)
	t.version = "0.10.0"
	t.console = false
	
	--window settings
	t.window.width = 1100
	t.window.minwidth = 900
	t.window.height	= 700
	t.window.minheight	= 700
	t.window.title = "Doge vs Doge (Mini LD #49) by Beforan"        -- The window title (string)
  t.window.icon = nil                -- Filepath to an image to use as the window's icon (string)
  t.window.borderless = false        -- Remove all border visuals from the window (boolean)
  t.window.resizable = true         -- Let the window be user-resizable (boolean)
  t.window.fullscreen = false        -- Enable fullscreen (boolean)
  t.window.fullscreentype = "exclusive" -- Standard fullscreen or desktop fullscreen mode (string)
  t.window.vsync = true              -- Enable vertical sync (boolean)
  t.window.fsaa = 0                  -- The number of samples to use with multi-sampled antialiasing (number)
  t.window.display = 1               -- Index of the monitor to show the window in (number)
	
	t.modules.audio = true             -- Enable the audio module (boolean)
--    t.modules.event = true             -- Enable the event module (boolean)
    t.modules.graphics = true          -- Enable the graphics module (boolean)
    t.modules.image = true             -- Enable the image module (boolean)
--    t.modules.joystick = true          -- Enable the joystick module (boolean)
    t.modules.keyboard = true          -- Enable the keyboard module (boolean)
    t.modules.math = true              -- Enable the math module (boolean)
--    t.modules.mouse = true             -- Enable the mouse module (boolean)
--    t.modules.physics = true           -- Enable the physics module (boolean)
--    t.modules.sound = true             -- Enable the sound module (boolean)
    t.modules.system = true            -- Enable the system module (boolean)
--    t.modules.timer = true             -- Enable the timer module (boolean)
    t.modules.window = true            -- Enable the window module (boolean)
end
