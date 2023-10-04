local Paths = {}

Paths.imageType = "dds"

function Paths.getPath(file, modsAllowed)
    if MODS_ALLOWED then
        if modsAllowed then
            local modded = Paths.modFolders(file)
            if love.filesystem.getInfo(modded) then
                return modded
            end
        end
    end

    return "assets/" .. file
end

function Paths.image(path)
    local file = nil
    if MODS_ALLOWED then
        file = Paths.modsImages(path)
        if Cache.members.image[file] then
            return Cache.members.image[file]
        elseif Cache.members.preload.image[file] then
            return Cache.members.preload.image[file]
        elseif love.filesystem.getInfo(file) then
            Cache.members.image[file] = love.graphics.newImage(file)
            return Cache.members.image[file]
        end
    end
    local path_ = "assets/images/" .. Paths.imageType .. "/" .. path .. "." .. Paths.imageType
    if not love.filesystem.getInfo(path_) then
        path_ = "assets/images/png/" .. path .. ".png"
    end
    if Cache.members.image[path] then
        return Cache.members.image[path]
    elseif Cache.members.preload.image[path] then
        return Cache.members.preload.image[path]
    else
        Cache.members.image[path] = love.graphics.newImage(path_)
        return Cache.members.image[path]
    end
end

function Paths.sound(path)
    if Cache.members.sound[path] then
        return Cache.members.sound[path]
    elseif Cache.members.preload.sound[path] then
        return Cache.members.preload.sound[path]
    else
        Cache.members.sound[path] = love.audio.newSource(path, "static")
        return Cache.members.sound[path]
    end
end

function Paths.font(path, size)
    if MODS_ALLOWED then
        local file = Paths.modsFont(path)
        if Cache.members.font[file] then
            return Cache.members.font[file]
        elseif Cache.members.preload.font[file] then
            return Cache.members.preload.font[file]
        elseif love.filesystem.getInfo(file) then
            Cache.members.font[file] = love.graphics.newFont(file, size)
            return Cache.members.font[file]
        end
    end
    if Cache.members.font[path .. size] then
        return Cache.members.font[path .. size]
    elseif Cache.members.preload.font[path .. size] then
        return Cache.members.preload.font[path .. size]
    else
        Cache.members.font[path .. size] = love.graphics.newFont(path, size)
        return Cache.members.font[path .. size]
    end
end

function Paths.fileExists(key, ignoreMods)
    if MODS_ALLOWED then
        if not ignoreMods then
            for i, mod in ipairs(Mods:getGlobalMods()) do
                if love.filesystem.getInfo(self.mods(mod .. "/" .. key)) then
                    return true
                end

                if love.filesystem.getInfo(self.mods(Mods.currentModDirectory .. "/" .. key)) or love.filesystem.getInfo(self.mods(key)) then
                    return true
                end
            end
        end
    end

    return love.filesystem.getInfo("assets/" .. key)
end

function Paths.shader(path)
    if Cache.members.shader[path] then
        return Cache.members.shader[path]
    elseif Cache.members.preload.shader[path] then
        return Cache.members.preload.shader[path]
    else
        Cache.members.shader[path] = love.graphics.newShader(path)
        return Cache.members.shader[path]
    end
end

function Paths.getPathFromGraphic(graphic)
    -- returns the full path of the graphic (without extension)
    -- look through Cache.members.image
    for path, image in pairs(Cache.members.image) do
        if image == graphic then
            return path
        end
    end
    
    -- look through Cache.members.preload.image
    for path, image in pairs(Cache.members.preload.image) do
        if image == graphic then
            return path
        end
    end
    
    return nil

end

function Paths.getAtlas(graphic, data) -- either packer or sparrow
    if not data then 
        if type(graphic) == "string" then
            data = graphic
        else
            data = Paths.getPathFromGraphic(graphic)
        end
    end
    -- is extensions included?
    if not data:find(".xml") and not data:find(".txt") then
        -- check if xml exists
        if love.filesystem.getInfo("assets/images/png/" .. data .. ".xml") or (MODS_ALLOWED and love.filesystem.getInfo(Paths.modsXml(data))) then
            if love.filesystem.getInfo(Paths.modsXml(data)) then
                data = Paths.modsXml(data)
            else
                data = "assets/images/png/" .. data .. ".xml"
            end
            return Paths.getSparrowAtlas(graphic, love.filesystem.read(data))
        elseif love.filesystem.getInfo("assets/images/png/" .. data .. ".txt") or (MODS_ALLOWED and love.filesystem.getInfo(Paths.modsTxt(data))) then
            if love.filesystem.getInfo(Paths.modsTxt(data)) then
                data = Paths.modsTxt(data)
            else
                data = "assets/images/png/" .. data .. ".txt"
            end
            return Paths.getPackerAtlas(graphic, data)
        else
            return nil
        end
    end
    if data:find(".xml") then
        return Paths.getSparrowAtlas(graphic, love.filesystem.read("assets/images/png/" .. data))
    else
        return Paths.getPackerAtlas(graphic, "assets/images/png/" .. data)
    end
end

function Paths.getSparrowAtlas(graphic, xmldata)
    if type(graphic) == "string" then
        graphic = Paths.image(graphic)
    end

    local frames = {graphic = graphic, frames = {}}
    local sw, sh = graphic:getDimensions()

    for i, child in ipairs(xml.parse(xmldata)) do
        if child.tag == "SubTexture" then
            table.insert(frames.frames, Sprite.NewFrame(
                child.attr.name,
                tonumber(child.attr.x), tonumber(child.attr.y),
                tonumber(child.attr.width), tonumber(child.attr.height),
                sw, sh,
                tonumber(child.attr.frameX), tonumber(child.attr.frameY),
                tonumber(child.attr.frameWidth), tonumber(child.attr.frameHeight)
            ))
        end
    end

    return frames
end

function Paths.getPackerAtlas(graphic, data)
    if type(graphic) == "string" then
        graphic = Paths.image(graphic)
    end

    local frames = {graphic = graphic, frames = {}}
    local sw, sh = graphic:getDimensions()

    local pack = data:trim() -- remove all extra whitespace
    for line in love.filesystem.lines(data) do
        local frameData = line:split("=")
        local name = frameData[1]:trim()
        local frameDimensions = frameData[2]:split(" ")

        table.insert(frames.frames, Sprite.NewFrame(
            name, tonumber(frameDimensions[1]), tonumber(frameDimensions[2]),
            tonumber(frameDimensions[3]), tonumber(frameDimensions[4]),
            sw, sh
        ))
    end

    return frames
end

function Paths.getTilesFromGraphic(graphic, tileSize, region, tileSpacing)
    local region = region
    local tileSpacing = tileSpacing or {x = 0, y = 0}
    local tiles = {}
    local tileSize = tileSize
    if not region then
        region = {x = 0, y = 0, width = graphic:getWidth(), height = graphic:getHeight()}
    else
        if region.width == 0 then region.width = graphic:getWidth() - region.x end
        if region.height == 0 then region.height = graphic:getHeight() - region.y end
    end

    region = {
        x = region.x,
        y = region.y,
        width = region.width,
        height = region.height
    }

    tileSpacing = {x = tileSpacing.x, y = tileSpacing.y}
    tileSize = {x = tileSize.x, y = tileSize.y}

    local spacedWidth = tileSize.x + tileSpacing.x
    local spacedHeight = tileSize.y + tileSpacing.y

    local rows = (tileSize.y ==0) and 1 or math.floor((region.height - tileSpacing.y) / spacedHeight)
    local columns = (tileSize.x == 0) and 1 or math.floor((region.width - tileSpacing.x) / spacedWidth)

    local sw, sh = graphic:getDimensions()
    local tf = 0

    local tiles = {graphic = graphic, frames = {}}

    for y = 0, rows - 1 do 
        for x = 0, columns -1 do
            table.insert(tiles.frames, Sprite.NewFrame(
                tostring(tf),
                region.x + x * spacedWidth, 
                region.y + y * spacedHeight,
                tileSize.x, tileSize.y,
                sw, sh
            ))
            tf = tf + 1
        end
    end

    return tiles
end

function Paths.preloadDirectoryImages(path)
    local path_ = "assets/images/" .. Paths.imageType .. "/" .. path
    local imgType = Paths.imageType
    -- does file or cache exist? if not, replace dds with png
    if not love.filesystem.getInfo(path_) or not Cache.members.preload.image[path] then
        path_ = "assets/images/png/" .. path
        imgType = "png"
    end
    
    local files = love.filesystem.getDirectoryItems(path_)
    -- if theres no files, check png's directory
    for i, file in ipairs(files) do
        -- does file end with dds?
        if file:endsWith("." .. imgType) then
            local file_ = file:sub(1, file:len() - 4)
            if not Cache.members.preload.image[path .. "/" .. file_] then
                Cache.members.preload.image[path .. "/" .. file_] = love.graphics.newImage(path_ .. "/" .. file)
            end
        end
    end
end

function Paths.clearPreload()
    -- go through and release all caches, then reset the table
    for path, image in pairs(Cache.members.preload.image) do
        image:release()
    end
    Cache.members.preload.image = {}
    
    for path, sound in pairs(Cache.members.preload.sound) do
        sound:release()
    end
    Cache.members.preload.sound = {}

    for path, font in pairs(Cache.members.preload.font) do
        font:release()
    end
    Cache.members.preload.font = {}

    for path, shader in pairs(Cache.members.preload.shader) do
        shader:release()
    end
    Cache.members.preload.shader = {}

    collectgarbage()
end

function Paths.clearFullCache()
    -- wipe everything
    for path, image in pairs(Cache.members.image) do
        image:release()
    end
    Cache.members.image = {}

    for path, sound in pairs(Cache.members.sound) do
        sound:release()
    end
    Cache.members.sound = {}

    for path, font in pairs(Cache.members.font) do
        font:release()
    end
    Cache.members.font = {}

    for path, shader in pairs(Cache.members.shader) do
        shader:release()
    end
    Cache.members.shader = {}

    collectgarbage()

    Paths.clearPreload()

    Cache.members = {
        image = {},
        sound = {},
        font = {},
        shader = {},
        preload = {
            image = {},
            sound = {},
            font = {},
            shader = {}
        }
    }
end


function Paths.formatToSongPath(path)
    local invalidChars = "[~&\\;:<>#]"
    local hideChars = "[.,'\"%?!]"
    local path = path:gsub(" ", "-"):gsub(invalidChars, "-"):gsub(hideChars, ""):lower()
    return path
end

function Paths.voices(path)
    if MODS_ALLOWED then
        if love.filesystem.getInfo(Paths.modsSongs(path .. "/Voices")) then
            return Paths.modsSongs(path .. "/Voices")
        else
            -- load normal
            return "assets/songs/" .. path .. "/Voices.ogg"
        end
    else
        return "assets/songs/" .. path .. "/Voices.ogg"
    end
end

function Paths.inst(path)
    if MODS_ALLOWED then
        if love.filesystem.getInfo(Paths.modsSongs(path .. "/Inst")) then
            return Paths.modsSongs(path .. "/Inst")
        else
            -- load normal
            return "assets/songs/" .. path .. "/Inst.ogg"
        end
    else
        return "assets/songs/" .. path .. "/Inst.ogg"
    end
end

if MODS_ALLOWED then
    function Paths.mods(key)
        return "mods/" .. (key or "")
    end

    function Paths.modsFont(key)
        return Paths.modFolders("fonts/" .. key)
    end

    function Paths.modsJson(key)
        return Paths.modFolders("data/" .. key .. ".json")
    end

    function Paths.modsVideo(key)
        return Paths.modFolders("videos/" .. key .. "." .. VIDEO_EXT)
    end

    function Paths.modsSounds(path, key)
        return Paths.modFolders(path .. "/" .. key .. "." .. SOUND_EXT)
    end

    function Paths.modsSongs(key)
        return Paths.modFolders("songs/" .. key .. ".ogg")
    end

    function Paths.modsImages(key)
        return Paths.modFolders("images/" .. key .. ".png")
    end

    function Paths.modsXml(key)
        return Paths.modFolders("images/" .. key .. ".xml")
    end

    function Paths.modsTxt(key)
        return Paths.modFolders("images/" .. key .. ".txt")
    end

    function Paths.modFolders(key)
        -- replace all // with /
        while key:find("//") do
            key = key:gsub("//", "/")
        end
        if Mods.currentModDirectory ~= nil and Mods.currentModDirectory:len() > 0 then
            local fileToCheck = Paths.mods(Mods.currentModDirectory .. "/" .. key)
            if love.filesystem.getInfo(fileToCheck) then
                -- replace ALL double / with single /
                while fileToCheck:find("//") do
                    fileToCheck = fileToCheck:gsub("//", "/")
                end
                return fileToCheck
            end
        end

        for i, mod in ipairs(Mods:getGlobalMods()) do
            local fileToCheck = Paths.mods(mod .. "/" .. key)
            if love.filesystem.getInfo(fileToCheck) then
                while fileToCheck:find("//") do
                    fileToCheck = fileToCheck:gsub("//", "/")
                end
                return fileToCheck
            end
        end

        local path = "mods/" .. Mods.currentModDirectory .. key
        -- replace ALL double / with single /
        while path:find("//") do
            path = path:gsub("//", "/")
        end
        return path
    end
end

return Paths