---@class SongRegistry : BaseRegistry
local SongRegistry = BaseRegistry:extend()

SongRegistry.generic = Song

function SongRegistry:loadEntries()
    self:clearEntries()

    local entryIdList = DataAssets:listDataFilesInPath("songs/", "-metadata.json"):map(function(songDataPath)
        return songDataPath:split("/")[1]
    end)

    local unscriptedDataEntryIds = entryIdList:filter(function(id)
        return not self.entries[id]
    end)

    for _, id in ipairs(unscriptedDataEntryIds) do
        local ok, entryData = pcall(function()
            local entry = self:createEntry(id)
            if entry then
                self.entries[id] = entry
            end
        end)

        if not ok then
            print("Error loading song data for " .. id .. ": " .. entryData)
        end
    end
end

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