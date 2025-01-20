local path = ...

local function r(p)
    return unpack {require(path .. "." .. p)}
end

Constants = r("util.Constants")
Paths = r("Paths")
Conductor = r("Conductor")

DataAssets = r("Util.Assets.DataAssets")

BaseRegistry = r("Data.BaseRegistry")
SongMetadata = r("Data.Song.SongData")
Song = r("Play.Song.Song")
VersionUtil = r("Util.VersionUtil")
SongRegistry = r("Data.Song.SongRegistry")()

SoundGroup = r("Audio.SoundGroup")
VoicesGroup = r("Audio.VoicesGroup")
FunkinSound = r("Audio.FunkinSound")

MenuTypedList = r("UI.MenuList")
AtlasMenuItem = r("UI.AtlasMenuList")

MusicBeatState = r("UI.MusicBeatState")

TitleState = r("UI.Title.TitleState")
MainMenuState = r("UI.MainMenu.MainMenuState")
PlayState = r("Play.PlayState")

r("Modding.Events.ScriptEvent")