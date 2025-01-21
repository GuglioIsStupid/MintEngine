local NoteStyle = Class:extend()

function NoteStyle:new(id)
    self.id = id
    self._data = self:_fetchData(id)
end

function NoteStyle:_fetchData(id)
    return NoteStyleRegistry:getInstance():parseEntryDataWithMigration(id, NoteStyleRegistry:getInstance():fetchEntryVersion())
end