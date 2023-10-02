local PlayState = MusicBeatState:extend()

PlayState.STRUM_X = 42
PlayState.STRUM_X_MIDDLESCROLL = -278

PlayState.ratingStuff = {
    {"You Suck!", 0.2},
    {"Shit", 0.4},
    {"Bad", 0.5},
    {"Bruh", 0.6},
    {"Meh", 0.69},
    {"Nice", 0.7},
    {"Good", 0.8},
    {"Great", 0.9},
    {"Sick!", 1},
    {"Perfect!!", 1} -- ermmm,,, 2nd var not used (why does psych do this? ig i gotta view the code lmao)
}

PlayState.ratingName = "?"

PlayState.isCameraOnForcedPos = false 

-- wtf are maps 💀
PlayState.boyfriendMap = {}
PlayState.dadMap = {}
PlayState.gfMap = {}
PlayState.variables = {}

PlayState.BF_X = 770
PlayState.BF_Y = 100
PlayState.DAD_X = 100
PlayState.DAD_Y = 100
PlayState.GF_X = 400
PlayState.GF_Y = 130

PlayState.songSpeed = 1
PlayState.songSpeedTween = nil -- Timer.tween
PlayState.songSpeedType = "multiplicative"
PlayState.noteKillOffset = 350
PlayState.playbackRate = 1

PlayState.curStage = ""
PlayState.stageUI = "normal"
PlayState.isPixelStage = false

PlayState.SONG = nil
PlayState.isStoryMode = false
PlayState.storyWeek = 0
PlayState.storyPlaylist = {}
PlayState.storyDifficulty = 1

PlayState.spawnTime = 1000

PlayState.vocals = nil
PlayState.inst = nil

PlayState.dad = nil
PlayState.gf = nil
PlayState.boyfriend = nil

PlayState.notes = Group()
PlayState.unspawnNotes = {}
PlayState.eventNotes = {}

PlayState.camFollow = {x=0,y=0}
PlayState.prevCamFollow = {x=0,y=0}

PlayState.strumLineNotes = Group()
PlayState.opponentStrums = Group()
PlayState.playerStrums = Group()
PlayState.grpNoteSplashes = Group()

PlayState.camZooming = false
PlayState.camZoomingMult = 1
PlayState.camZoomingDecay = 1
PlayState.curSong = ""

PlayState.gfSpeed = 1
PlayState.health = 1
PlayState.combo = 0

PlayState.healthBar = nil
PlayState.timeBar = nil
PlayState.songPercent = 0

PlayState.ratingsData = nil
PlayState.fullComboFunction = nil

PlayState.generatedMusic = false
PlayState.endingSong = false
PlayState.startingFalse = false
PlayState.updateTime = true
PlayState.changedDifficulty = false
PlayState.chartingMode = false

PlayState.healthGain = 1
PlayState.healthloss = 1
PlayState.instaKillOnMiss = false
PlayState.cpuControlled = false
PlayState.practiceMode = false

PlayState.botplaySine = 0
PlayState.botplayTxt = ""

PlayState.iconP1 = nil
PlayState.iconP2 = nil
PlayState.camHUD = Camera()
PlayState.camGame = Camera()
PlayState.camOther = Camera()
PlayState.camSpeed = 1

PlayState.songScore = 0
PlayState.songHites = 0
PlayState.songMisses = 0
PlayState.scoreTxt = ""
PlayState.timeTxt = ""
PlayState.scoreTxtTween = nil

PlayState.campaignScore = 0
PlayState.campaignMisses = 0
PlayState.seenCutscene = false
PlayState.deathCounter = 0

PlayState.defaultCamZoom = 1.05

PlayState.daPixelZoom =  6
PlayState.singAnimations = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}

PlayState.inCutscene = false
PlayState.skipCountdown = false
PlayState.songLength = 0

PlayState.boyfriendCameraOffset = {x=0,y=0}
PlayState.dadCameraOffset = {x=0,y=0}
PlayState.girlfriendCameraOffset = {x=0,y=0}

PlayState.precacheList = {}
PlayState.songName = ""

PlayState.startCallback = nil
PlayState.endCallback = nil

PlayState.keysArray = nil

PlayState.updateTime = false
PlayState.transitioning = false

PlayState.noteTypes = {}
PlayState.eventsPushed = {}

PlayState.members = {}

function PlayState:resetValues()
    -- call everything defined to the default
    self.isCameraOnForcedPos = false 

    -- wtf are maps 💀
    self.boyfriendMap = {}
    self.dadMap = {}
    self.gfMap = {}
    self.variables = {}

    self.songSpeed = 1
    self.songSpeedTween = nil -- Timer.tween
    self.songSpeedType = "multiplicative"
    self.noteKillOffset = 350
    self.playbackRate = 1

    self.spawnTime = 2000

    self.vocals = nil
    self.inst = nil

    self.dad = nil
    self.gf = nil
    self.boyfriend = nil

    self.notes = Group()
    self.unspawnNotes = {}
    self.eventNotes = {}

    self.camFollow = {x=0,y=0}
    self.prevCamFollow = {x=0,y=0}

    self.strumLineNotes = Group()
    self.opponentStrums = Group()
    self.playerStrums = Group()
    self.grpNoteSplashes = Group()

    self.camZooming = false
    self.camZoomingMult = 1
    self.camZoomingDecay = 1
    self.curSong = ""

    self.gfSpeed = 1
    self.health = 1
    self.combo = 0

    self.healthBar = nil
    self.timeBar = nil
    self.songPercent = 0

    self.ratingsData = Rating:loadDefault()
    self.fullComboFunction = nil

    self.generatedMusic = false
    self.endingSong = false
    self.startingFalse = false
    self.updateTime = true
    self.changedDifficulty = false
    self.chartingMode = false

    self.healthGain = 1
    self.healthloss = 1
    self.instaKillOnMiss = false
    self.cpuControlled = false
    self.practiceMode = false

    self.botplaySine = 0
    self.botplayTxt = ""

    self.iconP1 = nil
    self.iconP2 = nil
    self.camHUD = Camera()
    self.camGame = Camera()
    self.camOther = Camera()
    self.camSpeed = 1

    self.songScore = 0
    self.songHites = 0
    self.songMisses = 0
    self.scoreTxt = ""
    self.timeTxt = ""
    self.scoreTxtTween = nil

    self.campaignScore = 0
    self.campaignMisses = 0
    self.seenCutscene = false
    self.deathCounter = 0

    self.defaultCamZoom = 1.05

    self.daPixelZoom =  6
    self.singAnimations = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}

    self.inCutscene = false
    self.skipCountdown = false
    self.songLength = 0

    self.precacheList = {}

    self.ratingName = "?"
    self.totalPlayed = 0

    self.startCallback = nil
    self.endCallback = nil

    self.keysArray = nil

    self.updateTime = false
    self.transitioning = false

    self.noteTypes = {}
    self.eventsPushed = {}

    self.members = {}
    self.startingSong = true

    self.antialiasing = false
end

function PlayState:add(member)
    table.insert(self.members, member)
end

function PlayState:remove(member)
    for i, member in ipairs(self.members) do
        if member == object then
            table.remove(self.members, i)
            return
        end
    end
end

function PlayState:insert(position, member)
    table.insert(self.members, position, member)
end

function PlayState:clear()
    self.members = {}
end

function PlayState:enter()
    Paths.clearFullCache() -- reccomended for nintendo switch, will be setting in the future
    self:resetValues()
    self.super.enter(self)

    self.startCallback = self.startCountdown
    self.endCallback = self.endSong

    self.fullComboFunction = self.fullComboUpdate

    self.keysArray = {
        "note_left",
        "note_down",
        "note_up",
        "note_right"
    }
    self.inputsArray = {false, false, false, false}

    self.camGame = Camera()
    self.camGame.target = {x = 0, y = 0}
    self.camHUD = Camera()
    self.camOther = Camera()

    if not self.SONG then
        self.SONG = Song:loadFromJson("test", "test")
    end
    Conductor.mapBPMChanges(self.SONG)
    Conductor.changeBPM(self.SONG.bpm)
    self.songName = Paths.formatToSongPath(self.SONG.song)
    
    if not self.SONG.stage or (self.SONG.stage and #self.SONG.stage < 1) then
        self.SONG.stage = StageData:vanillaSongStage(self.songName)
    end
    self.curStage = self.SONG.stage or "stage"

    local stageData = StageData:getStageFile(self.curStage)
    if not stageData then
        stageData = StageData:dummy()
    end

    self.defaultCamZoom = stageData.defaultZoom

    self.stageUI = "normal"
    if stageData.stageUI and #stageData.stageUI > 0 then
        self.stageUI = stageData.stageUI
        self.isPixelStage = self.stageUI == "pixel"
    else
        if stageData.isPixelStage then
            self.stageUI = "pixel"
            self.isPixelStage = true
        else
            self.stageUI = "normal"
            self.isPixelStage = false
        end
    end

   --[[  self.BF_X = 770
    self.BF_Y = 100
    self.DAD_X = 100
    self.DAD_Y = 100
    self.GF_X = 400
    self.GF_Y = 130 ]]
    self.BF_X = stageData.boyfriend[1]
    self.BF_Y = stageData.boyfriend[2]
    self.DAD_X = stageData.opponent[1]
    self.DAD_Y = stageData.opponent[2]
    self.GF_X = stageData.girlfriend[1]
    self.GF_Y = stageData.girlfriend[2]

    if stageData.camera_speed ~= nil then
        self.cameraSpeed = stageData.camera_speed
    else
        self.cameraSpeed = 1
    end

    self.boyfriendCameraOffset = stageData.camera_boyfriend
    if not self.boyfriendCameraOffset then
        self.boyfriendCameraOffset = {0, 0}
    end

    self.opponentCameraOffset = stageData.camera_opponent
    if not self.opponentCameraOffset then
        self.opponentCameraOffset = {0, 0}
    end

    self.girlfriendCameraOffset = stageData.camera_girlfriend
    if not self.girlfriendCameraOffset then
        self.girlfriendCameraOffset = {0, 0}
    end

    if self.curStage == "spooky" then
        stage = Stages.Spooky()
    elseif self.curStage == "philly" then
        stage = Stages.Philly()
    elseif self.curStage == "limo" then
        stage = Stages.Limo()
    elseif self.curStage == "mall" then
        stage = Stages.Mall()
    elseif self.curStage == "mallEvil" then
        stage = Stages.MallEvil()
    elseif self.curStage == "school" then
        stage = Stages.School()
    elseif self.curStage == "schoolEvil" then
        stage = Stages.SchoolEvil()
    elseif self.curStage == "tank" then
        stage = Stages.Tank()
    else -- Always default to stage
        stage = Stages.Stage()
    end

    if not stageData.hide_girlfriend then
        if not self.SONG.gfVersion or #self.SONG.gfVersion < 1 then 
            if self.curStage ~= "limo" then
                self.SONG.gfVersion = "gf" 
            else
                self.SONG.gfVersion = "gf-car"
            end
        end
        self.gf = Character(self.GF_X, self.GF_Y, self.SONG.gfVersion, false)
        self:add(self.gf)

        self.gf.camera = self.camGame
    end

    self.dad = Character(self.DAD_X, self.DAD_Y, self.SONG.player2, false)
    self:add(self.dad)

    self.dad.camera = self.camGame

    self.boyfriend = Character(self.BF_X, self.BF_Y, self.SONG.player1, true)
    self:add(self.boyfriend)

    self.boyfriend.camera = self.camGame

    local camPos = {x = self.girlfriendCameraOffset[1], y = self.girlfriendCameraOffset[2]}
    if self.gf then
        camPos.x = camPos.x + self.gf:getMidpoint().x + self.gf.cameraPosition[1]
        camPos.y = camPos.y + self.gf:getMidpoint().y + self.gf.cameraPosition[2]
    end
    if self.dad.curCharacter:startsWith("gf") then
        self.dad.x, self.dad.y = self.GF_X, self.GF_Y
        if self.gf then
            self.gf.visible = false
        end
    end

    self.camFollow.x, self.camFollow.y = camPos.x, camPos.y

    stage:createPost()
    Conductor.songPosition = -5000 / Conductor.songPosition

    self:add(self.combos)

    self.healthBar = HealthBar(0, push:getHeight() * 0.89, "healthBar", 0, 2, false, function() 
        return self.health < 0 and 0 or self.health > 2 and 2 or self.health
    end)
    self.healthBar.camera = self.camHUD
    self.healthBar:screenCenter("X")
    self:add(self.healthBar)

    self.iconP1 = HealthIcon(self.boyfriend.healthIcon, true)
    self.iconP1.y = self.healthBar.y - 75
    self.iconP1.camera = self.camHUD
    self:add(self.iconP1)

    self.iconP2 = HealthIcon(self.dad.healthIcon, false)
    self.iconP2.y = self.healthBar.y - 75
    self.iconP2.camera = self.camHUD
    self:add(self.iconP2)

    self.songScore = 0
    self.songHites = 0
    self.songMisses = 0
    self.scoreTxt = Text(0, self.healthBar.y + 40, push:getWidth(), "", Paths.font("assets/fonts/vcr.ttf", 20))
    self.scoreTxt.camera = self.camHUD
    self.scoreTxt.scrollFactor = {x = 0, y = 0}
    self.scoreTxt.borderSize = 1.25
    self:add(self.scoreTxt)

    self.strumLineNotes = Group()
    self:add(self.strumLineNotes)

    self.opponentStrums = Group()
    self.playerStrums = Group()

    self.notes = Group()
    self.sustainNotes = Group()
    self:add(self.sustainNotes)
    self:add(self.notes)

    Conductor.songPosition = 0

    self:generateSong(self.SONG.song)

    self.generatedMusic = false

    Conductor.safeZoneOffset = (10 / 60) * 1000

    self:moveCameraSection()

    self.camGame.zoom = self.defaultCamZoom
    self.camHUD.zoom = 1

    -- intro preloads
    if self.stageUI == "pixel" then
        Paths.image("pixel/pixelUI/ready-pixel")
        Paths.image("pixel/pixelUI/set-pixel")
        Paths.image("pixel/pixelUI/date-pixel")
    else
        Paths.image("ui/ready")
        Paths.image("ui/set")
        Paths.image("ui/go")
    end
    self:cachePopUpScore()

    TitleState.music:stop()
    if self.startCallback ~= self.startCountdown then
        self.startCallback(stage)
    end
    MusicBeatState:fadeIn(0.8, function()
        PlayState.generatedMusic = true
        PlayState.updateTime = true
        if self.startCallback == self.startCountdown then
            self:startCallback()
        end
    end)

    self:reloadHealthbarColours()
    self:recalculateRating()
end

function PlayState:reloadHealthbarColours()
    self.healthBar.barRightColor = self.dad.healthColorArray
    self.healthBar.barLeftColor = self.boyfriend.healthColorArray
end

function PlayState:moveCameraSection(sec)
    if not sec then sec = self.curSection end
    if sec < 1 then sec = 1 end

    if not self.SONG.notes[sec] then return end
    local isDad = not self.SONG.notes[sec].mustHitSection

    if self.gf and self.SONG.notes[sec].gfSection or (isDad and self.dad.curCharacter:startsWith("gf")) then
        self.camTwn = Timer.tween(self.cameraSpeed, self.camFollow, 
            {
                x = self.gf:getMidpoint().x + self.gf.cameraPosition[1] + self.girlfriendCameraOffset[1], 
                y = self.gf:getMidpoint().y + self.gf.cameraPosition[2] + self.girlfriendCameraOffset[2] - 50
            }, "out-quad"
        )
        self:tweenCamIn()
        return;
    end

    self:moveCamera(isDad)
end

function PlayState:updateScore(miss)
    local str = self.ratingName or "miss"
    if self.totalPlayed ~= 0 then
        local percent = CoolUtil.floorDecimal(self.ratingPercent * 100, 2)
        --str += ' ($percent%) - $ratingFC';
        str = str .. " (" .. percent .. "%) - " .. self.ratingFC
    end

    self.scoreTxt.text = "Score: " .. self.songScore ..
        " | Misses: " .. self.songMisses ..
        " | Rating: " .. str

    if not miss and not self.cpuControlled then
        if self.scoreTxtTween then
            Timer.cancel(self.scoreTxtTween)
        end
        self.scoreTxt.scale = {x = 1.075, y = 1.075}
        self.scoreTxtTween = Timer.tween(0.2, self.scoreTxt.scale, {x = 1, y = 1}, "linear", function() self.scoreTxtTween = nil end)
    end
end

function PlayState:recalculateRating(badHit)
    self.ratingName = "?"

    if self.totalPlayed ~= 0 then
        -- determine ratingPercent from 350 times 
        -- max 1, lowest 0
        --self.ratingPercent = self.songScore / (350 * self.totalPlayed)
        self.ratingPercent = math.bound(self.songScore / (350 * self.totalPlayed), 0, 1)
        -- 

        self.ratingName = self.ratingStuff[#self.ratingStuff][1]
        if self.ratingPercent < 1 then
            for i = 1, #self.ratingStuff do
                if self.ratingPercent < self.ratingStuff[i][2] then
                    self.ratingName = self.ratingStuff[i][1]
                    break
                end
            end
        end
    end
    if self.fullComboFunction then self:fullComboFunction() end

    self:updateScore(badHit)
end

function PlayState:fullComboUpdate()
    local sicks = self.ratingsData[1].hits
    local goods = self.ratingsData[2].hits
    local bads = self.ratingsData[3].hits
    local shits = self.ratingsData[4].hits

    self.ratingFC = "Clear"
    if self.songMisses < 1 then
        if bads > 0 or shits > 0 then self.ratingFC = "FC"
        elseif goods > 0 then self.ratingFC = "GFC"
        elseif sicks > 0 then self.ratingFC = "SFC"
        end
    elseif self.songMisses < 10 then
        self.ratingFC = "SDCB"
    end
end

function PlayState:moveCamera(isDad)
    if self.camTween then Timer.cancel(self.camTween) end
    if isDad then
        --print( self.dad:getMidpoint().x + 150 + self.dad.cameraPosition[1] + self.opponentCameraOffset[1], self.dad:getMidpoint().y - 100 + self.dad.cameraPosition[2] + self.opponentCameraOffset[2])
        self.camTween = Timer.tween(self.cameraSpeed, self.camFollow, 
            {
                x = self.dad:getMidpoint().x + 150 + self.dad.cameraPosition[1] + self.opponentCameraOffset[1], 
                y = self.dad:getMidpoint().y - 100 + self.dad.cameraPosition[2] + self.opponentCameraOffset[2]
            }, "out-quad"
        ) 
    else
        --print( self.boyfriend:getMidpoint().x - 100 - self.boyfriend.cameraPosition[1] - self.boyfriendCameraOffset[1], self.boyfriend:getMidpoint().y - 100 + self.boyfriend.cameraPosition[2] + self.boyfriendCameraOffset[2])
        self.camTween = Timer.tween(self.cameraSpeed, self.camFollow, 
            {
                x = self.boyfriend:getMidpoint().x - 100 - self.boyfriend.cameraPosition[1] - self.boyfriendCameraOffset[1], 
                y = self.boyfriend:getMidpoint().y - 100 + self.boyfriend.cameraPosition[2] + self.boyfriendCameraOffset[2]
            }, "out-quad"
        ) 

        if Paths.formatToSongPath(self.SONG.song) == "tutorial" and not self.cameraTwn and self.camGame.zoom ~= 1 then
            self.cameraTwn = Timer.tween(Conductor.stepCrochet*4/1000, self.camGame, {zoom = 1}, "in-bounce", function() self.cameraTwn = nil end)
        end
    end
end

function PlayState:sectionHit()
    if self.SONG.notes[self.curSection] then
        if self.generatedMusic and not self.endingSong and not self.isCameraOnForcedPos then
            self:moveCameraSection()
        end

        if self.camZooming and self.camGame.zoom < 1.35 then
            self.camGame.zoom = self.camGame.zoom + 0.015
            self.camHUD.zoom = self.camHUD.zoom + 0.03
        end
    end
end

function PlayState:update(dt)
    if self.health <= 0 then
        self.health = 0
    elseif self.health > 2 then
        self.health = 2
    end
    stage:update(dt)
    self.super.update(self, dt)
    if self.generatedMusic and self.updateTime and not self.inCutscene then
        Conductor.songPosition = Conductor.songPosition + 1000 * dt
    end
    for i, member in ipairs(self.members) do
        if member.update then 
            member:update(dt) 
        end
    end

    local mult = math.lerp(1, self.iconP1.scale.x, math.bound(1 - (dt * 9 * self.playbackRate), 0, 1))
    self.iconP1.scale = {x = mult, y = mult}
    self.iconP1:updateHitbox()

    mult = math.lerp(1, self.iconP2.scale.x, math.bound(1 - (dt * 9 * self.playbackRate), 0, 1))
    self.iconP2.scale = {x = mult, y = mult}
    self.iconP2:updateHitbox()

    local iconOffset = 26
    self.iconP1.x = self.healthBar.barCenter + (150 * self.iconP1.scale.x - 150) / 2 - iconOffset
    self.iconP2.x = self.healthBar.barCenter - (150 * self.iconP2.scale.x) / 2 - (iconOffset*2)

    -- convert from 0-2 to 0-100
    local newPercent = self.health * 50
    self.iconP1.curFrame = (newPercent < 20) and 2 or 1
    self.iconP2.curFrame = (newPercent > 80) and 2 or 1


    if self.inst and (not self.inst:isPlaying() and self.startedCountdown and not self.transitioning and not self.endingSong) and not self.inCutscene and not self.startingSong then
        self:finishSong()
    end

    if self.unspawnNotes[1] ~= nil then
        local time = self.spawnTime
        if self.songSpeed < 1 then time = time / self.songSpeed end
        if self.unspawnNotes[1].multSpeed < 1 then time = time / self.unspawnNotes[1].multSpeed end

        while (#self.unspawnNotes > 0 and self.unspawnNotes[1].strumTime - Conductor.songPosition < time) do
            local note = table.remove(self.unspawnNotes, 1)
            --self.notes:add(note)
            if not note.isSustainNote then
                self.notes:add(note)
            else
                self.sustainNotes:add(note)
            end
            note.spawned = true
            note.camera = self.camHUD
            --print(#self.notes.members)
        end
    end

    -- set camGame to camFollow
    --self.camGame.x = CoolUtil.coolLerp(self.camGame.x, self.camFollow.x, 0.04 * self.cameraSpeed)
    --self.camGame.y = CoolUtil.coolLerp(self.camGame.y, self.camFollow.y, 0.04 * self.cameraSpeed)
    self.camGame.x, self.camGame.y = self.camFollow.x, self.camFollow.y
    self.camGame.target.x, self.camGame.target.y = self.camFollow.x, self.camFollow.y
    --print(self.camGame.x, self.camGame.y, self.camFollow.x, self.camFollow.y)

    if self.camZooming then
        self.camGame.zoom = math.lerp(self.defaultCamZoom, self.camGame.zoom, math.bound(1 - (dt * 3.125), 0, 1))
        self.camHUD.zoom = math.lerp(1, self.camHUD.zoom, math.bound(1 - (dt * 3.125), 0, 1))
    end

    if self.generatedMusic and not self.inCutscene and self.startedCountdown then
        if not self.cpuControlled then
            self:keysCheck()
        end
        if #self.notes.members > 0 then
            if self.startedCountdown then
                local fakeCrochet = (60 / self.SONG.bpm) * 1000
                for i, note in ipairs(self.notes.members) do
                    local strumGroup = self.playerStrums
                    if not note.mustPress then strumGroup = self.opponentStrums end
                    --print(#strumGroup.members, note.noteData)
                    local strum = strumGroup.members[note.noteData+1]
                    note:followStrumNote(strum, fakeCrochet, self.songSpeed)

                    if note.mustPress then
                        if self.cpuControlled and not note.blockHit and note.canBeHit and note.strumTime <= Conductor.songPosition then
                            self:goodNoteHit(note)
                        end
                    elseif note.wasGoodHit and not note.hitByOpponent and not note.ignoreNote and not (Conductor.songPosition <= 10) then
                        self:opponentNoteHit(note)
                    end

                    if note.isSustainNote and strum.sustainReduce then 
                        note:clipToStrumNote(strum) 
                    end

                    if Conductor.songPosition - note.strumTime > self.noteKillOffset then
                        if note.mustPress and not self.cpuControlled and not note.ignoreNote and not self.endingSong and (note.tooLate or not note.wasGoodHit) then
                            self:noteMiss(note)
                        end


                        note.active = false
                        note.visible = false

                        note:kill()
                        self.notes:remove(note)
                        note:destroy()
                    end
                end
            end
        end

        if #self.sustainNotes.members > 0 then
            if self.startedCountdown then
                local fakeCrochet = (60 / self.SONG.bpm) * 1000
                for i, note in ipairs(self.sustainNotes.members) do
                    local strumGroup = self.playerStrums
                    if not note.mustPress then strumGroup = self.opponentStrums end
                    --print(#strumGroup.members, note.noteData)
                    local strum = strumGroup.members[note.noteData+1]
                    note:followStrumNote(strum, fakeCrochet, self.songSpeed)
    
                    if note.mustPress then
                        if self.cpuControlled and not note.blockHit and note.canBeHit and note.isSustainNote then
                            self:goodNoteHit(note)
                        end
                    elseif note.wasGoodHit and not note.hitByOpponent and not note.ignoreNote then
                        self:opponentNoteHit(note)
                    end
    
                    if note.isSustainNote and strum.sustainReduce then 
                        note:clipToStrumNote(strum) 
                    end
    
                    if Conductor.songPosition - note.strumTime > self.noteKillOffset then
                        if note.mustPress and not self.cpuControlled and not note.ignoreNote and not self.endingSong and (note.tooLate or not note.wasGoodHit) then
                            self:noteMiss(note)
                        end
    
                        note.active = false
                        note.visible = false
    
                        self.sustainNotes:remove(note)
                        print(#self.sustainNotes.members)
                    end
                end
            end
        end
        self:checkEventNote()
    end

    for i = 1, 4 do
        -- inputs
        if input:pressed(self.keysArray[i]) then
            self:keyPressed(i)
        end
        if input:down(self.keysArray[i]) then
            self:keyDown(i)
        end
        if input:released(self.keysArray[i]) then
            self:keyReleased(i)
        end
    end
end

function PlayState:checkEventNote()
    while #self.eventNotes > 0 do
        local leStrumTime = self.eventNotes[1].strumTime
        if Conductor.songPosition < leStrumTime then return end 

        local v1 = ""
        if self.eventNotes[1].value1 then v1 = self.eventNotes[1].value1 end

        local v2 = ""
        if self.eventNotes[1].value2 then v2 = self.eventNotes[1].value2 end

        self:triggerEvent(self.eventNotes[1].event, v1, v2, leStrumTime)

        table.remove(self.eventNotes, 1)
    end
end

function PlayState:triggerEvent(eventName, value1, value2, strumTime)
    -- remove trailing spaces
    local eventName = eventName
    local f1 = tonumber(value1)
    local f2 = tonumber(value2)
    local f1 = f1 or nil 
    local f2 = f2 or nil

    if eventName == "Hey!" then
        local value = 2
        local v1 = tostring(v1):lower()
        if v1 == "bf" or v1 == "boyfriend" or v1 == "0" then
            value = 0
        elseif v1 == "gf" or v1 == "girlfriend" or v1 == "1" then
            value = 1
        end

        if not f2 or f2 <= 0 then f2 = 0.6 end 

        if value ~= 0 then
            if self.dad.curCharacter:startsWith("gf") then
                self.dad:playAnim("cheer", true)
                self.dad.specialAnim = true
                self.dad.heyTimer = f2
            elseif self.gf then 
                self.gf:playAnim("cheer", true)
                self.gf.specialAnim = true
                self.gf.heyTimer = f2
            end
        end
        if value ~= 1 then
            self.boyfriend:playAnim("hey", true)
            self.boyfriend.specialAnim = true
            self.boyfriend.heyTimer = f2
        end
    elseif eventName == "Set Gf Speed" then
        if not f1 or f1 < 1 then f1 = 1 end
        self.gfSpeed = math.round(f1)
    elseif eventName == "Add Camera Zoom" then
        if self.camGame.zoom < 1.35 then
            if not f1 then f1 = 0.015 end
            if not f2 then f2 = 0.03 end

            self.camGame.zoom = self.camGame.zoom + f1
            self.camHUD.zoom = self.camHUD.zoom + f2
        end
    elseif eventName == "Play Animation" then
        local char = self.dad
        local v_2 = value2:lower()
        if v_2 == "bf" or v_2 == "boyfriend" then
            char = self.boyfriend
        elseif v_2 == "gf" or v_2 == "girlfriend" then
            char = self.gf
        else
            if not fv2 then fv2 = 0 end
            if fv2 == 1 then
                char = self.boyfriend
            elseif fv2 == 2 then
                char = self.gf
            end
        end

        if char then
            char:playAnim(value1, true)
            char.specialAnim = true
        end
    elseif eventName == "Set Property" then
        TryExcept(
            function()
                local split = value1:split(".")
                local obj = self
                for i = 1, #split do
                    if i == #split then
                        obj[split[i]] = f1
                    else
                        obj = obj[split[i]]
                    end
                end
            end,
            function(e)
                print("ERROR ('Set Property' Event) - " .. e)
            end
        )
    end

    --print("Event: " .. eventName .. " | " .. value1 .. " | " .. value2 .. " | " .. strumTime)
    stage:eventCalled(eventName, value1, value2, f1, f2, strumTime)
end

function PlayState:keyDown(key)
    local inputname = PlayState.keysArray[key]
    self.inputsArray[key] = true
end

function PlayState:draw()
    for i, member in ipairs(self.members) do
        if member.draw then
            if member.class and member.class == "Sprite" then
                if not (member.exists or member.alive or member.visible) then
                    return
                end
            end
            member:draw()
        end
    end
end

function PlayState:opponentNoteHit(note)
    if Paths.formatToSongPath(self.SONG.song) ~= "tutorial" then
        self.camZooming = true
    end

    if note.noteType == "Hey!" and self.dad.animations["hey"] then
        self.dad:playAnim("hey", true)
        self.dad.specialAnim = true
        self.dad.heyTimer = 0.6
    elseif not note.noAnimation then
        local altAnim = note.animSuffix

        if self.SONG.notes[self.curSection] then
            if self.SONG.notes[self.curSection].altAnim and not self.SONG.notes[self.curSection].gfSection then
                altAnim = "-alt"
            end
        end

        local char = self.dad
        local animToPlay = self.singAnimations[math.floor(math.abs(math.min(#self.singAnimations, note.noteData+1)))] .. altAnim
        if note.gfNote then
            char = self.gf
        end
        
        if char then
            char:playAnim(animToPlay, true)
            char.holdTimer = 0
        end
    end

    if self.vocals then
        self.vocals:setVolume(1)
    end

    self:strumPlayAnim(true, math.floor(math.abs(note.noteData+1)), Conductor.stepCrochet * 1.25 / 1000 / self.playbackRate)
    note.hitByOpponent = true

    if not note.isSustainNote then
        note:kill()
        self.notes:remove(note)
        note:destroy()
        note = nil
    end
end

function PlayState:strumPlayAnim(isDad, id, time)
    local spr = nil
    if isDad then
        spr = self.opponentStrums.members[id]
    else
        spr = self.playerStrums.members[id]
    end

    if spr then
        spr:playAnim("confirm", true)
        spr.resetAnim = time
    end
end

function PlayState:endSong()
    if not self.startingSong then
        for i, note in ipairs(self.notes.members) do
            if note.strumTime < self.inst:tell("seconds") - Conductor.safeZoneOffset then
                health = health - 0.05 * self.healthloss
            end
        end
        for i, note in ipairs(self.sustainNotes.members) do
            if note.strumTime < self.inst:tell("seconds") - Conductor.safeZoneOffset then
                health = health - 0.05 * self.healthloss
            end
        end
        for i, note in ipairs(self.unspawnNotes) do
            if note.strumTime < self.inst:tell("seconds") - Conductor.safeZoneOffset then
                health = health - 0.05 * self.healthloss
            end
        end

        self.endingSong = true

        if not self.transitioning then
            if self.isStoryMode then
                self.campaignScore = self.campaignScore + self.songScore
                self.campaignMisses = self.campaignMisses + self.songMisses

                table.remove(self.storyPlaylist, 1)

                if #self.storyPlaylist <= 0 then
                    MusicBeatState:fadeOut(0.3, function() MusicBeatState:switchState(StoryMenuState) end)
                else
                    local difficulty = Difficulty:getFilePath()
                    local songName = PlayState.storyPlaylist[1]
                    PlayState.SONG = Song:loadFromJson(songName .. difficulty, songName)
                    if self.inst:isPlaying() then
                        self.inst:stop()
                    end
                    if self.vocals and self.vocals:isPlaying() then
                        self.vocals:stop()
                    end

                    MusicBeatState:fadeOut(0.3, function() MusicBeatState:switchState(PlayState) end)
                end
            end
            self.transitioning = true
        end
    end
end

function PlayState:cachePopUpScore()
    if stageUI == "pixel" then
        for i, rating in ipairs(self.ratingsData) do
            Paths.image("pixel/pixelUI/" .. rating.image .. "-pixel")
        end
        for i = 1, 9 do
            Paths.image("pixel/pixelUI/num" .. i)
        end
    else
        for i, rating in ipairs(self.ratingsData) do
            Paths.image("ui/" .. rating.image)
        end
        for i = 1, 9 do
            Paths.image("ui/num" .. i)
        end
    end
end

function PlayState:popUpScore(note)
    local noteDiff = math.abs(note.strumTime - Conductor.songPosition)
    if self.vocals then self.vocals:setVolume(1) end

    local placement = push:getWidth() * 0.35
    local rating = Sprite()
    local score = 350

    local daRating = Conductor.judgeNote(self.ratingsData, noteDiff)

    self.totalNotesHit = (self.totalNotesHit or 0) + daRating.ratingMod
    note.ratingMod = daRating.ratingMod
    if not note.ratingDisabled then daRating.hits = daRating.hits + 1 end
    note.rating = daRating.name
    score = daRating.score

    if not self.practiceMode and not self.cpuControlled then
        self.songScore = self.songScore + score
        if not note.ratingDisabled then
            self.songHits = (self.songHits or 0) + 1
            self.totalPlayed = (self.totalPlayed or 0) + 1
            self:recalculateRating(false)
        end
    end

    if self.stageUI == "pixel" then
        rating:load(Paths.image("pixel/pixelUI/" .. daRating.image .. "-pixel"))
    else
        rating:load(Paths.image("ui/" .. daRating.image))
    end

    rating:screenCenter()
    rating.x = placement - 40
    rating.y = rating.y - 60
    rating.acceleration.y = 550 * self.playbackRate * self.playbackRate
    rating.velocity.y = rating.velocity.y - love.math.random(140, 175) * self.playbackRate
    rating.velocity.x = love.math.random(0, 10) * self.playbackRate

    table.insert(self.members, table.indexOf(self.members, self.strumLineNotes), rating)

    if not PlayState.isPixelStage then
        rating:setGraphicSize(math.floor(rating.width * 0.7))
    else
        rating:setGraphicSize(math.floor(rating.width * self.daPixelZoom * 0.85))
        rating.antialiasing = false
    end

    local seperatedScore = {}

    if self.combo >= 1000 then
        table.insert(seperatedScore, math.floor(self.combo / 1000) % 10)
    end
    table.insert(seperatedScore, math.floor(self.combo / 100) % 10)
    table.insert(seperatedScore, math.floor(self.combo / 10) % 10)
    table.insert(seperatedScore, math.floor(self.combo) % 10)

    local daLoop = 0
    local xThing = 0

    for i, score in ipairs(seperatedScore) do
        local numScore = Sprite()
        if self.isPixelStage then
            numScore:load(Paths.image("pixel/pixelUI/num" .. score .. "-pixel"))
        else
            numScore:load(Paths.image("ui/num" .. score))
        end
        numScore:screenCenter()
        numScore.x = placement + (43 * daLoop) 
        numScore.y = numScore.y + 80

        if not PlayState.isPixelStage then
            numScore:setGraphicSize(math.floor(numScore.width * 0.5))
        else
            numScore:setGraphicSize(math.floor(numScore.width * self.daPixelZoom))
            numScore.antialiasing = false
        end

        numScore.acceleration.y = love.math.random(200, 300) * self.playbackRate * self.playbackRate
        numScore.velocity.y = numScore.velocity.y - love.math.random(140, 160) * self.playbackRate
        numScore.velocity.x = love.math.random(-5, -5) * self.playbackRate

        table.insert(self.members, table.indexOf(self.members, self.strumLineNotes), numScore)

        Timer.after(Conductor.crochet * 0.002 / self.playbackRate, function()
            Timer.tween(0.2/self.playbackRate, numScore, {alpha = 0}, "linear", function() 
                numScore.alpha = 0
                numScore.alive = false
                numScore.exists = false
                self:remove(numScore)
            end)
        end)

        daLoop = daLoop + 1
        if numScore.x > xThing then
            xThing = numScore.x
        end
    end

    Timer.after(Conductor.crochet * 0.001 / self.playbackRate, function()
        Timer.tween(0.2/self.playbackRate, rating, {alpha = 0}, "linear", function() 
            -- gross and weird hack, but it didn't work without this stuff?? idk i hate lua sometimes
            rating.alpha = 0
            rating.alive = false
            rating.exists = false
            PlayState:remove(rating)
        end)
    end)
end

function PlayState:finishSong(ignoreNoteOffset)
    self.updateTime = false
    self:endCallback()
end

function PlayState:noteMissCommon(direction, note)
    local subtract = 0.05
    if note then subtract = note.missHealth end
    self.health = self.health - subtract * self.healthloss

    self.combo = 0

    self.songScore = self.songScore - 10
    if not self.endingSong then
        self.songMisses = self.songMisses + 1
    end
    self.totalPlayed = (self.totalPlayed or 0) + 1
    self:recalculateRating(true)

    local char = self.boyfriend

    if (note and note.gfNote) or (self.SONG.notes[self.curSection] and self.SONG.notes[self.curSection].gfSection) then
        char = self.gf
    end
    
    if char and char.hasMissAnimations then
        local suffix = ""
        if note then
            suffix = note.animSuffix
        end

        local animToPlay = self.singAnimations[math.floor(math.abs(math.min(#self.singAnimations, direction+1)))] .. "miss" .. suffix
        char:playAnim(animToPlay, true)

        if char ~= self.gf and self.combo > 5 and self.gf and self.animOffsets["sad"] then
            self.gf:playAnim("sad", true)
            self.gf.specialAnim = true
        end
    end
    if self.vocals then
        self.vocals:setVolume(0)
    end
end

function PlayState:noteMiss(note)
    for i, note2 in ipairs(self.notes.members) do
        -- remove dupe note
        if note ~= note2 and note2.mustPress and note2.noteData == note.noteData and note2.isSustainNote == note.isSustainNote and math.abs(note2.strumTime - note.strumTime) < 1 then
            self.notes:remove(note2)
        end
    end
    -- same in sustain notes
    for i, note2 in ipairs(self.sustainNotes.members) do
        -- remove dupe note
        if note ~= note2 and note2.mustPress and note2.noteData == note.noteData and note2.isSustainNote == note.isSustainNote and math.abs(note2.strumTime - note.strumTime) < 1 then
            self.sustainNotes:remove(note2)
        end
    end

    if note.isSustainNote then
        self.sustainNotes:remove(note)
    else
        self.notes:remove(note)
    end
    self:noteMissCommon(note.noteData, note)
end

function PlayState:generateSong(dataPath)
    local dataPath = Paths.formatToSongPath(dataPath)
    self.songSpeed = self.SONG.speed
    
    local songData = self.SONG
    Conductor.changeBPM(songData.bpm)

    self.curSong = songData.song

    self.vocals = songData.needsVoices and love.audio.newSource("assets/songs/" .. dataPath .. "/" .. "Voices.ogg", "stream") or nil
    self.inst = love.audio.newSource("assets/songs/" .. dataPath .. "/" .. "Inst.ogg", "stream")

    notes = Group()
    self:add(notes)

    local noteData = {}

    noteData = songData.notes

    local file = "assets/data/" .. dataPath .. "/events.json"
    if love.filesystem.getInfo(file) then
        local eventsData = Song:loadFromJson("events", self.songName).events
        for _, event in ipairs(eventsData) do
            for i = 1, #event[2] do
                -- avoid duplicate events

                local found = false
                for i2, event2 in ipairs(self.eventNotes) do
                    if event2[1] == event[1] and event2[2][1] == event[2][1] and event2[2][2] == event[2][2] and event2[2][3] == event[2][3] then
                        found = true
                    end
                end

                if not found then -- why does psytch have 2 formats
                    if type(event[2][1]) ~= "table" then
                        self:makeEvent(event, i)
                    else
                        local new_event = {}
                        new_event[1] = event[1]
                        new_event[2] = event[2][1]
                        self:makeEvent(new_event, i)
                    end
                end
            end
        end
    end

    for i, section in ipairs(noteData) do
        for i2, songNotes in ipairs(section.sectionNotes) do
            local daStrumTime = songNotes[1]
            local daNoteData = math.floor(songNotes[2] % 4)
            local gottaHitNote = section.mustHitSection

            if songNotes[2] > 3 then
                gottaHitNote = not gottaHitNote
            end

            local oldNote = nil
            if #self.unspawnNotes > 0 then
                oldNote = self.unspawnNotes[1]
            end

            local swagNote = Note(daStrumTime, daNoteData, oldNote)
            swagNote.mustPress = gottaHitNote
            swagNote.sustainlength = songNotes[3]
            swagNote.gfNote = (section.gfSection and (songNotes[2]<4))
            swagNote.noteType = songNotes[4]

            local susLength = swagNote.sustainlength / Conductor.stepCrochet

            table.insert(self.unspawnNotes, swagNote)

            -- holdnote shits
            local floorSus = math.floor(susLength)
            if floorSus > 0 then
                for susNote = 0, floorSus do
                    local oldNote = self.unspawnNotes[#self.unspawnNotes]
                    --print(daStrumTime + (Conductor.stepCrochet * susNote))

                    local sustainNote = Note(daStrumTime + (Conductor.stepCrochet * susNote), daNoteData, oldNote, true)
                    sustainNote.mustPress = gottaHitNote
                    sustainNote.gfNote = (section.gfSection and (songNotes[2]<4))
                    sustainNote.noteType = swagNote.noteType
                    table.insert(swagNote.tail, sustainNote)
                    table.insert(self.unspawnNotes, sustainNote) 
                    sustainNote.correctionOffset = swagNote.height / 2
                    if not PlayState.isPixelStage then
                        if oldNote.isSustainNote then
                            oldNote:updateHitbox()
                        end

                        -- downscroll correctionoffset = 0
                    elseif oldNote.isSustainNote then
                        oldNote:updateHitbox()
                    end

                    if sustainNote.mustPress then
                        sustainNote.x = sustainNote.x + push.getWidth() / 2
                    -- middle scroll
                    end
                end
            end

            if swagNote.mustPress then
                swagNote.x = swagNote.x + push.getWidth() / 2
            end
        end
    end

    -- sort unspawnNotes by strumTime
    table.sort(self.unspawnNotes, function(a, b) return a.strumTime < b.strumTime end)
end

function PlayState:eventPushed(event)
    self:eventPushedUnique(event)
    if self.eventsPushed[event.event] then
        return
    end

    stage:eventPushed(event)
    table.insert(self.eventsPushed, event.event)
end

function PlayState:eventPushedUnique(event)
    if event.event == "Change Character" then -- BEST TO PRELOAD!!!!
        local charType = 0
        local v1 = tostring(event.value1):lower() -- safe guard
        if v1 == "gf" or v1 == "girlfriend" or v1 == "1" then
            charType = 2
        elseif v1 == "dad" or v1 == "opponent" or v1 == "0" then
            charType = 1
        else
            v1 = tonumber(v1)
            if v1 then
                charType = v1
            else
                charType = 0
            end
        end

        local newCharacter = event.value2
        --self:addCharacterToList(newCharacter, charType)
    elseif event.event == "Play Sound" then
        Paths.sound(event.value1):play()
    end
end

function PlayState:eventEarlyTrigger(event)
    -- event.event if
end

function PlayState:makeEvent(event, i)
    SubEvent = EventNote(
        event[1],
        event[2][1],
        event[2][2],
        event[2][3]
    )
    table.insert(self.eventNotes, SubEvent)
    self:eventPushed(SubEvent)
end

function PlayState:startCountdown()
    if stage.music then
        stage.music:stop()
    end
    self.seenCutscene = true
    self.inCutscene = false

    if skipCountdown then
        self.skipArrowTween = true
    end

    self:generateStaticArrows(0)
    self:generateStaticArrows(1)

    self.startedCountdown = true
    Conductor.songPosition = -Conductor.crochet * 5

    if self.skipCountdown then
        Conductor.songPosition = 0
        return true
    end
    self:moveCameraSection()
    self.updateTime = true

    self.loops = 5
    function self:doCountdown()
        local startTimer = Timer.after(Conductor.crochet / 1000 / self.playbackRate, function()
            if self.gf and self.loops % math.round(self.gfSpeed * self.gf.danceEveryNumBeats) == 0 and self.gf.curAnim and not self.gf.curAnim.name:startsWith("sing") then
                self.gf:dance()
            end
            if self.loops % self.boyfriend.danceEveryNumBeats == 0 and self.boyfriend.curAnim ~= nil and not self.boyfriend.curAnim.name:startsWith("sing") then
                self.boyfriend:dance()
            end
            if self.loops % self.dad.danceEveryNumBeats == 0 and self.dad.curAnim ~= nil and not self.dad.curAnim.name:startsWith("sing") then
                self.dad:dance()
            end

            local introAssets = self.stageUI == "pixel" and {"pixel/pixelUI/ready-pixel", "pixel/pixelUI/set-pixel", "pixel/pixelUI/date-pixel"} or 
                self.stageUI == "normal" and {"ui/ready", "ui/set", "ui/go"} or
                {"ready", "set", "go"}
            local antialias = not self.isPixelStage
            local tick = "THREE"

            local introSoundsSuffix = ""
            if self.stageUI == "pixel" then
                introSoundsSuffix = "-pixel"
            end

            if self.loops == 5 then
                Sound.play(Paths.sound("assets/sounds/intro3" .. introSoundsSuffix .. ".ogg"))
                tick = "THREE"
            elseif self.loops == 4 then
                self:createCountdownSprite(introAssets[1], antialias)
                Sound.play(Paths.sound("assets/sounds/intro2" .. introSoundsSuffix .. ".ogg"))
                tick = "TWO"
            elseif self.loops == 3 then
                self:createCountdownSprite(introAssets[2], antialias)
                Sound.play(Paths.sound("assets/sounds/intro1" .. introSoundsSuffix .. ".ogg"))
                tick = "ONE"
            elseif self.loops == 2 then
                self:createCountdownSprite(introAssets[3], antialias)
                Sound.play(Paths.sound("assets/sounds/introGo" .. introSoundsSuffix .. ".ogg"))
                tick = "GO"
            elseif self.loops == 1 then
                tick = "START"

                -- play inst, and voices if it exists
                if self.vocals then
                    self.vocals:play()
                end
                self.inst:play()

                self.startingSong = false

                return true
            end

            stage:countdownTick(tick, self.loops)

            self.loops = self.loops - 1
            if self.loops > 0 then
                self:doCountdown()
            end
        end)
    end
    self:doCountdown()
end

function PlayState:createCountdownSprite(image, antialias)
    local spr = Sprite(0, 0, image)
    spr.scrollFactor = {x=0, y=0}
    spr.camera = self.camHUD
    spr:screenCenter()

    if self.isPixelStage then
        spr:setGraphicSize(math.floor(spr.width * self.daPixelZoom))
        spr.x, spr.y = spr.x - 200, spr.y - 100
    end

    
    spr.antialiasing = antialias
    self:add(spr)
    Timer.tween(Conductor.crochet / 1000, spr, {alpha = 0}, "in-out-cubic", function()
        spr.alpha = 0
        spr.visible = false
        self:remove(spr)
        spr = nil
    end)

    return spr
end

function PlayState:StartAndEnd()
    if self.endingSong then
        if self.endSong then self:endSong() end
    else
        if self.startCountdown then self:startCountdown() end
    end
end

function PlayState:generateStaticArrows(player)
    local strumLineX = self.STRUM_X
    strumLineY = 50

    for i = 1, 4 do
        local targetAlpha = 1
        if player < 1 then
            --
        end

        local babyArrow = StrumNote(strumLineX, strumLineY, i-1, player)
        babyArrow.downscroll = false
        babyArrow.camera = self.camHUD

        if player == 1 then
            self.playerStrums:add(babyArrow)
        else
            self.opponentStrums:add(babyArrow)
        end

        self.strumLineNotes:add(babyArrow)
        babyArrow:postAddedToGroup()
    end
end

function PlayState:keyPressed(key)
    local inputname = self.keysArray[key]
    if not self.cpuControlled and self.startedCountdown and not paused and key > -1 then
        if #self.notes.members > 0 and self.generatedMusic and not self.endingSing then
            local lastTime = Conductor.songPosition

            local pressNotes = {}
            local notesStopped = false
            local sortedNotesList = {}

            for i, note in ipairs(self.notes.members) do
                if note.canBeHit and note.mustPress and not note.tooLate and not note.wasGoodHit and not note.isSustainNote and not note.blockHit then
                    if key == note.noteData+1 then
                        table.insert(sortedNotesList, note)
                    end
                    self.canMiss = true
                end
            end

            -- sort notes by strumTime
            table.sort(sortedNotesList, function(a, b) return a.strumTime < b.strumTime end)

            if #sortedNotesList > 0 then
                for i, epicNote in ipairs(sortedNotesList) do
                    for i2, doubleNote in ipairs(pressNotes) do
                        if math.abs(doubleNote.strumTime - epicNote.strumTime) < 1 then
                            self.notes:remove(doubleNote)
                        else
                            notesStopped = true
                        end
                    end

                    if not notesStopped then
                        self:goodNoteHit(epicNote)
                    end
                    table.insert(pressNotes, epicNote)
                end
            end
        end
    end

    local spr = self.playerStrums.members[key]
    if spr and spr.curAnim and spr.curAnim.name ~= "confirm" then
        spr:playAnim("pressed")
        spr.resetAnim = 0
    end
end

function PlayState:goodNoteHit(note)
    if not note.wasGoodHit then
        if self.vocals then self.vocals:setVolume(1) end
        if self.cpuControlled and (note.ignoreNote or note.hitCausesMiss) then return end

        note.wasGoodHit = true

        if not note.isSustainNote then
            self.combo = self.combo + 1
            if self.combo > 9999 then self.combo = 9999 end
            self:popUpScore(note)
        end
        self.health = self.health + note.hitHealth * self.healthGain

        if not note.noAnimation then
            local animToPlay = self.singAnimations[math.floor(math.abs(math.min(#self.singAnimations, note.noteData+1)))]
            local char = self.boyfriend
            local animCheck = "hey"
            if note.gfNote then
                char = self.gf
                animCheck = "cheer"
            end
            if char ~= nil then
                char:playAnim(animToPlay .. note.animSuffix, true)
                char.holdTimer = 0

                if note.noteType == "Hey!" then
                    if char.animations[animCheck] then
                        char:playAnim(animCheck, true)
                        char.specialAnim = true
                        char.heyTimer = 0.6
                    end
                end
            end
        end

        if not self.cpuControlled then
            local spr = self.playerStrums.members[note.noteData+1]
            if spr then
                spr:playAnim("confirm", true)
            end
        else 
            self:strumPlayAnim(false, math.floor(math.abs(note.noteData+1)), Conductor.stepCrochet * 1.25 / 1000 / self.playbackRate)
        end 
        
        if self.voices then
            self.voices:setVolume(1)
        end

        local isSus = note.isSustainNote
        local leData = math.round(math.abs(note.noteData+1))
        local leType = note.noteType

        if not note.isSustainNote then
            note:kill()
            self.notes:remove(note)
            note:destroy()
            note = nil
        end
    end
end

function PlayState:keyReleased(key)
    if not self.cpuControlled and self.startedCountdown and not paused then
        local spr = self.playerStrums.members[key]
        if spr then
            spr:playAnim("static")
            spr.resetAnim = 0
        end
    end

    self.inputsArray[key] = false
end

function PlayState:tweenCamIn()
    if Paths.formatToSongPath(self.SONG.song) == "tutorial" and not self.cameraTwn and self.camGame.zoom ~= 1.3 then
        self.cameraTwn = Timer.tween(Conductor.stepCrochet*4/1000, self.camGame, {zoom = 1.3}, "in-bounce", function() self.cameraTwn = nil end)
    end
end

function PlayState:beatHit()
    stage:beatHit()
    self.iconP1.scale = {x=1.2, y=1.2}
    self.iconP2.scale = {x=1.2, y=1.2}
    self.iconP1:updateHitbox()
    self.iconP2:updateHitbox()
    self.curBeat = self.curBeat + 1
    if self.gf and self.curBeat % math.round(self.gfSpeed * self.gf.danceEveryNumBeats) == 0 and self.gf.curAnim and not self.gf.curAnim.name:startsWith("sing") then
        self.gf:dance()
    end
    if self.curBeat % self.boyfriend.danceEveryNumBeats == 0 and self.boyfriend.curAnim ~= nil and not self.boyfriend.curAnim.name:startsWith("sing") then
        self.boyfriend:dance()
    end
    if self.curBeat % self.dad.danceEveryNumBeats == 0 and self.dad.curAnim ~= nil and not self.dad.curAnim.name:startsWith("sing") then
        self.dad:dance()
    end

    self.super.beatHit(self)
end

function PlayState:stepHit()
    stage:stepHit()
    self.super.stepHit(self)
end

function PlayState:keysCheck()
    local holdArray = {}
    local pressArray = {}
    local releaseArray = {}

    for i, key in ipairs(self.keysArray) do
        table.insert(holdArray, input:down(key))
        table.insert(pressArray, input:pressed(key))
        table.insert(releaseArray, input:released(key))
    end

    if self.startedCountdown and self.generatedMusic then
        if #self.sustainNotes.members > 0 then
            for i, note in ipairs(self.sustainNotes.members) do
                if note.canBeHit and note.mustPress and not note.tooLate and not note.wasGoodHit and note.isSustainNote and not note.blockHit and self.inputsArray[note.noteData+1] then
                    self:goodNoteHit(note)
                end
            end
        end

        -- bf anim
        if self.boyfriend.curAnim ~= nil and self.boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / PlayState.playbackRate) * self.boyfriend.singDuration and self.boyfriend.curAnim.name:startsWith("sing") and not self.boyfriend.curAnim.name:endsWith("miss") then
            self.boyfriend:dance()
        end
    end
end

return PlayState