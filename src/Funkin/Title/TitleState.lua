---@class TitleState : MusicBeatState
local TitleState = MusicBeatState:extend()

function TitleState:create()
    self.blackScreen = nil
    self.credGroup = Group()
    self.textGroup = Group()
    self.ngSpr = nil

    self.curWacky = {}
    self.lastBeat = 0
    self.overlay = nil

    MusicBeatState.create(self)

    self.logoBl = Sprite(-150, -100)
    self.logoBl:setFrames(Paths.getSparrowAtlas("logoBumpin"))
    self.logoBl:addAnimByPrefix("bump", "logo bumpin", 24, false)
    self.logoBl:play("bump")
	self.logoBl:updateHitbox()

    self:add(self.logoBl)
end

---@param dt number
function TitleState:update(dt)
    MusicBeatState.update(self, dt)
end

return TitleState