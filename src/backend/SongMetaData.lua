local SongMetaData = Object:extend()

SongMetaData.songName = ""
SongMetaData.week = 0
SongMetaData.songCharacter = ""
SongMetaData.color = -7179779
SongMetaData.folder = ""
SongMetaData.lastDifficulty = nil

function SongMetaData:new(song, week, songCharacter, color)
    self.songName = song
    self.week = week
    self.songCharacter = songCharacter
    self.color = color
    self.lastDifficulty = Difficulty.Easy
    self.folder = Mods.currentModDirectory
    if not self.folder then self.folder = "" end
end

return SongMetaData