-- Reusable version of the colour cycling background used in several states
-- essentially a singleton

local bg = {
  t = 0,
  grad1top = 0, --top co-ords of the first background instance
	grad2top = love.graphics.getHeight(), --top co-ords of the second (sadly we have to track both)
	speed = 200
}

-- Callbacks
function bg:update(dt)
  --shader updates
	self.t = self.t + math.min(dt, 1/30)
	self.shader:send("time", self.t)
	
	--update backgrounds pos
	local screenh = love.graphics.getHeight()
	self.grad1top = self.grad1top - self.speed * dt
	self.grad2top = self.grad1top + screenh
	if self.grad1top + screenh <= 0 then
		local dy = self.grad1top + screenh*2
		self.grad1top = screenh - dy
	elseif self.grad1top >= screenh then
		local dy = self.grad1top - screenh*2
		self.grad1top = dy
	end
	if self.grad2top + screenh <= 0 then
		local dy = self.grad2top + screenh*2
		self.grad2top = screenh - dy
	elseif self.grad2top >= screenh then
		local dy = self.grad2top - screenh*2
		self.grad2top = dy
	end
end

function bg:draw()
  --draw background
	love.graphics.setShader(self.shader)
	self.drawinrect(self.background, 0, self.grad1top, love.graphics.getWidth(), love.graphics.getHeight())
	self.drawinrect(self.background, 0, self.grad1top+love.graphics.getHeight(), love.graphics.getWidth(), love.graphics.getHeight())
	
	love.graphics.setShader()
end



-- Helpers
function bg.gradient(colors)
    local direction = colors.direction or "horizontal"
    if direction == "horizontal" then
        direction = true
    elseif direction == "vertical" then
        direction = false
    else
        error("Invalid direction '" .. tostring(direction) "' for gradient.  Horizontal or vertical expected.")
    end
    local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
    for i, color in ipairs(colors) do
        local x, y
        if direction then
            x, y = 0, i - 1
        else
            x, y = i - 1, 0
        end
        result:setPixel(x, y, color[1], color[2], color[3], color[4] or 255)
    end
    result = love.graphics.newImage(result)
    result:setFilter('linear', 'linear')
    return result
end

function bg.drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
    return -- tail call for a little extra bit of efficiency
    love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

bg.shaders = {
  pixel = [[
    extern number time;
    number t;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc)
    {
      t = time * 1.5;
      color = Texel(tex, tc);
      return vec4(vec3(sin(t + 5)+0.3, -sin(t+5)+0.3, sin(t + 10)) * (max(color.r, max(color.g, color.b))), 1.0);
    }
  ]],
  vertex= [[
    varying vec4 vpos;
		
		vec4 position( mat4 transform_projection, vec4 vertex_position )
    {
      vpos = vertex_position;
      return transform_projection * vertex_position;
    }
  ]]
}
bg.shader = love.graphics.newShader(bg.shaders.pixel,bg.shaders.vertex)

bg.background = bg.gradient { { 150, 150, 150 }, { 255, 255, 255 }, { 150, 150, 150 } }

return bg