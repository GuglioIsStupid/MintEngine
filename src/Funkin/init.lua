local path = ...

local function r(p)
    return require(path .. "." .. p)
end

Constants = r("util.Constants")
Paths = r("Paths")
Conductor = r("Conductor")

SongRegistry = r("Data.Song.SongRegistry")
FunkinSound = r("Audio.FunkinSound")()

MusicBeatState = r("UI.MusicBeatState")

TitleState = r("Title.TitleState")

SongMetadata, SongTimeChange = r("Data.Song.SongData")