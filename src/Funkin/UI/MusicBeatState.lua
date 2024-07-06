---@class MusicBeatState : TransitionableState
local MusicBeatState = TransitionableState:extend()

function MusicBeatState:new()
    self.leftWatermarkText = nil
    self.rightWatermarkText = nil
    self.ConductorInUse = nil

    TransitionableState.new(self)

    --[[ self:initCallbacks() ]]
end

function MusicBeatState:create()
    TransitionableState.create(self)

    self:createWatermarkText()

    Conductor.beatHit:add(self.beatHit)
    Conductor.stepHit:add(self.stepHit)
end

function MusicBeatState:destroy()
    TransitionableState.destroy(self)

    Conductor.beatHit:remove(self.beatHit)
    Conductor.stepHit:remove(self.stepHit)
end

---@param dt number
function MusicBeatState:update(dt)
    TransitionableState.update(self, dt)
end

function MusicBeatState:createWatermarkText()
    -- TODO: Implement FlxText
end

function MusicBeatState:stepHit()

end

function MusicBeatState:beatHit()

end

return MusicBeatState