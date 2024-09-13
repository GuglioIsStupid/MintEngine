local path = ...

local function r(p)
    return require(path .. "." .. p)
end

Constants = r("util.Constants")
Paths = r("Paths")
Conductor = r("Conductor")

DataAssets = r("Util.Assets.DataAssets")

BaseRegistry = r("Data.BaseRegistry")
SongRegistry = r("Data.Song.SongRegistry")()

SoundGroup = r("Audio.SoundGroup")
VoicesGroup = r("Audio.VoicesGroup")
FunkinSound = r("Audio.FunkinSound")()

MusicBeatState = r("UI.MusicBeatState")

SongMetadata, SongTimeChange, SongOffsets = r("Data.Song.SongData")

TitleState = r("Title.TitleState")
PlayState = r("Play.PlayState")