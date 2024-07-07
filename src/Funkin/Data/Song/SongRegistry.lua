---@class SongRegistry
local SongRegistry = {}

function SongRegistry.parseMusicData(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION

    local jsonData = SongRegistry.loadMusicDataFile(id, variation)

    local data = Json.decode(jsonData.contents)

    return data
end

function SongRegistry.loadMusicDataFile(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION

    local entryFilePath = Paths.file("music/" .. id .. "/" .. id .. "-metadata" .. (variation == Constants.DEFAULT_VARIATION and "" or ("-" .. variation)) .. ".json")

    return {
        fileName = entryFilePath,
        contents = love.filesystem.read(entryFilePath)
    }
end

return SongRegistry