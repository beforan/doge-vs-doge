stMenu = {}

function stMenu:init()
	--background shader
	local pxCode = [[
		extern number time;
		number t;
		vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
		{
			t = time * 1.5;
			color = Texel(tex, tc);
			return vec4(vec3(sin(t + 5)+0.3, -sin(t+5)+0.3, sin(t + 10)) * (max(color.r, max(color.g, color.b))), 1.0);
		}
	]]
	local vxCode = [[
		varying vec4 vpos;
		
		vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            vpos = vertex_position;
			return transform_projection * vertex_position;
        }
	]]
	
	self.bgShader = love.graphics.newShader(pxCode,vxCode)
	self.t = 0	
	
	--create grey background gradient (we'll tint it with shaders ;) )
	self.background = gradient { { 150, 150, 150 }, { 255, 255, 255 }, { 150, 150, 150 } }
	self.backy1 = 0 --top co-ords of the first background instance
	self.backy2 = love.window.getHeight() --top co-ords of the second (sadly we have to track both)
	self.backspeed = 200
end

function stMenu:enter()
	if(stGame.map ~= nil) then
		stGame.map:Clear()
	end
end

function stMenu:update(dt)	
	Gui.group.push{ grow = "down", 
					pos = { love.window.getWidth()/2 - Gui.group.size[1]/2, love.window.getHeight()/2 + 50 } }
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
	
	--shader updates
	self.t = self.t + math.min(dt, 1/30)
	self.bgShader:send("time", self.t)
	
	--update backgrounds pos
	local screenh = love.window.getHeight()
	self.backy1 = self.backy1 - self.backspeed * dt
	self.backy2 = self.backy1 + screenh
	if self.backy1 + screenh <= 0 then
		local dy = self.backy1 + screenh*2
		self.backy1 = screenh - dy
	elseif self.backy1 >= screenh then
		local dy = self.backy1 - screenh*2
		self.backy1 = dy
	end
	if self.backy2 + screenh <= 0 then
		local dy = self.backy2 + screenh*2
		self.backy2 = screenh - dy
	elseif self.backy2 >= screenh then
		local dy = self.backy2 - screenh*2
		self.backy2 = dy
	end
end

function stMenu:draw()
	
	--draw background
	love.graphics.setShader(self.bgShader)
	drawinrect(self.background, 0, self.backy1, love.window.getWidth(), love.window.getHeight())
	drawinrect(self.background, 0, self.backy1+love.window.getHeight(), love.window.getWidth(), love.window.getHeight())
	
	love.graphics.setShader()
	--title
	love.graphics.setFont(fonts[120])
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf("DOGE vs DOGE",4,124,love.window.getWidth(), "center")
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("DOGE vs DOGE",0,120,love.window.getWidth(), "center")
	love.graphics.setFont(fonts[14])	--restore default font :\
	
	Gui.core.draw()
end

function stMenu:keyreleased(key,code)
	if key == 'escape' then
		love.event.quit()
	end
end
