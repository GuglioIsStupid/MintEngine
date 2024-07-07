local path = ...

local function r(p)
    return require(path .. "." .. p)
end

Constants = r("util.Constants")
Paths = r("Paths")
Conductor = r("Conductor")

MusicBeatState = r("UI.MusicBeatState")

TitleState = r("Title.TitleState")

SongMetadata, SongTimeChange = r("Data.Song.SongData")