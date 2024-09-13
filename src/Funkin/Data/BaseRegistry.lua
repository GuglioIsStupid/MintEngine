---@class BaseRegistry
local BaseRegistry = Class:extend()

function BaseRegistry:new(registryId, dataFilePath, versionRule)
    self.registryId = registryId
    self.dataFilePath = dataFilePath
    self.versionRule = versionRule
    
    self.entries = {}
    self.scriptedEntryIds = {}
end

function BaseRegistry:loadEntries()
    self:clearEntries()
end

function BaseRegistry:clearEntries()
    self.entries = {}
    self.scriptedEntryIds = {}
end

function BaseRegistry:fetchEntry(id)
    return self.entries[id]
end

function BaseRegistry:createEntry(id)
    ---@diagnostic disable-next-line: undefined-field
    return self.generic and self.generic(id) or BaseRegistry(id)
end

return BaseRegistry