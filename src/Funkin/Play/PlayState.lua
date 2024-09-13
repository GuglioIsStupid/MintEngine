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

    self.vocals = {}

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
    self.isPracticeMode = params.isPracticeMode
    self.isBotPlayMode = params.isBotPlayMode
    self.isMinimalMode = params.isMinimalMode
    self.startTimestamp = params.startTimestamp
    self.playbackRate = params.playbackRate
    self.overrideMusic = params.overrideMusic
    self.previousCameraFollowPoint = params.cameraFollowPoint

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
        Conductor.instrumentalOffset = chart.offsets:getInstrumentalOffset()
    end

    Conductor.mapTimeChanges(chart.timeChanges)
    Conductor.update((Conductor.get_beatLengthMs() * -5) + self.startTimestamp)

    self:initCameras()
    self:initHealthbar()

    self:initStage()
    self:initCharacters()

    self:initStrumlines()

    self:initPreciseInputs()

    self.startingSong = true

    if ((self.currentSong and self.currentSong.id or ""):lower() == "winter-horrorland") then

    else
        self:startCountdown()
    end

    MusicBeatState.create(self)

    self.initialized = true
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

return PlayState