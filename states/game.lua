stGame = {}

local fonts = require "assets.fonts"

--init
function stGame:init()	
	self.map = Map()
	self:NewGame()
end

--enter
function stGame:enter(last)
	self:NewGame()
end

function stGame:NewGame()
	self.map.LaunchPadVisibleAtStart = settings.Map.LaunchPadVisibleAtStart
	
	self.map:Generate(math.random(6,12),20,12)
	
	self.LiteDoge = Doge("LiteDoge")
	self.DarkDoge = Doge("DarkDoge")

	self.LiteDoge.x = self.map.LiteSpawn:RealX()
	self.LiteDoge.y = self.map.LiteSpawn:RealY()
	self.DarkDoge.x = self.map.DarkSpawn:RealX()
	self.DarkDoge.y = self.map.DarkSpawn:RealY()
	
	Bump.add(self.LiteDoge)
	Bump.add(self.DarkDoge)
	
	self.LiteCam = Camera(0, 0)
	self.DarkCam = Camera(0, 0)
	
	--[[testing victory
	self.LiteDoge.hasDoggyBag = true
	self.LiteDoge.hasAstrosuit = true
	self.LiteDoge.hasChewtoy = true
	self.LiteDoge.hasWallet = true
	self.LiteDoge.hasKibbles = true--]]
end

--update
function stGame:update(dt)
	--check victory or game over
	if(self.LiteDoge.win) then Gamestate.switch(stEnd,"LiteDoge") end
	if(self.DarkDoge.win) then Gamestate.switch(stEnd,"LiteDoge") end
	if(self.LiteDoge.gameOver and self.DarkDoge.gameOver) then Gamestate.switch(stEnd,"lose") end
	
	self.LiteDoge:Update(dt)
	self.LiteCam:lookAt(self.LiteDoge.x, self.LiteDoge.y)
	self.DarkDoge:Update(dt)
	self.DarkCam:lookAt(self.DarkDoge.x, self.DarkDoge.y)
	Bump.collide()
	
	if(not self.map.LaunchPadVisible and (hasAllItems(self.LiteDoge) or hasAllItems(self.DarkDoge))) then self.map:UnveilLaunchPad() end
end

function hasNoItems(o)
	return not (o.hasDoggyBag or o.hasWallet or o.hasAstrosuit or o.hasChewtoy or o.hasKibbles)
end

function hasAllItems(o)
	return (o.hasDoggyBag and o.hasWallet and o.hasAstrosuit and o.hasChewtoy and o.hasKibbles)
end

function itemExchange(o1, o2)
	if(hasNoItems(o1) and hasNoItems(o2)) then return end
	
	if(o1.hasDoggyBag and o1.isDoge) then --one way to o1
		if(o2.hasWallet) then o1.hasWallet = true; o2.hasWallet = false end
		if(o2.hasAstrosuit) then o1.hasAstrosuit = true; o2.hasAstrosuit = false end
		if(o2.hasChewtoy) then o1.hasChewtoy = true; o2.hasChewtoy = false end
		if(o2.hasKibbles) then o1.hasKibbles = true; o2.hasKibbles = false end
	
	elseif(o2.hasDoggyBag and o2.isDoge) then --one way to o2
		if(o1.hasWallet) then o2.hasWallet = true; o1.hasWallet = false end
		if(o1.hasAstrosuit) then o2.hasAstrosuit = true; o1.hasAstrosuit = false end
		if(o1.hasChewtoy) then o2.hasChewtoy = true; o1.hasChewtoy = false end
		if(o1.hasKibbles) then o2.hasKibbles = true; o1.hasKibbles = false end
	
	elseif(o1.hasDoggyBag) then --one way, furn to doge
		o2.hasDoggyBag = true; o1.hasDoggyBag = false
		if(o1.hasWallet) then o2.hasWallet = true; o1.hasWallet = false end
		if(o1.hasAstrosuit) then o2.hasAstrosuit = true; o1.hasAstrosuit = false end
		if(o1.hasChewtoy) then o2.hasChewtoy = true; o1.hasChewtoy = false end
		if(o1.hasKibbles) then o2.hasKibbles = true; o1.hasKibbles = false end
		
	elseif(o2.hasDoggyBag) then --one way, furn to doge
		o1.hasDoggyBag = true; o2.hasDoggyBag = false
		if(o2.hasWallet) then o1.hasWallet = true; o2.hasWallet = false end
		if(o2.hasAstrosuit) then o1hasAstrosuit = true; o2.hasAstrosuit = false end
		if(o2.hasChewtoy) then o1.hasChewtoy = true; o2.hasChewtoy = false end
		if(o2.hasKibbles) then o1.hasKibbles = true; o2.hasKibbles = false end
	
	else --no doggy bags involved, have to swap contents.
		local o1copy = {
			hasDoggyBag = o1.hasDoggyBag,
			hasWallet = o1.hasWallet,
			hasAstrosuit = o1.hasAstrosuit,
			hasChewtoy = o1.hasChewtoy,
			hasKibbles = o1.hasKibbles,
		}
		o1.hasDoggyBag = o2.hasDoggyBag
		o1.hasWallet = o2.hasWallet
		o1.hasAstrosuit = o2.hasAstrosuit
		o1.hasChewtoy = o2.hasChewtoy
		o1.hasKibbles = o2.hasKibbles
		o2.hasDoggyBag = o1copy.hasDoggyBag
		o2.hasWallet = o1copy.hasWallet
		o2.hasAstrosuit = o1copy.hasAstrosuit
		o2.hasChewtoy = o1copy.hasChewtoy
		o2.hasKibbles = o1copy.hasKibbles
	end
end

--draw
function stGame.LiteViewPort()
   love.graphics.rectangle("fill", 300, 0, love.graphics.getWidth() - 300, love.graphics.getHeight() / 2)
end
function stGame.DarkViewPort()
   love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2, love.graphics.getWidth() - 300, love.graphics.getHeight() / 2)
end
function stGame:draw()
	--draw LiteDoge's world view ;)
	love.graphics.stencil(self.LiteViewPort, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
	love.graphics.translate( 300/2, - love.graphics.getHeight() / 4)
	self.LiteCam:attach()
		self:CommonDraw()
	self.LiteCam:detach()
	self:DrawDeathOverlay(self.LiteDoge)
	love.graphics.origin()
	
	--draw DarkDoge's world view ;)
	love.graphics.stencil(self.DarkViewPort, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
	love.graphics.translate(-300/2, love.graphics.getHeight() / 4)
	self.DarkCam:attach()
		self:CommonDraw()
	self.DarkCam:detach()
	self:DrawDeathOverlay(self.DarkDoge)
	--reset
	love.graphics.origin()
	love.graphics.setStencilTest()
	
	--draw UI
	self:DrawUI(self.LiteDoge)
	love.graphics.translate(love.graphics.getWidth() - 300, love.graphics.getHeight() / 2)
	self:DrawUI(self.DarkDoge)
	
	--reset
	love.graphics.origin()
end
function stGame:DrawDeathOverlay(doge)
	if(not doge.isDead and not doge.gameOver) then return end
	
	love.graphics.setColor(0,0,0,150)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	
	love.graphics.setColor(255,255,255,255)
	if(doge.Lives > 0 and not doge.gameOver) then
		love.graphics.printf(doge.personalDogeism .. " respawn in " .. string.format("%02d",doge.RespawnTimer) .. " seconds. wow.",
							0, love.graphics.getHeight() / 2 - love.graphics.getFont():getHeight(),
							love.graphics.getWidth(), "center")
	else
		love.graphics.printf("wow. " .. doge.personalDogeism .. " game over.",
							0, love.graphics.getHeight() / 2 - love.graphics.getFont():getHeight(),
							love.graphics.getWidth(), "center")
	end
end

function stGame:CommonDraw()
	--all drawing common to both doges
	self.map:Draw()
	
	love.graphics.setColor(255,255,255,255)
	
	--z-order the doges based on height (as if it were distance from cam)
	if(self.LiteDoge.y <= self.DarkDoge.y) then
		self.LiteDoge:Draw()
		self.DarkDoge:Draw()
	else
		self.DarkDoge:Draw()
		self.LiteDoge:Draw()
	end
	
	self.map:DrawRocket()
end

function stGame:DrawUI(doge)
	local pad = 15
	love.graphics.setColor(220,220,150,255)
	love.graphics.rectangle("fill",pad,pad,300-(2*pad),love.graphics.getHeight()/2 - (2*pad))
	love.graphics.setFont(fonts[16])
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf(doge.name,0,2*pad,300,"center")
	
	--HP, Timer labels
	love.graphics.setFont(fonts.default)
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf("Health: ",0,4*pad,100,"right")
	love.graphics.printf("Time: ",0,6*pad,100,"right")
	
	--health bar
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill",100+pad,(4*pad)+pad/4, 5*doge.Health, 10)
	
	--here be the timer drawing
	local fpad = ""
	if(doge.Timer%60 <10) then fpad = "0" end
	love.graphics.printf(string.format("%02d", math.floor(doge.Timer/60)) .. ":" .. fpad .. string.format("%.3f",doge.Timer%60),
						100+pad, 6*pad, 100, "left")
	
	--Controls
	love.graphics.setColor(0,0,0,255)
	love.graphics.printf("Up: " .. doge.Controls.Up,2*pad,9*pad,150-(4*pad),"center")
	love.graphics.printf("Down: " .. doge.Controls.Down,2*pad+150,9*pad,150-(4*pad),"center")
	love.graphics.printf("Left: " .. doge.Controls.Left,2*pad,11*pad,150-(4*pad),"center")
	love.graphics.printf("Right: " .. doge.Controls.Right,2*pad+150,11*pad,150-(4*pad),"center")
	love.graphics.printf("Action: " .. doge.Controls.Action,2*pad,13*pad,150-(4*pad),"center")
	love.graphics.printf("Map: " .. doge.Controls.Map,2*pad+150,13*pad,150-(4*pad),"center")
	
	--Items
	local colours = {
		[true] = {0,150,0,255},
		[false] = {150,0,0,255}
	}
	love.graphics.setColor(colours[doge.hasDoggyBag])
	love.graphics.printf("Doggy Bag",2*pad,15*pad,300-(4*pad),"center")
	love.graphics.setColor(colours[doge.hasWallet])
	love.graphics.printf("Dogecoin Wallet",2*pad,17*pad,150-(4*pad),"center")
	love.graphics.setColor(colours[doge.hasChewtoy])
	love.graphics.printf("Chew Toy",2*pad+150,17*pad,150-(4*pad),"center")
	love.graphics.setColor(colours[doge.hasAstrosuit])
	love.graphics.printf("Kibbles",2*pad,20*pad,150-(4*pad),"center")
	love.graphics.setColor(colours[doge.hasKibbles])
	love.graphics.printf("Astrodoge Suit",2*pad+150,19*pad,150-(4*pad),"center")
	
	--reset
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(fonts.default)
end

--inputs
function stGame:keypressed(key)	
	
	--litedoge
	if(key == self.LiteDoge.Controls.Up) then
		self.LiteDoge:Move("up")
	elseif(key == self.LiteDoge.Controls.Left) then
		self.LiteDoge:Move("left")
	elseif(key == self.LiteDoge.Controls.Down) then
		self.LiteDoge:Move("down")
	elseif(key == self.LiteDoge.Controls.Right) then
		self.LiteDoge:Move("right")
	end
	if(key == self.LiteDoge.Controls.Map) then self.LiteCam:zoomTo(0.1) end
	
	--darkdoge
	if(key == self.DarkDoge.Controls.Up) then
		self.DarkDoge:Move("up")
	elseif(key == self.DarkDoge.Controls.Left) then
		self.DarkDoge:Move("left")
	elseif(key == self.DarkDoge.Controls.Down) then
		self.DarkDoge:Move("down")
	elseif(key == self.DarkDoge.Controls.Right) then
		self.DarkDoge:Move("right")
	end
	if(key == self.DarkDoge.Controls.Map) then self.DarkCam:zoomTo(0.1) end
end

function stGame:keyreleased(key)
	if(key == "escape") then
		Gamestate.push(stPause)
	end
	
	--litedoge
	if(key == self.LiteDoge.Controls.Up) then
		self.LiteDoge.yDelta = self.LiteDoge.yDelta + 1
	elseif(key == self.LiteDoge.Controls.Left) then
		self.LiteDoge.xDelta = self.LiteDoge.xDelta + 1
	elseif(key == self.LiteDoge.Controls.Down) then
		self.LiteDoge.yDelta = self.LiteDoge.yDelta - 1
	elseif(key == self.LiteDoge.Controls.Right) then
		self.LiteDoge.xDelta = self.LiteDoge.xDelta - 1
	end
	if(key == self.LiteDoge.Controls.Map) then self.LiteCam:zoomTo(1) end
	if(key == self.LiteDoge.Controls.Action) then
		--do damage if applicable
		if(self.DarkDoge.Vulnerable and not self.LiteDoge.isDead) then self.DarkDoge.Health = self.DarkDoge.Health - 1 end
		
		--search furniture if applicable
		self.LiteDoge:SearchFurniture()
	end
	
	--darkdoge
	if(key == self.DarkDoge.Controls.Up) then
		self.DarkDoge.yDelta = self.DarkDoge.yDelta + 1
	elseif(key == self.DarkDoge.Controls.Left) then
		self.DarkDoge.xDelta = self.DarkDoge.xDelta + 1
	elseif(key == self.DarkDoge.Controls.Down) then
		self.DarkDoge.yDelta = self.DarkDoge.yDelta - 1
	elseif(key == self.DarkDoge.Controls.Right) then
		self.DarkDoge.xDelta = self.DarkDoge.xDelta - 1
	end
	if(key == self.DarkDoge.Controls.Map) then self.DarkCam:zoomTo(1) end
	if(key == self.DarkDoge.Controls.Action) then
		--do damage if applicable
		if(self.LiteDoge.Vulnerable and not self.DarkDoge.isDead) then self.LiteDoge.Health = self.LiteDoge.Health - 1 end
		
		--search furniture if applicable
		self.DarkDoge:SearchFurniture()
	end
	
end
