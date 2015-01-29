Doge = Class {
	init = function(self, name)
		self.name = name
		self.SpriteSheet = love.graphics.newImage("/assets/" .. name .. ".png")
		self.Animations = {
			WalkLeft = newAnimation(self.SpriteSheet,64,64,0.1,1,4),
			WalkRight = newAnimation(self.SpriteSheet,64,64,0.1,2,4),
			WalkDown = newAnimation(self.SpriteSheet,64,64,0.1,3,4),
			WalkUp = newAnimation(self.SpriteSheet,64,64,0.1,4,4),
		}
		self.Controls = Settings[name].Controls
		self.CurrentSprite = self.Animations.WalkLeft
		
	end,
	x = 48, y = 48,
	xDelta = 0, yDelta = 0, --character movement velocity in x and y
	Speed = 70, --speed used for the above velocity
	isDoge = true, --identify as a doge!
	hasDoggyBag = false,
	hasWallet = false,
	hasAstrosuit = false,
	hasChewtoy = false,
	hasKibbles = false,
	Health = 15,
	MaxHealth = 20,
	Timer = 300,
	RespawnTimer = 0,
	Lives = 5,
	isDead = false,
	personalDogeism = "",
	gameOver = false,
	win = false,
}
function Doge:getBBox()
	if(self.CurrentSprite == self.Animations.WalkUp or
		self.CurrentSprite == self.Animations.WalkDown) then
		return self.x - 12, self.y -18, 24, 18
	else
		return self.x - 32, self.y -18, 64, 18
	end
end

function Doge:Update(dt)
	if(self.gameOver) then return end
	
	if(self.Health > 0) then
		if(self.xDelta == 0 and self.yDelta == 0) then
			self:StopAnim()
		elseif(self.xDelta ~= 0) then
			self:Face(self.xDelta < 0 and "left" or "right")
			self.CurrentSprite:play()
		elseif(self.yDelta ~= 0) then
			self:Face(self.yDelta < 0 and "up" or "down")
			self.CurrentSprite:play()
		end
		
		--if we are updating position, then collision check and move if possible
		if(self.yDelta ~= 0 or self.xDelta ~= 0) then
			local xNew = self.x + self.xDelta * self.Speed * dt
			local yNew = self.y + self.yDelta * self.Speed * dt
			self.x = xNew
			self.y = yNew
		end--]]
		
		self.CurrentSprite:update(dt)
		
		--update health
		if(self.Health ~= self.MaxHealth) then
			if(self.Health > self.MaxHealth) then self.Health = self.MaxHealth
			else self.Health = self.Health + 3*dt end
		end
	else
		if(not self.isDead) then self:Die() end
		self.Health = 0 --ensure we don't go below in the meantime!
		
		if(self.Lives > 0) then
			if(self.RespawnTimer > 0) then
				self.RespawnTimer = self.RespawnTimer - dt
			else
				self.RespawnTimer = 0
			end
			
			if(self.RespawnTimer == 0) then self:Respawn() end
		end
	end
	
	--update timer
	if(self.Timer > 0) then
		self.Timer = self.Timer - dt
	else
		self.Timer = 0
		self.gameOver = true
	end
end

function Doge:Die()
	self.isDead = true
	self.Health = 0
	self.Lives = self.Lives - 1
	self.RespawnTimer = (6 - self.Lives)*10
	self.Timer = self.Timer - (2*self.RespawnTimer)
	self.personalDogeism = getDogeism()
	
	--redistribute any items that were carried!
	local itemCopy = {
		hasDoggyBag = self.hasDoggyBag,
		hasWallet = self.hasWallet,
		hasAstrosuit = self.hasAstrosuit,
		hasChewtoy = self.hasChewtoy,
		hasKibbles = self.hasKibbles,
	}
	
	local map = Gamestate.current().map
	
	for i = 1, 5 do
		if(itemCopy[i]) then --only proceed if we were actually carrying it!
			local done = false
			local furn, f, roomID
			
			repeat
				--pick a room
				roomID = math.random(map.nRooms)
				
				--pick a furniture in that room
				f = math.random(#map.Furniture[roomID])
				furn = map.Furniture[roomID][f]
				
				--check the furniture is empty
				if(hasNoItems(furn)) then done = true end
			until(done)
			
			--set flags
			furn.hasDoggyBag = (i == 1)
			furn.hasWallet = (i == 2)
			furn.hasAstrosuit = (i == 3)
			furn.hasChewtoy = (i == 4)
			furn.hasKibbles = (i == 5)
		end
	end
	
	--mark everything removed from us!
	self.hasDoggyBag = false
	self.hasWallet = false
	self.hasAstrosuit = false
	self.hasChewtoy = false
	self.hasKibbles = false
end

function Doge:Respawn()
	if(self.Lives <= 0) then return end
	self.Health = self.MaxHealth
	self.isDead = false
	self.personalDogeism = ""
end

local function sign(x)
  return x < 0 and -1 or (x > 0 and 1 or 0)
end

function Doge:Collision(item2, dx, dy)
	if(not item2.isDoge) then
		if(item2.TileID ~= 6) then self.x, self.y = self.x + dx, self.y + dy
		else
			print("launchpad collide")
			if(hasAllItems(self)) then self.win = true end --collided with the launch pad in possession of all items!
		end
	else
		self.Vulnerable = true
	end
end

function Doge:Draw()
	if(self.Health <= 0) then return end --don't draw dead dogs!
	
	local spriteX, spriteY = 0,0
	
	spriteX = self.x - 32 --horizontally centered.
	spriteY = self.y - 48 --vetically, the player's feet? maybe?
	
	self.CurrentSprite:draw(spriteX,spriteY)
end

function Doge:Move(direction)
	if(direction == "up") then
		self.yDelta = self.yDelta - 1
	elseif(direction == "left") then
		self.xDelta = self.xDelta - 1
	elseif(direction == "down") then
		self.yDelta = self.yDelta + 1
	elseif(direction == "right") then
		self.xDelta = self.xDelta + 1
	end	
end

function Doge:Face(direction)
	if(direction == "up") then
		self.CurrentSprite = self.Animations.WalkUp
	elseif(direction == "left") then
		self.CurrentSprite = self.Animations.WalkLeft
	elseif(direction == "down") then
		self.CurrentSprite = self.Animations.WalkDown
	elseif(direction == "right") then
		self.CurrentSprite = self.Animations.WalkRight
	end	
end

function Doge:SearchFurniture()	
	--translate our co-ords to a tile
	local map = Gamestate.current().map
	local tileX, tileY = math.floor(self.x/map.TileSize), math.floor(self.y/map.TileSize)
	local furn
	
	--now check next tiles in facing direction for furniture!
	if(self.CurrentSprite == self.Animations.WalkUp) then --assume we're facing up
		if(map.Tiles[tileY-1] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY-1][tileX]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
		if(map.Tiles[tileY-2] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY-2][tileX]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
	end
	if(self.CurrentSprite == self.Animations.WalkDown) then --assume we're facing up
		if(map.Tiles[tileY+1] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY+1][tileX]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
		if(map.Tiles[tileY+2] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY+2][tileX]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
	end
	if(self.CurrentSprite == self.Animations.WalkLeft) then --assume we're facing up
		if(map.Tiles[tileY][tileX-1] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY][tileX-1]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
		if(map.Tiles[tileY][tileX-2] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY][tileX-2]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
	end
	if(self.CurrentSprite == self.Animations.WalkRight) then --assume we're facing up
		if(map.Tiles[tileY][tileX+1] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY][tileX+1]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
		if(map.Tiles[tileY][tileX+2] ~= nil and not furn) then --check it exists first?
			local t = map.Tiles[tileY][tileX+2]
			if(t.FurnitureID ~= 0) then
				furn = map.Furniture[t.RoomID][t.FurnitureID]
			end
		end
	end
	
	if(not furn) then return end --didn't find any furniture in Action range
	
	--update item flags
	itemExchange(self,furn)
end

function Doge:StopAnim()
	self.CurrentSprite:stop()
	self.CurrentSprite:reset()
end
