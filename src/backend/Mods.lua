-- TODO

local Mods = {}
Mods.currentModDirectory = ""

Mods.ignoreModFolders = {
    "characters",
    "custom_events",
    "custom_notetypes",
    "data",
    "songs",
    "music",
    "sounds",
    "shaders",
    "videos",
    "images",
    "stages",
    "weeks",
    "fonts",
    "scripts",
    "achievements"
}

Mods.globalMods = {}

function Mods:getGlobalMods()
    return self.globalMods
end

function Mods:pushGlobalMods()
    self.globalMods = {}

    for i, mod in ipairs(self:parseList().enabled) do
        local pack = self:getPack(mod)
        if pack ~= nil and pack.runsGlobally then
            table.insert(self.globalMods, mod)
        end
    end
    return self.globalMods
end

function Mods:getModDirectories()
    local list = {}
    if MODS_ALLOWED then
        local modsFolder = Paths.mods()
        if love.filesystem.getInfo(modsFolder) then
            for i, modFolder in ipairs(love.filesystem.getDirectoryItems(modsFolder)) do
                local path = modsFolder .. modFolder
                if love.filesystem.getInfo(path) and love.filesystem.getInfo(path).type == "directory" and 
                    not table.contains(self.ignoreModFolders, modFolder:lower()) and not table.contains(list, modFolder) then

                    table.insert(list, modFolder)
                end
            end
        end
    end
    return list
end

function Mods:mergeAllTextsNamed(path, defaultDirectory, allowDuplicates)
    local allowDuplicates = allowDuplicates or false

    if not defaultDirectory then
        defaultDirectory = "assets/"
    end
    defaultDirectory = defaultDirectory:trim()
    if not defaultDirectory:endsWith("/") then
        defaultDirectory = defaultDirectory .. "/"
    end
    
    local mergedList = {}
    local paths = self:directoriesWithFile(defaultDirectory, path)
    
    local defaultPath = defaultDirectory .. path
    if table.contains(paths, defaultPath) then
        table.remove(paths, table.indexOf(paths, defaultPath))
        table.insert(paths, 1, defaultPath)
    end

    for i, file in ipairs(paths) do
        local list = love.filesystem.lines(file)
        for i2, value in ipairs(list) do
            if (allowDuplicates or not table.contains(mergedList, value)) and #valeu > 0 then
                table.insert(mergedList, value)
            end
        end
    end

    return mergedList
end

function Mods:directoriesWithFile(path, fileToFind, mods)
    local mods = (mods == nil) and true or mods
    local foldersToCheck = {}

    if love.filesystem.getInfo(path .. fileToFind) then
        table.insert(foldersToCheck, path .. fileToFind)
    end

    if MODS_ALLOWED then
        if mods then
            for o, mod in ipairs(self:getGlobalMods()) do
                local folder = Paths.mods(mod .. "/" .. fileToFind)
                if love.filesystem.getInfo(folder) then
                    table.insert(foldersToCheck, folder)
                end
            end

            local folder = Paths.mods(fileToFind)
            if love.filesystem.getInfo(folder) then
                table.insert(foldersToCheck, folder)
            end
            
            if self.currentModDirectory and #self.currentModDirectory > 0 then
                local folder = Paths.mods(self.currentModDirectory .. "/" .. fileToFind)
                if love.filesystem.getInfo(folder) then
                    table.insert(foldersToCheck, folder)
                end
            end
        end
    end

    return foldersToCheck
end

function Mods:getPack(folder)
    if MODS_ALLOWED then
        if not folder then folder = self.currentModDirectory end

        local path = Paths.mods(folder .. "/pack.json")
        local rawJson
        if love.filesystem.getInfo(path) then
            TryExcept(
                function()
                    return json.decode(love.filesystem.read(path))
                end,
                function(err)
                    print("Error loading pack.json for " .. folder .. ": " .. err)
                end
            )
        end
    end
    return nil
end

Mods.updatedOnstate = false
function Mods:parseList()
    if not self.updatedOnstate then self:updateModList() end
    local list = {enabled = {}, disabled = {}, all = {}}

    if MODS_ALLOWED then
        TryExcept(
            function()
                for mod in love.filesystem.lines("modsList.txt") do
                    if #mod < 1 then goto continue end

                    local dat = mod:split("|")
                    table.insert(list.all, dat[1])
                    if dat[2] == "1" then
                        table.insert(list.enabled, dat[1])
                    else
                        table.insert(list.disabled, dat[1])
                    end

                    ::continue::
                end
            end,
            function(err)
                print(err)
            end
        )
    end

    return list
end

function Mods:updateModList()
    if MODS_ALLOWED then
        local list = {}
        local added = {}
        TryExcept(
            function()
                for mod in love.filesystem.lines("modsList.txt") do
                    local dat = mod:split("|")
                    local folder = dat[1]
                    if #folder:trim() > 0 and love.filesystem.getInfo(Paths.mods(folder)) and love.filesystem.getInfo(Paths.mods(folder)).type == "directory" 
                        and not table.contains(added, folder) then
                        
                        table.insert(added, folder)
                        table.insert(list, {folder, (dat[2] == "1")})
                    end
                end
            end,
            function(err)
                print(err)
            end
        )

        for i, folder in ipairs(self:getModDirectories()) do
            if #folder:trim() > 0 and love.filesystem.getInfo(Paths.mods(folder)) and love.filesystem.getInfo(Paths.mods(folder)).type == "directory" 
                and not table.contains(added, folder) and not table.contains(self.ignoreModFolders, folder:lower()) then
                table.insert(added, folder)
                table.insert(list, {folder, true})
            end
        end

        local fileStr = ""
        for i, values in ipairs(list) do
            if #fileStr > 0 then fileStr = fileStr .. "\n" end
            fileStr = fileStr .. values[1] .. "|" .. (values[2] and "1" or "0")
        end

        love.filesystem.write("modsList.txt", fileStr)
        self.updatedOnstate = true
    end
end

function Mods.loadTopMod()
    Mods.currentModDirectory = ""

    if MODS_ALLOWED then
        local list = Mods:parseList().enabled
        if list and list[1] then
            Mods.currentModDirectory = list[1]
        end
    end
end

return Mods