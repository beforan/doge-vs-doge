stEnd = {}

local bg = require "utils.background"
local fonts = require "assets.fonts"

function stEnd:enter(game, result)
	self.result = result
	self.dogeism = getDogeism() --new one each time we pause
end

function stEnd:update(dt)
	--gui updates
	Gui.group.push{ grow = "down", 
					pos = { love.window.getWidth()/2 - Gui.group.size[1]/2, love.graphics.getHeight()/2 + 50 } }
	if Gui.Button{text = "Play Again"} then
		Gamestate.switch(stGame)
	end
	if Gui.Button{text = "Quit to Menu"} then
		Gamestate.switch(stMenu)
	end
	if Gui.Button{text = "Quit to Desktop"} then
		love.event.quit()
	end
	Gui.group.pop{}
	
	bg:update(dt)
end

function stEnd:draw()
	bg:draw()
  
	--draw the text
	local w, h = love.window.getWidth(), love.graphics.getHeight()
	
	if(self.result == "lose") then
		love.graphics.setFont(fonts[72])
		love.graphics.setColor(0,0,0,255)
		love.graphics.printf("wow " .. self.dogeism .. " fail", 4, (h / 2 - love.graphics.getFont():getHeight())+4, w, "center")
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("wow " .. self.dogeism .. " fail", 0, h / 2 - love.graphics.getFont():getHeight(), w, "center")
		
	else
		love.graphics.setFont(fonts[72])
		love.graphics.setColor(0,0,0,255)
		love.graphics.printf("wow " .. self.dogeism .. " " .. self.result .. " victory", 4, (h / 2 - love.graphics.getFont():getHeight())+4, w, "center")
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("wow " .. self.dogeism .. " " .. self.result .. " victory", 0, h / 2 - love.graphics.getFont():getHeight(), w, "center")
	end
	love.graphics.setFont(fonts.default)
	
	Gui.core.draw()
end

function stEnd:keyreleased(key)
	if(key == "escape") then
		love.audio.resume()
		Gamestate.pop()
	end
end
