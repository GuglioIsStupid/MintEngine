local note_left, note_right, note_up, note_down, accept, back
-- first value is the one the player can change.
if love.system.getOS() == "NX" then
    note_left = {"key:a", "key:left", "axis:leftx-", "button:dpleft",  "axis:triggerleft+", "button:y", "axis:rightx-"}
    note_right = {"key:d", "key:right", "axis:leftx+", "button:dpright", "button:a", "axis:triggerright+", "axis:rightx+"}
    note_up = {"key:w", "key:up", "axis:lefty-", "button:dpup", "button:rightshoulder", "button:x", "axis:righty-"}
    note_down = {"key:s", "key:down", "axis:lefty+", "button:dpdown", "button:leftshoulder", "button:b", "axis:righty+"}
else
    -- same thing, but y/x, a/b are swapped
    note_left = {"key:a", "key:left", "axis:leftx-", "button:dpleft",  "axis:triggerleft+", "button:x", "axis:rightx-"}
    note_right = {"key:d", "key:right", "axis:leftx+", "button:dpright", "button:b", "axis:triggerright+", "axis:rightx+"}
    note_up = {"key:w", "key:up", "axis:lefty-", "button:dpup", "button:rightshoulder", "button:y", "axis:righty-"}
    note_down = {"key:s", "key:down", "axis:lefty+", "button:dpdown", "button:leftshoulder", "button:a", "axis:righty+"}
end

local SaveVariables = {
    downScroll = true,
    middleScroll = false,
    opponentStrums = true,
    showFPS = true,
    flashing = true,
    autoPause = true,
    splashAlpha = 0.6,
    shaders = true,
    --framerate = 60, --todo.
    camZooms = true,
    noteOffset = 0,
    ghostTapping = true,
    timeBarType = "Time Left",
    scoreZoom = true,
    noReset = false,
    healthBarAlpha = 1,
    --hitSoundVolume = 0 --todo.
    pauseMusic = "breakfast",
    comboStacking = true,
    gameplaySettings = {
        scrollspeed = 1,
        scrolltype = "multiplicative",
        songspeed = 1,
        healthgain = 1,
        healthloss = 1,
        instakill = false,
        practice = false,
        botplay = false,
        opponentplay = false
    },
    comboOffset = {0,0,0,0},
    ratingoffset = 0,
    sickWindow = 45,
    goodWindow = 90,
    badWindow = 135,
    safeFrames = 10,

    locale = "en",

    controls = {
        note_left = note_left,
        note_right = note_right,
        note_up = note_up,
        note_down = note_down,

        accept = {"key:return", "button:a"},
        back = {"key:escape", "button:b"},

        ui_down = {"key:down", "button:dpdown", "axis:lefty+"},
        ui_up = {"key:up", "button:dpup", "axis:lefty-"},
        ui_left = {"key:left", "button:dpleft", "axis:leftx-"},
        ui_right = {"key:right", "button:dpright", "axis:leftx+"},
    },
}

local ClientPrefs = {}

ClientPrefs.defaultData = SaveVariables
ClientPrefs.data = ClientPrefs.defaultData

function ClientPrefs:resetKeybinds()
    self.data.controls = SaveVariables.controls
end

function ClientPrefs:saveSettings()
    love.filesystem.write("settings.json", json.encode(self.data))
end

function ClientPrefs:loadPrefs()
    if love.filesystem.getInfo("settings.json") then
        self.data = json.decode(love.filesystem.read("settings.json"))
    else
        self.data = SaveVariables
        self:saveSettings()
    end

    input:rebindControl("note_left", self.data.controls.note_left)
    input:rebindControl("note_right", self.data.controls.note_right)
    input:rebindControl("note_up", self.data.controls.note_up)
    input:rebindControl("note_down", self.data.controls.note_down)

    input:rebindControl("accept", self.data.controls.accept)
    input:rebindControl("back", self.data.controls.back)

    input:rebindControl("ui_down", self.data.controls.ui_down)
    input:rebindControl("ui_up", self.data.controls.ui_up)
    input:rebindControl("ui_left", self.data.controls.ui_left)
    input:rebindControl("ui_right", self.data.controls.ui_right)
end

return ClientPrefs