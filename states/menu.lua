stMenu = {}

local bg = require "utils.background"
local fonts = require "assets.fonts"

function stMenu:enter()
	if(stGame.map ~= nil) then
		stGame.map:Clear()
	end
end

function stMenu:update(dt)	
	Gui.group.push{ grow = "down", 
					pos = { love.graphics.getWidth()/2 - Gui.group.size[1]/2, love.graphics.getHeight()/2 + 50 } }
	if Gui.Button{text = "New Game"} then
		Gamestate.switch(stGame)
	end
	if Gui.Button{text = "How to Play"} then
		Gamestate.push(stHowto)
	end
	if Gui.Button{text = "About the Game"} then
		Gamestate.push(stAbout)
	end
	if Gui.Button{text = "Quit Game"} then
		love.event.quit()
	end
	Gui.group.pop{}
  
  bg:update(dt)
end

function stMenu:draw()
  bg:draw()
  
	--title
	love.graphics.setFont(fonts[120])
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf("DOGE vs DOGE",4,124,love.graphics.getWidth(), "center")
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("DOGE vs DOGE",0,120,love.graphics.getWidth(), "center")
	love.graphics.setFont(fonts.default)	--restore default font :\
	
	Gui.core.draw()
end

function stMenu:keyreleased(key,code)
	if key == 'escape' then
		love.event.quit()
	end
end
