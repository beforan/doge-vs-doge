Tile = Class {
	init = function(self, x, y, w, h, tile, room, passable)
		self.name = "tileface"
		self.x = x
		self.y = y
		self.width = w
		self.height = h
		self.TileID = tile or 0
		self.RoomID = room or 0
		self.Passable = (passable ~= nil and passable) or false
	end,
	RealX = function(self)
		return (self.x)*self.width
	end,
	RealY = function(self)
		return (self.y)*self.height
	end,
	SpriteIndex = 1,
	FurnitureID = 0,
}

--Bumpy bits
function Tile:DrawBound()
	love.graphics.setColor(0,255,0,255)
	if(not self.Passable) then love.graphics.rectangle("fill",self:getBBox()) end
end

function Tile:shouldCollide() --tiles don't collide with each other
	return false
end

function Tile:getBBox()
	return self:RealX(), self:RealY(), self.width, self.height
end

function Tile:Change(tile, room, passable)
	self.TileID = tile or self.TileID
	self.RoomID = room or self.RoomID
	self.Passable = passable
end
