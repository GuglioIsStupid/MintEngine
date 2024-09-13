---@class SongMetadata
local SongMetadata = Class:extend()

---@class SongTimeChange
SongTimeChange = Class:extend()

---@class SongOffsets
SongOffsets = Class:extend()

function SongOffsets:getVocalOffset()
    return 0
end

return SongMetadata