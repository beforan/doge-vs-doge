stPause = {}

local fonts = require "assets.fonts"
local utils = require "utils.utils"

function stPause:enter(game)
	love.audio.pause()
	self.game = game
	self.dogeism = utils.getDogeism() --new one each time we pause
end

function stPause:update(dt)
	--gui updates
	Gui.group.push{ grow = "down", 
					pos = { love.graphics.getWidth()/2 - Gui.group.size[1]/2, love.graphics.getHeight()/2 + 50 } }
	if Gui.Button{text = "Resume"} then
		love.audio.resume()
		Gamestate.pop()
	end
	if Gui.Button{text = "Quit to Menu"} then
		love.audio.resume()
		Gamestate.switch(stMenu)
	end
	if Gui.Button{text = "Quit to Desktop"} then
		love.event.quit()
	end
	Gui.group.pop{}
end

function stPause:draw()
	self.game:draw() --draw the game behind, though it's not updating
	
	--draw the pause overlay on top :)
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle("fill",0,0,w,h)
	
	--draw the text
	love.graphics.setFont(fonts[72])
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf("wow " .. self.dogeism .. " pause", 4, (h / 2 - love.graphics.getFont():getHeight())+4, w, "center")
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("wow " .. self.dogeism .. " pause", 0, h / 2 - love.graphics.getFont():getHeight(), w, "center")
	love.graphics.setFont(fonts.default)
	
	Gui.core.draw()
end

function stPause:keyreleased(key)
	if(key == "escape") then
		love.audio.resume()
		Gamestate.pop()
	end
end
