local ModchartSprite = Sprite:extend()

ModchartSprite.animOffsets = {}

function ModchartSprite:new(x, y)
    self.animOffsets = {}
    self.super.new(self, x, y)
end

function ModchartSprite:playAnim(name, forced, reverse, startFrame)
    self:play(name, forced, reverse, startFrame)

    local daOffset = self.animOffsets[name]
    if daOffset then
        self.offset.x = daOffset[1]
        self.offset.y = daOffset[2]
    else
        self.offset.x = 0
        self.offset.y = 0
    end
end

function ModchartSprite:addOffset(name, x, y)
    self.animOffsets[name] = {x, y}
end

return ModchartSprite