-- include utility classes
local bgm = require "utils.music"

-- include asset scripts
local fonts = require "assets.fonts"

-- register bump callbacks
local bump = require "lib.bump" --require the library first time
local bumpCallbacks = require "utils.bump" --so we can override callbacks

Gamestate = require("lib.hump.gamestate")
Class = require("lib.hump.class")
Camera = require("lib.hump.camera")
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

function love.load()
	math.randomseed(os.time())

	settings = Settings()
	
	--gui defaults?
	Gui.group.default.size[1] = 150
	Gui.group.default.spacing = 5
  
	--set default font
	love.graphics.setFont(fonts.default);
	
	--register callbacks and run a gamestate!
	Gamestate.registerEvents()
	Gamestate.switch(stMenu)
end

function love.update(dt)
	--music
	s = bgm.source
	if(not s:isPlaying() and not s:isPaused()) then
		bgm:play()
	end --keep the music shuffling]]
end

function love.keypressed(key, unicode)
	Gui.keyboard.pressed(key)
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