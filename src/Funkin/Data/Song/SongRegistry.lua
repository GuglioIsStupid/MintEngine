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

function SongRegistry:parseMusicData(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION
    local jsonData = SongRegistry:loadMusicDataFile(id, variation)
    local data = Json.decode(jsonData.contents)

    return data
end

function SongRegistry:loadMusicDataFile(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION
    local entryFilePath = Paths.file("music/" .. id .. "/" .. id .. "-metadata" .. (variation == Constants.DEFAULT_VARIATION and "" or ("-" .. variation)) .. ".json")
    return {
        fileName = entryFilePath,
        contents = love.filesystem.read(entryFilePath)
    }
end

function SongRegistry:loadEntryMetadataFile(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION

    local entryFilePath = Paths.file("data/songs/" .. id .. "/" .. id .. "-metadata" .. (variation == Constants.DEFAULT_VARIATION and "" or ("-" .. variation)) .. ".json")
    print(entryFilePath)
    return {
        fileName = entryFilePath,
        contents = love.filesystem.read(entryFilePath)
    }
end

function SongRegistry:fetchEntryMetadataVersion(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION
    local jsonData = SongRegistry:loadEntryMetadataFile(id, variation)
    local data = Json.decode(jsonData.contents)

    return data.version
end

function SongRegistry:parseEntryMetadata(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION
    local jsonData = SongRegistry:loadEntryMetadataFile(id, variation)
    local data = Json.decode(jsonData.contents)

    return self:cleanMetadata(data, variation)
end

function SongRegistry:parseEntryMetadata_v2_1_0(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION
    local jsonData = SongRegistry:loadEntryMetadataFile(id, variation)
    local data = Json.decode(jsonData.contents)

    return self:cleanMetadata(data, variation)
end

function SongRegistry:parseEntryMetadata_v2_0_0(id, variation)
    local variation = variation or Constants.DEFAULT_VARIATION
    local jsonData = SongRegistry:loadEntryMetadataFile(id, variation)
    local data = Json.decode(jsonData.contents)

    return self:cleanMetadata(data, variation)
end

local SONG_METADATA_VERSION_RILE = "2.2.x"
function SongRegistry:parseEntryMetadataWithMigration(id, variation, version)
    local variation = variation or Constants.DEFAULT_VARIATION

    if SONG_METADATA_VERSION_RILE == nil or VersionUtil:validateVersion(version, SONG_METADATA_VERSION_RILE) then
        return self:parseEntryMetadata(id, variation)
    elseif VersionUtil:validateVersion(version, "2.1.x") then
        return self:parseEntryMetadata_v2_1_0(id, variation)
    elseif VersionUtil:validateVersion(version, "2.0.x") then
        return self:parseEntryMetadata_v2_0_0(id, variation)
    else
        return self:parseEntryMetadata(id, variation)
    end

    --[[ return self:parseEntryMetadata(id, variation) ]]
end

function SongRegistry:cleanMetadata(data, variation)
    data.variation = variation

    return data
end

return SongRegistry