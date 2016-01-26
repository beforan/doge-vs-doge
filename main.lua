Gamestate = require("lib.hump.gamestate")
Class = require("lib.hump.class")
Camera = require("lib.hump.camera")
Bump = require("lib.bump")
Gui = require("lib.quickie")

--other libraries
require("lib.AnAL")

--my classes
require("settings")
require("classes.doge")
require("classes.tile")
require("classes.map")

--gamestates
require("states.menu")
require("states.game")
require("states.pause")
require("states.end")
require("states.about")
require("states.howto")

--globals?
fonts = {}

function love.load()
	math.randomseed(os.time())
	
	--music :) we don't change on state changes, so may as well global these
	playlist = {
		love.audio.newSource("assets/whoop.mp3")
	}
	bgm = {
		Play = function(self, playlist)
			if self.source ~= nil then love.audio.stop(self.source) end
			self.source = playlist[math.random(#playlist)]
			self.source:setLooping(false)
			love.audio.play(self.source)
		end,
		source = playlist[math.random(#playlist)],
	}
	--]]

	settings = Settings()
	
	--gui defaults?
	Gui.group.default.size[1] = 150
	Gui.group.default.spacing = 5
	
	--load fonts
	fonts[14] = love.graphics.newFont("/assets/comic.ttf", 14)
	fonts[16] = love.graphics.newFont("/assets/comic.ttf", 16)
	fonts[22] = love.graphics.newFont("/assets/comic.ttf", 22)
	fonts[72] = love.graphics.newFont("/assets/comic.ttf", 72)
	fonts[120] = love.graphics.newFont("/assets/comic.ttf", 120)
	--set default font
	love.graphics.setFont(fonts[14]);
	
	--register callbacks and run a gamestate!
	Gamestate.registerEvents()
	Gamestate.switch(stMenu)
end

function love.update(dt)
	--music
	s = bgm.source
	if(not s:isPlaying() and not s:isPaused()) then
		bgm:Play(playlist)
	end --keep the music shuffling]]
end

function love.keypressed(key, unicode)
	Gui.keyboard.pressed(key)
end

--bump callbacks
function Bump.getBBox(item)
	if(item.getBBox == nil) then
		return item.x, item.y, item.width, item.height
	else
		return item:getBBox()
	end
end

function Bump.collision(item1, item2, dx, dy)
	if(item1.Collision ~= nil) then item1:Collision(item2,dx,dy) end
	if(item2.Collision ~= nil) then item2:Collision(item1,-dx,-dy) end
end

function Bump.endCollision(item1, item2)
  if(item1.Vulnerable ~= nil) then item1.Vulnerable = false end
  if(item2.Vulnerable ~= nil) then item2.Vulnerable = false end
end

function getDogeism()
	dogeisms = {
		"such", "very", "many", "much", "so"
	}
	return dogeisms[math.random(#dogeisms)]
end

function tileSet(tileSprites)
	local result = love.image.newImageData(#tileSprites*tileSprites[1]:getWidth(),tileSprites[1]:getHeight())
	
	for i, sprite in ipairs(tileSprites) do
		result:paste(
			sprite:getData(),
			(i-1)*sprite:getWidth(),0,
			0,0,sprite:getWidth(),sprite:getHeight()
		)
	end
	result = love.graphics.newImage(result)
	result:setFilter('linear', 'linear')
	return result
end

function flatSprite(r, g, b, w, h)
	w = w*3
	h = h*3
	local result = love.image.newImageData(w, h)
	
	for i=0, h-1 do
		for j=0, w-1 do
			result:setPixel(j, i, {r, g, b})
		end
	end
	result = love.graphics.newImage(result)
	result:setFilter('linear', 'linear')
	return result
end