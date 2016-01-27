--bump callback overrides
local bump = require "lib.bump"

function bump.getBBox(item)
	if(item.getBBox == nil) then
		return item.x, item.y, item.width, item.height
	else
		return item:getBBox()
	end
end

function bump.collision(item1, item2, dx, dy)
	if(item1.Collision ~= nil) then item1:Collision(item2,dx,dy) end
	if(item2.Collision ~= nil) then item2:Collision(item1,-dx,-dy) end
end

function bump.endCollision(item1, item2)
  if(item1.Vulnerable ~= nil) then item1.Vulnerable = false end
  if(item2.Vulnerable ~= nil) then item2.Vulnerable = false end
end