local music = {
  playlist = {},
  play = function(self)
    if self.source ~= nil then love.audio.stop(self.source) end
    self.source = self.playlist[math.random(#self.playlist)]
    self.source:setLooping(false)
    love.audio.play(self.source)
  end
}


local files = require "assets.playlist"

for _, v in ipairs(files) do
  table.insert(music.playlist, love.audio.newSource(v))
end

-- Initialise with a random track
music.source = music.playlist[]math.random(#music.playlist)]

return music