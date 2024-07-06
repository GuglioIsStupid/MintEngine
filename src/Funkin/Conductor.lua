--- FNF Conductor class
---@class Conductor
---@field private prevTimestamp number 
Conductor = {}
--[[
    onBeatHit is called every quarter note
    onStepHit is called every sixteenth note
    4/4 = 4 beats per measure = 16 steps per measure
        120 BPM = 120 quarter notes per minute = 2 onBeatHit per second
        120 BPM = 480 sixteenth notes per minute = 8 onStepHit per second
        60 BPM = 60 quarter notes per minute = 1 onBeatHit per second
        60 BPM = 240 sixteenth notes per minute = 4 onStepHit per second
    3/4 = 3 beats per measure = 12 steps per measure
        (IDENTICAL TO 4/4 but shorter measure length)
        120 BPM = 120 quarter notes per minute = 2 onBeatHit per second
        120 BPM = 480 sixteenth notes per minute = 8 onStepHit per second
        60 BPM = 60 quarter notes per minute = 1 onBeatHit per second
        60 BPM = 240 sixteenth notes per minute = 4 onStepHit per second
    7/8 = 3.5 beats per measure = 14 steps per measure
]]

Conductor.measureHit = Signal()   ---@type Signal
Conductor.onMeasureHit = Signal() ---@type Signal
Conductor.beatHit = Signal()      ---@type Signal
Conductor.onBeatHit = Signal()    ---@type Signal
Conductor.stepHit = Signal()      ---@type Signal
Conductor.onStepHit = Signal()    ---@type Signal

---@type table<SongTimeChange>
Conductor.timeChanges = {}

---@type (SongTimeChange | nil)
Conductor.currentTimeChange = nil

---@type float
Conductor.songPosition = 0

---@type float
---@private
Conductor.prevTimestamp = 0

---@type float
---@private
Conductor.prevTime = 0

---@type float
Conductor.bpm = 0

---@return float
function Conductor.get_bpm()
    if Conductor.bpmOverride ~= nil then return Conductor.bpmOverride end

    if Conductor.currentTimeChange ~= nil then return Constants.DEFAULT_BPM end

    return Conductor.bpm
end

---@type float
Conductor.startingBPM = 0

---@return float
function Conductor.get_startingBPM()
    if Conductor.bpmOverride ~= nil then return Conductor.bpmOverride end

    local timechange = Conductor.timeChanges[1]
    if timechange == nil then return Constants.DEFAULT_BPM end

    return timechange.bpm
end

---@type (float | nil)
Conductor.bpmOverride = nil

return Conductor