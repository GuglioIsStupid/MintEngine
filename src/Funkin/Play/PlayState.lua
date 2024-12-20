local PlayState = MusicBeatState:extend("PlayState")
PlayState.instance = nil

function PlayState:new(params)
    self.instance = self
    self.currentSong = nil
    self.currentDifficulty = Constants.DEFAULT_DIFFICULTY
    self.currentVariation = Constants.DEFAULT_VARIATION
    self.currentInstrumental = ""
    self.needsReset = false
    self.deathCounter = 0
    self.health = Constants.HEALTH_STARTING
    self.songScore = 0
    self.startTimestamp = 0
    self.playbackRate = 1
    self.cameraFollowPoint = Object()
    self.cameraZoomTween = nil
    self.scrollSpeedTweens = {}
    self.previousCameraFollowPoint = nil
    self.currentCameraZoom = Camera.defaultZoom
    self.cameraBopMultiplier = 1

    self.defaultHUDCameraZoom = Camera.defaultZoom * 1.0
    self.cameraBopIntensity = Constants.DEFAULT_BOP_INTENSITY
    self.hudCameraZoomIntensity = 0.015 * 2
    self.cameraZoomRate = Constants.DEFAULT_ZOOM_RATE
    self.isInCountdown = false
    self.isPracticeMode = false
    self.isBotPlayMode = false
    self.isPlayerDying = false
    self.isMinimalMode = false
    self.isInCutscene = false
    self.disableKeys = false

    self.inputPressQueue = {}
    self.inputReleaseQueue = {}

    self.justUnpaused = false

    self.songEvents = {}
    self.mayPauseGame = true

    self.healthLerp = Constants.HEALTH_STARTING

    self.skipHeldTimer = 0
    self.overrideMusic = false
    self.criticalFailure = false

    self.startingSong = false
    self.musicPausedBySubState = false

    self.cameraTweensPausedBySubState = false
    self.initialized = false

    self.vocals = VoicesGroup()

    self.isGamePaused = false
    self.isExitingViaPauseMenu = false

    self.generatedMusic = false
    self.perfectMode = false

    self.BACKGROUND_COLOR = {0, 0, 0, 1}

    self.currentSong = params.targetSong
    if params.targetDifficulty then
        self.currentDifficulty = params.targetDifficulty
    end
    if params.targetVariation then
        self.currentVariation = params.targetVariation
    end
    if params.targetInstrumental then
        self.currentInstrumental = params.targetInstrumental
    end
    self.isPracticeMode = params.isPracticeMode or false
    self.isBotPlayMode = params.isBotPlayMode or false
    self.isMinimalMode = params.isMinimalMode or false
    self.startTimestamp = params.startTimestamp or 0
    self.playbackRate = params.playbackRate or 1
    self.overrideMusic = params.overrideMusic or false
    self.previousCameraFollowPoint = params.cameraFollowPoint or Object(0, 0)

    MusicBeatState.new(self)
end

function PlayState:create()
    PlayState.instance = self

    self.cameraFollowPoint = Object(0, 0)

    if not self.overrideMusic and Game.sound.music then
        Game.sound.music:stop()
    end

    local chart = self:get_currentChart()
    if not self.overrideMusic and chart then
        chart:cacheInst()
        chart:cacheVocals()
    end

    Conductor:forceBPM(nil)

    if chart.offsets ~= nil then
        Conductor.instrumentalOffset = chart.offsets--[[ :getInstrumentalOffset() ]]
    end

    Conductor:mapTimeChanges(chart)
    Conductor:update((Conductor.get_beatLengthMs() * -5) + self.startTimestamp)

    self:initCameras()
    self:initHealthbar()

    self:initStage()
    self:initCharacters()

    self:initStrumlines()

    self:initPreciseInputs()

    self:generateSong()

    self:resetCamera()
    
    self.startingSong = true
    self.isInCountdown = true

    if ((self.currentSong and self.currentSong.id or ""):lower() == "winter-horrorland") then

    else
        self:startCountdown()
    end

    MusicBeatState.create(self)

    self.initialized = true

    self:refresh()
end

function PlayState:get_stageZoom()
    if self.currentStage then
        return self.currentStage.zoom
    else
        return Camera.defaultZoom * 1.05
    end
end

function PlayState:get_currentChart()
    if not self.currentSong or not self.currentDifficulty then
        return {}
    end

    return self.currentSong:getDifficulty(self.currentDifficulty, self.currentVariation)
end

function PlayState:get_currentStageId()
    local curChart = self:get_currentChart()
    if not self.currentSong or curChart.stage or curChart.stage == "" then
        return Constants.DEFAULT_STAGE
    end

    return curChart.stage
end

function PlayState:get_currentSongLengthMs()
    if Game.sound.music then
        return Game.sound.music.length
    end
end

function PlayState:initCameras()
    self.camHUD = Camera()
    

    
end

function PlayState:initHealthbar()

end

function PlayState:initStage()
    self:loadStage(self:get_currentStageId())
end

function PlayState:initCharacters()

end

function PlayState:initStrumlines()

end

function PlayState:initPreciseInputs()

end

function PlayState:loadStage(id)
    self.currentStage = SongRegistry:fetchEntry(id)

    if self.currentStage ~= nil then
        self.currentStage:revive()

        self:resetCameraZoom()

        self:add(self.currentStage)
    else
        print("Failed to load stage " .. id)
    end
end

function PlayState:resetCameraZoom()
    self.currentCameraZoom = self:get_stageZoom()
    --Game._cameras[1].zoom = self.currentCameraZoom

    self.cameraBopMultiplier = 1
end

function PlayState:resetCamera(resetZoom, cancelTweens, snap)
    local resetZoom = resetZoom == nil and true or resetZoom
    local cancelTweens = cancelTweens == nil and true or cancelTweens
    local snap = snap == nil and true or snap

    if cancelTweens then
        --
    end

    --Game.camera.follow(self.cameraFollowPoint, 1, 1, 0, 0)
    --Game.camera.targetOffset:set()

    if resetZoom then
        self:resetCameraZoom()
    end
    
    --if snap then Game.camera.focusOn(self.cameraFollowPoint) end
end

function PlayState:startCountdown()
    self.isInCutscene = false
    self.camHUD.visible = true
end

function PlayState:update(dt)
    MusicBeatState.update(self, dt)

    if self.startingSong then
        if self.isInCountdown then
            Conductor:update(Conductor.songPosition + dt * 1000, false)
            if Conductor.songPosition >= self.startTimestamp then
                self:startSong()
            end
        end
    else
        Conductor:update(Conductor.songPosition + dt * 1000, false)
    end

    -- if pause

    if self.health > Constants.HEALTH_MAX then self.health = Constants.HEALTH_MAX end
    if self.health < Constants.HEALTH_MIN then self.health = Constants.HEALTH_MIN end

    if self.subState == nil and self.cameraZoomRate > 0 then
        self.cameraBopMultiplier = math.lerp(1, self.cameraBopMultiplier, 0.95)
        local zoomPlusBop = self.currentCameraZoom * self.cameraBopMultiplier
        --Game.camera.zoom = zoomPlusBop
        self.camHUD.zoom = math.lerp(self.defaultHUDCameraZoom, self.camHUD.zoom, 0.95)
    end

    if self.currentStage~= nil and self.currentStage:getBoyfriend() ~= nil then
    end

    if self.health <= Constants.HEALTH_MIN and not self.isPracticeMode and not self.isPlayerDying then
    end

    self:processSongEvents()
    
    self:processInputQueue()

    if not self.isInCutscene then
        self:processNotes(dt)
    end

    self.justUnpaused = false

    --[[ if Game.sound.music then
        if Game.sound.music.source then
            print(Game.sound.music.source:tell())
        end
    end ]]
end

function PlayState:startSong()
    self.startingSong = false

    local chart = self:get_currentChart()
    if not self.overrideMusic and not self.isGamePaused and chart ~= nil then
        print("Starting song " .. self.currentSong.id .. " on difficulty " .. self.currentDifficulty)
        chart:playInst(1.0, self.currentInstrumental, false)
    end

    if Game.sound.music == nil then
        print("Failed to start song")
        return
    end

    print("Starting song " .. self.currentSong.id .. " on difficulty " .. self.currentDifficulty)

    Game.sound.music.onComplete = function()
        print("Song ended")
    end

    Game.sound.music:play(true, (self.startTimestamp) / 1000)
    Game.sound.music.pitch = self.playbackRate

    Game.sound.music.volume = 1
    if Game.sound.music.fadeTween then Game.sound.music.fadeTween:cancel() end

    self:add(self.vocals)
    self.vocals:play()
    self.vocals.volume = 1
    self.vocals.pitch = self.playbackRate
    --[[ self:resyncVocals() ]]
end

function PlayState:generateSong()
    if self.currentCameraZoom == nil then
        print("Song difficulty not loaded")
    end

    if not self.overrideMusic then
        if self.vocals ~= nil then
            self.vocals:stop()
        end

        self.vocals = self:get_currentChart():buildVocals()
        if #self.vocals.members == 0 then
            print("WARN: No vocals found for song")
        end
    end

    self.generatedMusic = true
end

return PlayState