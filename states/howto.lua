stHowto = {}

local bg = require "utils.background"
local fonts = require "assets.fonts"
local utils = require "utils.utils"

function stHowto:init()
	self.textspeed = 15
	self.texty = love.graphics.getHeight()
end

function stHowto:enter(game)
	self.dogeism = utils.getDogeism()
end

function stHowto:update(dt)	
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

function stHowto:draw()
	bg:draw()
	
	--draw the pause overlay on top :)
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle("fill",0,0,w,h)
	
	--draw the text	
	love.graphics.setFont(fonts[22])
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("wow " .. self.dogeism .. " game manual", 0, self.texty, w, "center")
	love.graphics.setFont(fonts[16])
	love.graphics.printf([[
	The aim of Doge vs Doge is to collect everything you need for your rocket launch to the moon
	before the other shibe beats you to it.
	
	This is a two player game, as I ran out of time for AI/pathfinding!
	Each player's controls are shown in the main game UI!
	
	Pick a Doge, Lite or Dark, and search all the cabinets in every room trying to find your moon launch equipment:
	Astrodoge Suit
	DogeCoin Paper Wallet
	Favourite Chew Toy
	Kibbles for the journey
	
	[search a cabinet with the Action key]
	
	But oh no, you can only carry 1 thing a time (curse that lack of opposable thumbs!) unless you have the
	Doggy Bag
	which can contain all the other items!
	
	Once all the items have been put in the Doggy Bag, the Rocket LaunchPad will appear!
	
	Make your way there with all the other items to win!
	Beware of the time limit however; there's a countdown to that launch!
	
	Oh no, did the other shibe get all the items first? These Doges can fight each other!
	
	[attack another Doge with the Action key, when near to them!]
	
	To The Moon!
	
	]], 0, self.texty + 60, w, "center")
	
	love.graphics.printf("- ESC to return - ", 0, 10, love.graphics.getWidth() - 10, "right")
	love.graphics.printf("- SPACE for speed - ", 10, 10, love.graphics.getWidth(), "left")
	love.graphics.setFont(fonts.default)
end

function stHowto:keypressed(key)
	if(key == "space") then
		self.textspeed = 200
	end
end

function stHowto:keyreleased(key)
	if(key == "escape") then
		Gamestate.pop()
	end
	if(key == "space") then
		self.textspeed = 15
	end
end
