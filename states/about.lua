stAbout = {}

local bg = require "utils.background"
local fonts = require "assets.fonts"
local utils = require "utils.utils"

function stAbout:init()
	self.textspeed = 15
	self.texty = love.graphics.getHeight()
end

function stAbout:enter(game)
	self.dogeism = utils.getDogeism()
end

function stAbout:update(dt)	
	bg:update(dt)
	
  local screenh = love.graphics.getHeight()
	self.texty = self.texty - self.textspeed * dt
	--scrolling text
	if self.texty + screenh*1.5 <= 0 then
		self.texty = screenh
	elseif self.texty >= screenh then
		self.texty = screenh
	end
end

function stAbout:draw()
	bg:draw()
	
	--draw the pause overlay on top :)
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle("fill",0,0,w,h)
	
	--draw the text	
	love.graphics.setFont(fonts[22])
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("wow " .. self.dogeism .. " credits", 0, self.texty, w, "center")
	love.graphics.setFont(fonts[16])
	love.graphics.printf([[
	Doge vs Doge was made by Beforan for Mini LD #49 (http://ludumdare.com/compo)
	
	ALL programming (dat map generator!) was performed by Beforan from 21st - 23rd Feb 2014
	
	All music was written and produced by Beforan, but prior to the game jam
	
	The shibe sprite was made by Beforan during the jam :)
	
	The Rocket was found in a panic when I had no time left, and is thanks to:
	JM.Atencia - http://opengameart.org/content/rocket

	under the CC-BY 3.0 license
	http://creativecommons.org/licenses/by/3.0/
	
	
	The game was made in the LÖVE framework,
	an *awesome* framework you can use to make 2D games in Lua.
	http://love2d.org
	
	Thanks to the following in the LÖVE community, for their libraries:
	vrld - for HUMP (Classes, Cameras, Gamestates) and Quickie (GUI)
	kikito - for Bump (collision)
	Yonaba - for Jumper, which didn't get used in this AI-less version, but will someday ;)
	
	and everyone on the love2d forums for providing useful comments that may have
	helped me with spritebatching, collision response, shaders and anything else.
	
	The game design is based on First Star's 8-bit classic "Spy vs Spy"
	featuring the antics of MAD Magazine's Black Spy and White Spy
	
	To meet the theme of Mini LD #49 - "non-human player" - I adjusted
	it from spies to dogs of the shiba inu variety, or "Doges" as the internet calls them these days.
	
	In line with the supershibe meme and the Dogecoin community, the objective of the game
	is now for the shibes to collect the necessary items and reach the rocket launchpad
	in order to go To The Moon™!
	
	Learn more at http://reddit.com/r/dogecoin
	
	Unfortunately, traps didn't make the cut over the weekend, as I ran out of time.
	Spent too long debugging procedural map generators and not enough time on actual gameplay.
	
	Whoops.
	
	I hope you enjoyed this silly weekend dev project ;)
	
	-Beforan (Twitter: @Beforan)	
	]], 0, self.texty + 60, w, "center")
	
	love.graphics.printf("- ESC to return - ", 0, 10, love.graphics.getWidth() - 10, "right")
	love.graphics.printf("- SPACE for speed - ", 10, 10, love.graphics.getWidth(), "left")
	love.graphics.setFont(fonts.default)
end

function stAbout:keypressed(key)
	if(key == "space") then
		self.textspeed = 200
	end
end

function stAbout:keyreleased(key)
	if(key == "escape") then
		Gamestate.pop()
	end
	if(key == "space") then
		self.textspeed = 15
	end
end
