stHowto = {}

function stHowto:init()
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
	self.textspeed = 15
	self.texty = love.window.getHeight()
end

function stHowto:enter(game)
	self.dogeism = getDogeism()
end

function stHowto:update(dt)	
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
	
	self.texty = self.texty - self.textspeed * dt
	--scrolling text
	if self.texty + screenh*1.5 <= 0 then
		self.texty = screenh
	elseif self.texty >= screenh then
		self.texty = screenh
	end
end

function stHowto:draw()
	--draw background
	love.graphics.setShader(self.bgShader)
	drawinrect(self.background, 0, self.backy1, love.window.getWidth(), love.window.getHeight())
	drawinrect(self.background, 0, self.backy1+love.window.getHeight(), love.window.getWidth(), love.window.getHeight())
	
	love.graphics.setShader()
	
	--draw the pause overlay on top :)
	local w, h = love.window.getWidth(), love.window.getHeight()
	
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
	
	love.graphics.printf("- ESC to return - ", 0, 10, love.window.getWidth() - 10, "right")
	love.graphics.printf("- SPACE for speed - ", 10, 10, love.window.getWidth(), "left")
	love.graphics.setFont(fonts[14])
end

function stHowto:keypressed(key)
	if(key == " ") then
		self.textspeed = 200
	end
end

function stHowto:keyreleased(key)
	if(key == "escape") then
		Gamestate.pop()
	end
	if(key == " ") then
		self.textspeed = 15
	end
end
