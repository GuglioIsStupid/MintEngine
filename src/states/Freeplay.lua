local SongMetaData = require "backend.SongMetaData"

local Freeplay = MusicBeatState:extend()

Freeplay.songs = {}
Freeplay.selector = nil
Freeplay.curSelected = 1
Freeplay.lerpSelected = 0
Freeplay.curDifficulty = -1
Freeplay.lastDifficultyName = Difficulty:getDefault()

Freeplay.scoreBG = nil
Freeplay.scoreText = nil
Freeplay.diffText = nil
Freeplay.lerpScore = 0
Freeplay.lerpRating = 0
Freeplay.intendedScore = 0
Freeplay.intendedRating = 0
Freeplay.grpSongs = nil
Freeplay.curPlaying = false

Freeplay.iconArray = {}

Freeplay.bg = nil
Freeplay.intendedColor = nil
Freeplay.colorTween = nil

Freeplay.missingTextBG = nil
Freeplay.missingText = nil
Freeplay.instPlaying = -1
Freeplay.vocals = nil
Freeplay.holdTime = 0
Freeplay._drawDistance = 4
Freeplay._lastVisibles = {}

-- Simplicity
Freeplay.members = {}
function Freeplay:add(member)
    table.insert(self.members, member)
end

function Freeplay:remove(member)
    for i, member in ipairs(self.members) do
        if member == member then
            table.remove(self.members, i)
            return
        end
    end
end

function Freeplay:insert(position, member)
    table.insert(self.members, position, member)
end

function Freeplay:clear()
    self.members = {}
end
--

function Freeplay:resetValues()
    self.members = {}
    self.songs = {}
    self.iconArray = {}
    self._lastVisibles = {}
    self.curSelected = 1
    self.lerpSelected = 0
    self.curDifficulty = -1
    self.lastDifficultyName = Difficulty:getDefault()
    self.intendedScore = 0
    self.intendedRating = 0
    self.lerpScore = 0
    self.lerpRating = 0
    self.curPlaying = false
    self.intendedColor = nil
    self.colorTween = nil
    self.missingTextBG = nil
    self.missingText = nil
    self.instPlaying = -1
    self.vocals = nil
    self.holdTime = 0
    self._drawDistance = 4
    self._lastVisibles = {}
    self.grpSongs = Group()
    self.grpTexts = Group()
end

function Freeplay:enter()
    PlayState.isStoryMode = false
    self:resetValues()
    WeekData:reloadWeekFiles(false)

    for i = 1, #WeekData.weeksList do
        if self:weekIsLocked(WeekData.weeksList[i]) then do break end end

        local leWeek = WeekData.weeksLoaded[WeekData.weeksList[i]]
        local leSongs = {}
        local leChars = {}

        for j = 1, #leWeek.songs do
            table.insert(leSongs, leWeek.songs[j][1])
            table.insert(leChars, leWeek.songs[j][2])
        end

        for _, song in ipairs(leWeek.songs) do
            local colors = song[3]
            if not colors or #colors < 3 then
                colors = {146, 113, 253}
            end
            self:addSong(song[1], i, song[2], colors)
        end
    end

    self.bg = Sprite()
    self.bg:load("menu/menuDesat")
    self:add(self.bg)
    self.bg:screenCenter()
    self.bg.color2 = 0

    self.grpSongs = Group()
    self:add(self.grpSongs)

    for i = 1, #self.songs do
        local songText = Alphabet(90, 320, self.songs[i].songName, true)
        songText.targetY = i
        self.grpTexts:add(songText)

        songText.scaleX = math.min(1, 980 / songText.width)
        songText:snapToPosition()

        local icon = HealthIcon(self.songs[i].songCharacter)
        icon.sprTracker = songText

        songText.visible = false
        songText.visible = false
        songText.active = false
        icon.visible, icon.active = false, false

        table.insert(self.iconArray, icon)
        self:add(icon)
        self.grpSongs:add(songText)
    end
    
    self.scoreText = Text(push:getWidth()*0.7, 5, 0, "", Paths.font("assets/fonts/vcr.ttf", 32))
    self.scoreText.borderSize = 0
    self.scoreText.alignment = "right"

    self.scoreBG = Sprite(self.scoreText.x - 6, 0)
    self.scoreBG:makeGraphic(1, 66, 0xFF000000)
    self.scoreBG.color = hexToColor(0xFF000000)
    self.scoreBG.alpha = 0.6
    self:add(self.scoreBG)

    self.diffText = Text(self.scoreText.x, self.scoreText.y + 36, 0, "", Paths.font("assets/fonts/vcr.ttf", 24))
    self.diffText.borderSize = 0
    self:add(self.diffText)
    self:add(self.scoreText)

    self.missingTextBG = Sprite()
    self.missingTextBG:makeGraphic(push:getWidth(), push:getHeight(), 0x00000000)
    self.missingTextBG.alpha = 0.6
    self.missingTextBG.visible = false
    self:add(self.missingTextBG)

    self.missingText = Text(50, 0, push:getWidth()-100, "", Paths.font("assets/fonts/vcr.ttf", 24))
    self.missingText.visible = false

    if self.curSelected > #self.songs then
        self.curSelected = 1
    end
    self.bg.color = self.songs[self.curSelected].colors
    self.intendedColor = self.bg.color
    self.lerpSelected = self.curSelected

    self.curDifficulty = math.round(math.max(0, table.indexOf(Difficulty.defaultList, self.lastDifficultyName)))

    self:changeSelection()

    local swag = Alphabet(1, 0, "swag")

    local textBG = Sprite(0, push:getHeight()-26)
    textBG:makeGraphic(push:getWidth(), 26, 0xFF000000)
    textBG.color = hexToColor(0xFF000000)
    textBG.alpha = 0.6
    self:add(textBG)

    self:updateTexts(love.timer.getDelta())
end

function Freeplay:addSong(songName, weekNum, songCharacter, color)
    table.insert(self.songs, SongMetaData(songName, weekNum, songCharacter, color))
end

function Freeplay:weekIsLocked(name)    
    local leWeek = WeekData.weeksLoaded[name]
    --return (not leWeek.startUnlocked and #leWeek.weekbefore > 0 and (not self.weekComplated[leWeek.weekBefore] or not self.weekCompleted[leWeek.weekBefore])) 
    --return (not leWeek.startUnlocked and #leWeek.weekBefore > 0 and (not StoryMenuState.weekCompleted[leWeek.weekBefore]) or not StoryMenuState.weekCompleted[leWeek.weekBefore])
    return (not leWeek.startUnlocked and #leWeek.weekBefore > 0 and (not StoryMenuState.weekCompleted[leWeek.weekBefore]))
end

function Freeplay:update(dt)
    for i, member in ipairs(self.members) do
        if member.update then 
            member:update(dt) 
        end
    end

    self.lerpScore = math.floor(math.lerp(self.lerpScore, self.intendedScore, math.bound(dt * 24, 0, 1)))
    self.lerpRating = math.lerp(self.lerpRating, self.intendedRating or 0, math.bound(dt * 12, 0, 1))

    if math.abs(self.lerpScore - self.intendedScore) < 1 then
        self.lerpScore = self.intendedScore
    end
    if math.abs(self.lerpRating - self.intendedRating or 0) < 0.01 then
        self.lerpRating = self.intendedRating
    end

    local ratingSplit = tostring(CoolUtil.floorDecimal(self.lerpRating * 100, 2)):split(".")
    if #ratingSplit < 2 then
        table.insert(ratingSplit, "")
    end

    while #ratingSplit[2] < 2 do
        ratingSplit[2] = ratingSplit[1] .. "0"
    end

    self.scoreText.text = "PERSONAL BEST: " .. self.lerpScore .. " (" .. table.concat(ratingSplit, ".") .. "%)"
    self:positionHighscore()

    local shiftMult = 1
    if love.keyboard.isDown("lshift") then shiftMult = 3 end

    if #self.songs > 1 then
        if input:pressed("ui_up") then
            self:changeSelection(-shiftMult)
            self.holdTime = 0
        end
        if input:pressed("ui_down") then
            self:changeSelection(shiftMult)
            self.holdTime = 0
        end

        if input:down("ui_up") or input:down("ui_down") then
            local checkLastHold = math.floor((self.holdTime - 0.5) * 10)
            self.holdTime = self.holdTime + dt
            local checkNewHold = math.floor((self.holdTime - 0.5) * 10)

            if self.holdTime > 0.5 and checkNewHold - checkLastHold > 0 then
                self:changeSelection((checkNewHold - checkLastHold) * (input:down("ui_up") and -shiftMult or shiftMult))
            end
        end
    end

    if input:pressed("ui_left") then
        self:changeDiff(-1)
        self:_updateSongLastDifficulty()
    elseif input:pressed("ui_right") then
        self:changeDiff(1)
        self:_updateSongLastDifficulty()
    end

    if input:pressed("back") then
        if self.colorTween then
            Timer.cancel(self.colorTween)
        end
        Sound.play(Paths.sound("assets/sounds/cancelMenu.ogg"))
        MusicBeatState:fadeOut(0.4, function() GameState.switch(MainMenuState) end)
    end

    if input:pressed("accept") then
        local songLowercase = Paths.formatToSongPath(self.songs[self.curSelected].songName)
        TryExcept(
            function()
                PlayState.SONG = Song:loadFromJson(songLowercase .. Difficulty:getFilePath(self.curDifficulty), songLowercase)
                PlayState.isStoryMode = false
                PlayState.storyDifficulty = self.curDifficulty

                if self.colorTween then
                    Timer.cancel(self.colorTween)
                end
            end,
            function(e)
                print("ERROR! " .. e)
                local errorStr = tostring(e)
                self.missingText.text = "ERROR WHILE LOADING CHART:\n" .. errorStr
                self.missingText:screenCenter("Y")
                self.missingText.visible = true
                self.missingTextBG.visible = true
                Sound.play(Paths.sound("assets/sounds/cancelMenu.ogg"))

                self:updateTexts(dt)
                return
            end
        )

        MusicBeatState:fadeOut(0.3, function()
            MusicBeatState:switchState(PlayState)
        end)
    end

    self:updateTexts(dt)
end

function Freeplay:changeDiff(change)
    local change = change or 0

    self.curDifficulty = self.curDifficulty + change
    
    if self.curDifficulty < 1 then
        self.curDifficulty = #Difficulty.defaultList
    elseif self.curDifficulty > #Difficulty.defaultList then
        self.curDifficulty = 1
    end

    self.lastDifficultyName = Difficulty:getString(self.curDifficulty)
    if #Difficulty.list > 1 then
        self.diffText.text = "< " .. self.lastDifficultyName:upper() .. " >"
    else
        self.diffText.text = self.lastDifficultyName:upper()
    end

    self.missingText.visible = false
    self.missingTextBG.visible = false
end

function Freeplay:changeSelection(change, playSound)
    local change = change or 0
    local playSound = (playSound == nil) and true or playSound
    self:_updateSongLastDifficulty()
    if playSound then Sound.play(Paths.sound("assets/sounds/scrollMenu.ogg")) end

    local lastList = Difficulty.list
    self.curSelected = self.curSelected + change

    if self.curSelected < 1 then
        self.curSelected = #self.songs
    elseif self.curSelected > #self.songs then
        self.curSelected = 1
    end

    local newColor = self.songs[self.curSelected].color
    if newColor ~= self.intendedColor then
        if self.colorTween then
            Timer.cancel(self.colorTween)
        end
        self.intendedColor = newColor
        self.colorTween = Timer.tween(1, self.bg, {color = {newColor[1]/255, newColor[2]/255, newColor[3]/255}}, "linear", function() self.colorTween = nil end)
    end

    local bullshit = 0

    for i = 1, #self.iconArray do
        self.iconArray[i].alpha = 0.6
    end
    self.iconArray[self.curSelected].alpha = 1

    for _, item in ipairs(self.grpSongs.members) do
        bullshit = bullshit + 1
        item.alpha = 0.6
        if item.targetY == self.curSelected then
            item.alpha = 1
        end
    end

    PlayState.storyWeek = self.songs[self.curSelected].week
    Difficulty:loadFromWeek()

    local saveDiff = table.indexOf(Difficulty.list, self.lastDifficultyName)
    --[[ if savedDiff and not self.lastList[savedDiff] and Difficulty.list[savedDiff] then
        self.curDifficulty = math.round(math.max(0, table.indexOf(Difficulty.defaultList, self.lastDifficultyName)))
    elseif (self.lastDiff or 1) > -1 then
        self.curDifficulty = self.lastDiff or 1
    elseif Difficulty.list[Difficulty:getDefault()] then
        self.curDifficulty = math.round(math.max(0, table.indexOf(Difficulty.defaultList, Difficulty:getDefault())))
    else
        self.curDifficulty = 1
    end ]]

    self:changeDiff()
    self:_updateSongLastDifficulty()
end

function Freeplay:_updateSongLastDifficulty()
    self.songs[self.curSelected].lastDifficulty = Difficulty:getString(self.curDifficulty)
end

function Freeplay:positionHighscore()
    self.scoreText.x = push:getWidth() - self.scoreText.width - 6
    self.scoreBG.scale.x = push:getWidth() - self.scoreText.x + 6
    self.scoreBG.x = push:getWidth() - (self.scoreBG.scale.x / 2)
    self.diffText.x = math.floor(self.scoreBG.x + (self.scoreBG.width /2))
    self.diffText.x = self.diffText.x - (self.diffText.width / 2)
end

function Freeplay:updateTexts(dt)
    self.lerpSelected = math.lerp(self.lerpSelected, self.curSelected, math.bound(dt * 9.6, 0, 1))

    for i = 1, #self._lastVisibles do
        self.grpSongs.members[i].visible, self.grpSongs.members[i].active = false, false
        self.iconArray[i].visible, self.iconArray[i].active = false, false
    end
    self._lastVisibles = {}

    local min = math.round(math.max(1, math.min(#self.songs, self.lerpSelected - self._drawDistance)))
    local max = math.round(math.min(1, math.max(#self.songs, self.lerpSelected + self._drawDistance)))

    for i = 1, #self.songs do
        local item = self.grpSongs.members[i]
        item.visible, item.active = true, true
        item.x = ((item.targetY - self.lerpSelected) * item.distancePerItem.x) + item.startPosition.x
        item.y = ((item.targetY - self.lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y

        local icon = self.iconArray[i]
        icon.visible, icon.active = true, true
        table.insert(self._lastVisibles, i)
    end
end

function Freeplay:draw()
    for i, member in ipairs(self.members) do
        if member.draw then 
            member:draw() 
        end
    end
end

return Freeplay