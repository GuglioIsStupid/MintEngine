local WeekData = Object:extend()
WeekData.weeksLoaded = {}
WeekData.weeksList = {}
WeekData.folder = ""

-- Json Variables
WeekData.songs = {}
WeekData.weekCharacters = {}
WeekData.weekBackground = ""
WeekData.weekBefore = ""
WeekData.storyName = ""
WeekData.weekName = ""
WeekData.freeplayColor = {255, 255, 255}
WeekData.startUnlocked = true
WeekData.hiddenUntilUnlocked = false
WeekData.hideStoryMode = false
WeekData.hideFreeplay = false
WeekData.difficulties = ""

WeekData.fileName = ""

function WeekData:createWeekFile()
    local weekFile = {
        songs = {{"Bopeebo", "dad", {143, 113, 253}}, {"Fresh", "dad", {143, 113, 253}}, {"Dad Battle", "dad", {146, 113, 253}}},
        weekCharacters = {"dad", "bf", "gf"},
        weekBackground = "stage",
        weekBefore = "tutorial",
        storyName = "Your New Week",
        weekName = "Custom Week",
        freeplayColor = {146, 113, 253},
        startUnlocked = true,
        hiddenUntilUnlocked = false,
        hideStoryMode = false,
        hideFreeplay = false,
        difficulties = ""
    }

    return weekFile
end

function WeekData:new(weekFile, fileName)
    -- weekFile is pre-parsed json

    self.songs = weekFile.songs
    self.weekCharacters = weekFile.weekCharacters
    self.weekBackground = weekFile.weekBackground
    self.weekBefore = weekFile.weekBefore
    self.storyName = weekFile.storyName
    self.weekName = weekFile.weekName
    self.freeplayColor = weekFile.freeplayColor
    self.startUnlocked = weekFile.startUnlocked
    self.hiddenUntilUnlocked = weekFile.hiddenUntilUnlocked
    self.hideStoryMode = weekFile.hideStoryMode
    self.hideFreeplay = weekFile.hideFreeplay
    self.difficulties = weekFile.difficulties

    self.fileName = fileName
end

function WeekData:reloadWeekFiles(isStoryMode)
    local isStoryMode = isStoryMode or false

    WeekData.weeksList = {}
    WeekData.weeksLoaded = {}
    local directories, originalLength
    if MODS_ALLOWED then
        directories = {Paths.mods(), "assets/"}
        originalLength = #directories

        for i, mod in ipairs(Mods:parseList().enabled) do
            table.insert(directories, Paths.mods(mod .. "/"))
        end 
    else
        directories = {"assets/"}
        originalLength = #directories
    end

    local sexList = {}
    for line in love.filesystem.lines("assets/weeks/weekList.txt") do
        if line ~= "" then
            table.insert(sexList, line)
        end
    end

    for i = 1, #sexList do
        for j = 1, #directories do
            local fileToCheck = directories[j] .. "weeks/" .. sexList[i] .. ".json"
            if not WeekData.weeksLoaded[sexList[i]] then
                local week = WeekData:getWeekFile(fileToCheck)
                if week then
                    local weekFile = WeekData(week, sexList[i])

                    if MODS_ALLOWED then
                        if j >= originalLength then
                            local pathsmods = Paths.mods()
                            weekFile.folder = directories[j]:sub(#pathsmods, #directories[j])
                        end
                    end

                    if weekFile and (not isStoryMode or (isStoryMode and not weekFile.hideStoryMode) or (not isStoryMode and not weekFile.hideFreeplay)) then
                        table.insert(WeekData.weeksList, sexList[i])
                        WeekData.weeksLoaded[sexList[i]] = weekFile
                    end
                end
            end
        end
    end

    if MODS_ALLOWED then
        for i = 1, #directories do
            local directory = directories[i] .. "weeks/"
            if love.filesystem.getInfo(directory) and not directory:find("assets/") then
                --local listOfWeeks = CoolUtil.coolTextFile(directory .. "weekList.txt")
                if not love.filesystem.getInfo(directory .. "weekList.txt") then
                    love.filesystem.write(directory .. "weekList.txt", "")
                end
                local listOfWeeks = love.filesystem.lines(directory .. "weekList.txt")
                for daWeek in listOfWeeks do
                    local path = directory .. daWeek .. ".json"
                    if love.filesystem.getInfo(path) then
                        self:addWeek(daWeek, path, directories[i], i, originalLength)
                    end
                end

                for i, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
                    local path = directory .. file
                    if love.filesystem.getInfo(path).type ~= "directory" and file:endsWith(".json") then
                        self:addWeek(file:sub(1, #file - 4), path, directory:gsub("weeks/", ""), i, originalLength)
                    end
                end
            end
        end
    end
end

function WeekData:addWeek(weekToCheck, path, directory, i, originalLength)
    if not self.weeksLoaded[weekToCheck] then
        local week = self:getWeekFile(path)
        if week then
            local weekFile = WeekData(week, weekToCheck)
            if i >= originalLength then
                if MODS_ALLOWED then
                    weekFile.folder = directory:sub(#Paths.mods(), #directory)
                end
            end

            if (PlayState.isStoryMode and not weekFile.hideStoryMode) or (not PlayState.isStoryMode and not weekFile.hideFreeplay) then
                table.insert(self.weeksList, weekToCheck)
                self.weeksLoaded[weekToCheck] = weekFile
            end
        end
    end
end

function WeekData:getWeekFile(path)
    local rawJson = nil

    if MODS_ALLOWED then
        local modPath = Paths.modFolders(path)
        if love.filesystem.getInfo(modPath) then
            rawJson = love.filesystem.read(modPath)
        elseif love.filesystem.getInfo(path) then
            rawJson = love.filesystem.read(path)
        else
            return nil
        end
    else
        if love.filesystem.getInfo(path) then
            rawJson = love.filesystem.read(path)
        else
            return nil
        end
    end

    if rawJson and rawJson ~= "" then
        return json.decode(rawJson)
    else
        return nil
    end
end

function WeekData:getWeekFileName()
    return self.weeksList[PlayState.storyWeek]
end

function WeekData:getCurrentWeek()
    return self.weeksLoaded[self.weeksList[PlayState.storyWeek]]
end

function WeekData:setDirectoryFromWeek(data)
    if data and data.folder and #data.folder > 0 then
        Mods.currentModDirectory = data.folder
    end
end

return WeekData