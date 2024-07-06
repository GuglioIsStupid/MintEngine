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
end

function TitleState:update(dt)
    MusicBeatState.update(self, dt)

    print("[TitleState] IN TITLE STATE")
end

return TitleState