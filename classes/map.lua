local bump = require "lib.bump"

Map = Class {
	init = function(self, nRooms, rWidth, rHeight, tileSize)
		self.nRooms = nRooms or 3
		self.rWidth = rWidth or 15
		self.rHeight = rHeight or 10
		self.TileSize = tileSize or 24
		
		self.RocketSprite = love.graphics.newImage("/assets/rocket.png")
		self.RocketQuad = love.graphics.newQuad(0, 0, 110, 177, self.RocketSprite:getWidth(), self.RocketSprite:getHeight())
		
		--generate flat colour sprites for map tiles
		local FloorGrey = flatSprite(100,100,100,self.TileSize,self.TileSize)   --11
		local FloorRed = flatSprite(100,50,50,self.TileSize,self.TileSize)		--12
		local FloorGreen = flatSprite(50,100,50,self.TileSize,self.TileSize)	--13
		local FloorBlue = flatSprite(50,50,100,self.TileSize,self.TileSize)		--14
		local FloorMagenta = flatSprite(100,50,100,self.TileSize,self.TileSize)	--15
		local FloorCyan = flatSprite(50,100,100,self.TileSize,self.TileSize)	--16
		local FloorYellow = flatSprite(100,100,50,self.TileSize,self.TileSize)	--17
		local WallTopSprite = flatSprite(255,255,255,self.TileSize,self.TileSize) --21
		local WallGrey = flatSprite(180,180,180,self.TileSize,self.TileSize)	--31
		local WallRed = flatSprite(180,50,50,self.TileSize,self.TileSize)		--32
		local WallGreen = flatSprite(50,180,50,self.TileSize,self.TileSize)		--33
		local WallBlue = flatSprite(50,50,180,self.TileSize,self.TileSize)		--34
		local WallMagenta = flatSprite(180,50,180,self.TileSize,self.TileSize)	--35
		local WallCyan = flatSprite(50,180,180,self.TileSize,self.TileSize)		--36
		local WallYellow = flatSprite(180,180,50,self.TileSize,self.TileSize)	--37
		local FurnTop = flatSprite(150,150,150,self.TileSize,self.TileSize)		--41
		local FurnSide = flatSprite(120,120,120,self.TileSize,self.TileSize)	--51
		local LAUNCH = flatSprite(0,0,0,self.TileSize,self.TileSize)			--61
		--create a tileset image from our sprites
		self.TileSet = tileSet {
			FloorGrey,FloorRed,FloorGreen,FloorBlue,FloorMagenta,FloorCyan,FloorYellow,
			WallTopSprite,
			WallGrey,WallRed,WallGreen,WallBlue,WallMagenta,WallCyan,WallYellow,FurnTop,FurnSide,LAUNCH
		}
		
		--create quads for spritebatching (we add all tiles as there are so few anyway)
		--(we're in this for reducing love.draw calls)
		--lots of nil values...only add the ones we'll index
		self.TileQuads = {}
		self.TileQuads[11] = love.graphics.newQuad(self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[12] = love.graphics.newQuad(4*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[13] = love.graphics.newQuad(7*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[14] = love.graphics.newQuad(10*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[15] = love.graphics.newQuad(13*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[16] = love.graphics.newQuad(16*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[17] = love.graphics.newQuad(19*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		for i=21, 27 do --all white in this range
			self.TileQuads[i] = love.graphics.newQuad(22*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		end
		self.TileQuads[31] = love.graphics.newQuad(25*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[32] = love.graphics.newQuad(28*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[33] = love.graphics.newQuad(31*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[34] = love.graphics.newQuad(34*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[35] = love.graphics.newQuad(37*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[36] = love.graphics.newQuad(40*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		self.TileQuads[37] = love.graphics.newQuad(43*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		for i=41, 47 do --all grey in this range
			self.TileQuads[i] = love.graphics.newQuad(46*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		end
		for i=51, 57 do --all grey in this range
			self.TileQuads[i] = love.graphics.newQuad(49*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		end
		for i=61, 67 do --all black in this range
			self.TileQuads[i] = love.graphics.newQuad(52*self.TileSize, self.TileSize, self.TileSize, self.TileSize, self.TileSet:getWidth(), self.TileSet:getHeight())
		end
		
		--build the batch
		self.TileBatch = love.graphics.newSpriteBatch(self.TileSet, love.graphics.getWidth() * love.graphics.getHeight())
		--update the batch once the tile array is set...
	end,
	Tiles = {},
	Furniture = {},
	LaunchPadVisible = false,
	LaunchPadVisibleAtStart = false,
	rocketx = 0,
	rockety = 0,
}

function Map:updateSpriteBatch()
	--self.TileBatch:bind()
	self.TileBatch:clear()
	for y=1, #self.Tiles do
		for x=1, #self.Tiles[y] do
			t = self.Tiles[y][x]
			if(t.TileID ~= 0) then
				self.TileBatch:add(self.TileQuads[tonumber(t.TileID .. t.SpriteIndex)],
				(x-1)*self.TileSize, (y-1)*self.TileSize)
			end
		end
	end
	--self.TileBatch:unbind()
end

function Map:Generate(nRooms, rWidth, rHeight)
	self.nRooms = nRooms or self.nRooms
	self.rWidth = rWidth or self.rWidth
	self.rHeight = rHeight or self.rHeight
	
	self:Clear()
	
	--create a big empty grid of tiles to start building a map in
	local gridW = self.nRooms * self.rWidth
	local gridH = self.nRooms * self.rHeight
	
	--zero the grid
	for i=1, gridH do
		self.Tiles[i] = {}
		for j=1, gridW do
			self.Tiles[i][j] = Tile(j,i,self.TileSize,self.TileSize)
		end
	end

	local lastX, lastY = 1, 1
	
	--create each room next to the last co-ords, until no more rooms to create
	for i=1, self.nRooms do
		local newX, newY = self:chooseRoomLocation(lastX, lastY)
		if(newX == 0 or newY == 0) then return self:Generate(self.nRooms, self.rWidth, self.rHeight) end --out of space for new rooms, make a new map!
		
		self:createRoom(i, newX, newY)
		
		self:buildDoorways(newX, newY)
		
		self:placeFurniture(i, newX, newY)
		
		lastX, lastY = newX, newY --update last
	end
	
	self:placeItems()
	
	--add closing walls to right and bottom
	--add extra tiles for them (added here so they aren't used in room generation!)
	for i=1, gridH+3 do
		if(not self.Tiles[i]) then self.Tiles[i] = {} end
		for j=1, gridW+1 do
			if(not self.Tiles[i][j]) then self.Tiles[i][j] = Tile(j,i,self.TileSize,self.TileSize) end
		end
	end
	self:BuildExteriorWalls()
	
	self:Trim()
	
	self:updateSpriteBatch() --now that tiles are populated.
	
	--add impassable tiles to Bump
	for i=1, #self.Tiles do
		for j=1, #self.Tiles[i] do
			t = self.Tiles[i][j]
			if(not t.Passable) then bump.addStatic(t) end
		end
	end
	
	if(self.LaunchPadVisibleAtStart) then self:UnveilLaunchPad() end
end

function Map:placeItems()
	for i = 1, 5 do
		local done = false
		local furn, f, roomID
		
		repeat
			--pick a room
			roomID = math.random(self.nRooms)
			
			--pick a furniture in that room
			f = math.random(#self.Furniture[roomID])
			furn = self.Furniture[roomID][f]
			
			--check the furniture is empty
			if(hasNoItems(furn)) then done = true end
		until(done)
		
		--set flags
		furn.hasDoggyBag = (i == 1)
		furn.hasWallet = (i == 2)
		furn.hasAstrosuit = (i == 3)
		furn.hasChewtoy = (i == 4)
		furn.hasKibbles = (i == 5)
		
		--interesting debug?
		if(furn.hasDoggyBag) then print("Room " .. roomID .. " Furniture " .. f .. " has the Doggy Bag") end
		if(furn.hasWallet) then print("Room " .. roomID .. " Furniture " .. f .. " has the Wallet") end
		if(furn.hasAstrosuit) then print("Room " .. roomID .. " Furniture " .. f .. " has the Astrosuit") end
		if(furn.hasChewtoy) then print("Room " .. roomID .. " Furniture " .. f .. " has the Chewtoy") end
		if(furn.hasKibbles) then print("Room " .. roomID .. " Furniture " .. f .. " has the Kibbles") end
	end
end

function Map:UnveilLaunchPad()	
	if(self.LaunchPadVisible) then return end
	
	local fail = false
	local roomID
	local ld, dd = Gamestate.current().LiteDoge, Gamestate.current().DarkDoge
	repeat
		fail = false --reset the condition (optimistic!)
		
		--find a random tile
		local tileY = math.random(#self.Tiles-2)
		local tileX = math.random(#self.Tiles[tileY]-2)
		
		local tMain = self.Tiles[tileY][tileX]
		
		--check if it's a suitable furniture place
		if(tMain.TileID ~= 1) then fail = true end --gotta be floor, and not occupied
		
		roomID = tMain.RoomID
		
		--now check surroundings to ensure we don't block doors etc
		if(self.Tiles[tileY+1] ~= nil) and (not fail) then --check it exists first?
			local t = self.Tiles[tileY+1][tileX]
			if(t.TileID ~= 1 or
			(t.x == math.floor(ld.x / self.TileSize) and t.y == math.floor(ld.y / self.TileSize)) or
			(t.x == math.floor(dd.x / self.TileSize) and t.y == math.floor(dd.y / self.TileSize))) then
				fail = true
			end
		end
		if(self.Tiles[tileY+1][tileX+1] ~= nil) and (not fail) then --check it exists first?
			local t = self.Tiles[tileY+1][tileX+1]
			if(t.TileID ~= 1 or
			(t.x == math.floor(ld.x / self.TileSize) and t.y == math.floor(ld.y / self.TileSize)) or
			(t.x == math.floor(dd.x / self.TileSize) and t.y == math.floor(dd.y / self.TileSize))) then
				fail = true
			end
		end
		if(self.Tiles[tileY][tileX+1] ~= nil) and (not fail) then --check it exists first?
			local t = self.Tiles[tileY][tileX+1]
			if(t.TileID ~= 1 or
			(t.x == math.floor(ld.x / self.TileSize) and t.y == math.floor(ld.y / self.TileSize)) or
			(t.x == math.floor(dd.x / self.TileSize) and t.y == math.floor(dd.y / self.TileSize))) then
				fail = true
			end
		end
		
		if(not fail) then
			--actually "build" the furniture
			self.Tiles[tileY][tileX]:Change(6, roomID, false)
			self.Tiles[tileY+1][tileX+1]:Change(6, roomID, false)
			self.Tiles[tileY][tileX+1]:Change(6, roomID, false)
			self.Tiles[tileY+1][tileX]:Change(6, roomID, false)
			
			--add these new non-passables to Bump!
			bump.add(self.Tiles[tileY][tileX])
			bump.add(self.Tiles[tileY+1][tileX+1])
			bump.add(self.Tiles[tileY][tileX+1])
			bump.add(self.Tiles[tileY+1][tileX])
			
			self.rocketx = tileX*self.TileSize + 16 - 45
			self.rockety = tileY*self.TileSize + 32 - 177
			
			self.LaunchPadVisible = true
		end
	until(not fail)
	
	self:updateSpriteBatch()
end

function Map:placeFurniture(roomID, x, y)
	self.Furniture[roomID] = {}
	local nFurniture = math.random(3)
	local walls = { "N", "E", "N", "W" } --north wall can have 2 :)
	
	for f=1,nFurniture do
		local fail = false
		repeat
			fail = false --reset the condition (optimistic!)
			
			--pick a wall that's still available
			local iWall = math.random(#walls)
			local wall = walls[iWall]
			
			--get a random tile against the wall
			local tileY, tileX
			if(wall == "N") then
				tileY = y+3
				tileX = math.random(x, x+self.rWidth-1)
			elseif(wall == "E") then
				tileX = x+self.rWidth-1
				tileY = math.random(y, y+self.rHeight-1)
			elseif(wall == "W") then
				tileX = x+1
				tileY = math.random(y, y+self.rHeight-1)
			end
			local t = self.Tiles[tileY][tileX]
			
			--check if it's a suitable furniture place
			if(t.TileID ~= 1 or t.FurnitureID ~= 0) then fail = true end --gotta be floor
			if(t == self.LiteSpawn or t == self.DarkSpawn) then fail = true end --avoid spawns
			
			--now check surroundings to ensure we don't block doors etc
			if(self.Tiles[tileY-1] ~= nil) and (not fail) then --check it exists first?
				if((self.Tiles[tileY-1][tileX] == self.LiteSpawn) or
					self.Tiles[tileY-1][tileX] == self.DarkSpawn or
					self.Tiles[tileY-1][tileX].FurnitureID ~= 0) then
					fail = true
				end
			end
			if(self.Tiles[tileY-2] ~= nil) and (not fail) then --check it exists first?
				if((self.Tiles[tileY-2][tileX].RoomID ~= roomID and
					self.Tiles[tileY-2][tileX].TileID ~= 2) or
					self.Tiles[tileY-2][tileX].FurnitureID ~= 0) then
					fail = true
				end
			end
			if(self.Tiles[tileY][tileX+1] ~= nil) and (not fail) then --check it exists first?
				if((self.Tiles[tileY][tileX+1].RoomID ~= roomID and
					self.Tiles[tileY][tileX+1].TileID ~= 2) or
					self.Tiles[tileY][tileX+1].FurnitureID ~= 0) then
					fail = true
				end
			end
			if(self.Tiles[tileY+1] ~= nil) and (not fail) then --check it exists first?
				if((self.Tiles[tileY+1][tileX].RoomID ~= roomID and
					self.Tiles[tileY+1][tileX].TileID ~= 2) or
					self.Tiles[tileY+1][tileX].FurnitureID ~= 0) then
					fail = true
				end
			end
			if(self.Tiles[tileY][tileX-1] ~= nil) and (not fail) then --check it exists first?
				if((self.Tiles[tileY][tileX-1].RoomID ~= roomID and
					self.Tiles[tileY][tileX-1].TileID ~= 2) or
					self.Tiles[tileY][tileX-1].FurnitureID ~= 0) then
					fail = true
				end
			end
			
			if(not fail) then
				--actually "build" the furniture
				self.Tiles[tileY][tileX]:Change(5, roomID, false)
				self.Tiles[tileY][tileX].FurnitureID = f
				self.Tiles[tileY-1][tileX]:Change(4, roomID, false)
				self.Tiles[tileY-1][tileX].FurnitureID = f
				--set its items to nothing by default
				self.Furniture[roomID][f] = {
					hasDoggyBag = false,
					hasWallet = false,
					hasAstrosuit = false,
					hasChewtoy = false,
					hasKibbles = false,
				}
				table.remove(walls,iWall)
			end
		until(not fail)
	end
end

function Map:buildDoorways(x, y)
	--connect up to 2 doors, if possible
	local roomSides = {}
	local i = 1
	if(self.Tiles[y-self.rHeight] ~= nil) then --check it exists first?
		if(self.Tiles[y-self.rHeight][x].RoomID ~= 0) then
			roomSides[i] = "N"
			i = i + 1
		end
	end
	if(self.Tiles[y][x+self.rWidth] ~= nil) then --check it exists first?
		if(self.Tiles[y][x+self.rWidth].RoomID ~= 0) then
			roomSides[i] = "E"
			i = i + 1
		end
	end
	if(self.Tiles[y+self.rHeight] ~= nil) then --check it exists first?
		if(self.Tiles[y+self.rHeight][x].RoomID ~= 0) then
			roomSides[i] = "S"
			i = i + 1
		end
	end
	if(self.Tiles[y][x-self.rWidth] ~= nil) then --check it exists first?
		if(self.Tiles[y][x-self.rWidth].RoomID ~= 0) then
			roomSides[i] = "W"
			i = i + 1
		end
	end
	
	local iSide, side1, side2 = nil, nil, nil
	iSide = math.random(#roomSides)
	side1 = roomSides[iSide]
	if(side1) then table.remove(roomSides,iSide) end --guarantee the same wall can't be rechosen
	if(math.random(2) == 1) then --second is optional
		iSide = math.random(#roomSides)
		side2 = roomSides[iSide]
	end
	
	if(side1 ~= nil) then self:buildDoorway(x, y, side1) end --first door is guaranteed, except for first room!
	if(side2 ~= nil) then self:buildDoorway(x, y, side2) end
	
end

function Map:buildDoorway(x, y, side)
	if(side == "N") then
		doorPos = math.random(2,self.rWidth - 2)
		self.Tiles[y][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y][x+doorPos]:Change(1,0,true)
		self.Tiles[y+1][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y+1][x+doorPos]:Change(1,0,true)
		self.Tiles[y+2][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y+2][x+doorPos]:Change(1,0,true)
	elseif(side == "E") then
		doorPos = math.random(5,self.rHeight)
		self.Tiles[y+doorPos-1][x+self.rWidth]:Change(1,0,true)
		self.Tiles[y+doorPos-2][x+self.rWidth]:Change(1,0,true)
		self.Tiles[y+doorPos-3][x+self.rWidth]:Change(3,0,false)
		self.Tiles[y+doorPos-4][x+self.rWidth]:Change(3,0,false)
	elseif(side == "S") then
		doorPos = math.random(2,self.rWidth - 2)
		self.Tiles[y+self.rHeight][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y+self.rHeight][x+doorPos]:Change(1,0,true)
		self.Tiles[y+self.rHeight+1][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y+self.rHeight+1][x+doorPos]:Change(1,0,true)
		self.Tiles[y+self.rHeight+2][x+doorPos-1]:Change(1,0,true)
		self.Tiles[y+self.rHeight+2][x+doorPos]:Change(1,0,true)
	elseif(side == "W") then
		doorPos = math.random(5,self.rHeight)
		self.Tiles[y+doorPos-1][x]:Change(1,0,true)
		self.Tiles[y+doorPos-2][x]:Change(1,0,true)
		self.Tiles[y+doorPos-3][x]:Change(3,0,false)
		self.Tiles[y+doorPos-4][x]:Change(3,0,false)
	end
end

function Map:BuildExteriorWalls()
	--check all empty tiles to see if they should be walls!
	for i=1, #self.Tiles do
		for j=1, #self.Tiles[i] do
			t = self.Tiles[i][j]
			if(t.TileID == 0) then
				--check to see if we're bordering a room to the top left?
				local border = false
				--top
				if(self.Tiles[i-1] ~= nil) then --check it exists first?
					if(self.Tiles[i-1][j].RoomID ~= 0) then
						border = true
					end
				end
				--left
				if(self.Tiles[i][j-1] ~= nil and not border) then --check it exists first?
					if(self.Tiles[i][j-1].RoomID ~= 0) then
						border = true
					end
				end
				--top-left corner
				if(self.Tiles[i-1] ~= nil and not border) then --check it exists first?
					if(self.Tiles[i-1][j-1] ~= nil) then
						if(self.Tiles[i-1][j-1].RoomID ~= 0) then
							border = true
						end
					end
				end
				if(border) then t.TileID = 2 end --update tile id, but not room!
			end
		end
	end
	--check empty tiles to see if they should now be wall edges!
	for i=1, #self.Tiles do
		for j=1, #self.Tiles[i] do
			t = self.Tiles[i][j]
			if(t.TileID == 0) then
				--check to see if we're bordering a wall top above?
				if(self.Tiles[i-1] ~= nil) then --check it exists first?
					if(self.Tiles[i-1][j].TileID == 2) then
						t.TileID = 3
						self.Tiles[i+1][j].TileID = 3 --also update the tile below!
					end
				end
			end
		end
	end
end

function Map:Clear()
	self.LaunchPadVisible = false
	
	self.LiteSpawn = nil
	self.DarkSpawn = nil
	
	--first remove old collidable tiles from Bump
	for i=1, #self.Tiles do
		for j=1, #self.Tiles[i] do
			t = self.Tiles[i][j]
			if(not t.Passable) then bump.remove(t) end
		end
	end
	
	for k,v in pairs(self.Tiles) do
	  self.Tiles[k] = nil
	end
end

function Map:Trim()
	local startX, startY, endX, endY = -1, -1, 0, 0
	--first evaluate map bounds
	for i=1, #self.Tiles do
		for j=1, #self.Tiles[i] do
			t = self.Tiles[i][j]
			if(t.TileID ~= 0) then
				if(startY == -1 or startY > t.y) then startY = t.y end
				if(startX == -1 or startX > t.x) then startX = t.x end
				if(endX < t.x) then endX = t.x end
				if(endY < t.y) then endY = t.y end
			end
		end
	end
	
	--build a new clean array of only the tiles area, and update tile coords
	local newTiles = {}
	for i=startY, endY do
		local y = i-startY+1
		newTiles[y] = {}
		for j=startX, endX do
			local t = self.Tiles[i][j]
			local x = j-startX+1
			t.x = x
			t.y = y
			newTiles[y][x] = t
		end
	end
	
	--abandon the old table in favour of the new
	self.Tiles = newTiles	
end

function Map:chooseRoomLocation(x, y)
	local availSides = {}
	local i = 1
	if(self.Tiles[y-self.rHeight] ~= nil) then --check it exists first?
		if(self.Tiles[y-self.rHeight][x].RoomID == 0) then
			availSides[i] = "N"
			i = i + 1
		end
	end
	if(self.Tiles[y][x+self.rWidth] ~= nil) then --check it exists first?
		if(self.Tiles[y][x+self.rWidth].RoomID == 0) then
			availSides[i] = "E"
			i = i + 1
		end
	end
	if(self.Tiles[y+self.rHeight] ~= nil) then --check it exists first?
		if(self.Tiles[y+self.rHeight][x].RoomID == 0) then
			availSides[i] = "S"
			i = i + 1
		end
	end
	if(self.Tiles[y][x-self.rWidth] ~= nil) then --check it exists first?
		if(self.Tiles[y][x-self.rWidth].RoomID == 0) then
			availSides[i] = "W"
			i = i + 1
		end
	end
	
	local side = availSides[math.random(#availSides)]
	local newX, newY = 0, 0
		
	--set new co-ords based on the side chosen
	if(side == "N") then
		newY = y - self.rHeight
		newX = x
	elseif(side == "E") then
		newX = x + self.rWidth
		newY = y
	elseif(side == "S") then
		newY = y + self.rHeight
		newX = x
	elseif(side == "W") then
		newX = x - self.rWidth
		newY = y
	end --if side wasn't set, then none were available; we check if input x/y matches output x/y outside of here.
	
	return newX, newY
end

function Map:createRoom(roomID, x, y)
	local tileID, passable
	local spriteindex = math.random(7)
	
	for i=1, self.rHeight do
		for j=1, self.rWidth do
			
			if(i == 1 or j == 1) then tileID, passable = 2, false --wall top
			elseif(i == 2 or i == 3) then tileID, passable = 3, false --wall side
			else tileID, passable = 1, true end --floor tile
			local t = self.Tiles[i+y-1][j+x-1]
			t:Change(tileID, roomID, passable)
			t.SpriteIndex = spriteindex
			
			if(roomID == 1) then --add spawns
				if(i == 5 and j == 3) then
					self.LiteSpawn = t
				end
				if(i == 5 and j == 7) then
					self.DarkSpawn = t
				end
			end
		end
	end
end

function Map:Draw()
	love.graphics.draw(self.TileBatch, self.TileSize, self.TileSize, 0, 1, 1)	
	--[[debug - draw collision tiles 
	for i=1, #self.Tiles do
		for j=1, #self.Tiles[i] do
			
			self.Tiles[i][j]:DrawBound()
		end
	end--]]
end

function Map:DrawRocket() -- gotta go on top of everything else!
	if(self.LaunchPadVisible) then love.graphics.draw(self.RocketSprite, self.RocketQuad, self.rocketx, self.rockety) end --draw the rocket on the pad ;)
end
