local fonts = {
  [14] = love.graphics.newFont("/assets/comic.ttf", 14),
  [16] = love.graphics.newFont("/assets/comic.ttf", 16),
  [22] = love.graphics.newFont("/assets/comic.ttf", 22),
  [72] = love.graphics.newFont("/assets/comic.ttf", 72),
  [120] = love.graphics.newFont("/assets/comic.ttf", 120)
}

fonts.default = fonts[14]

return fonts