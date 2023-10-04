local AttachedSprite = Sprite:extend()

AttachedSprite.sprTracker = nil
AttachedSprite.xAdd = 0
AttachedSprite.yAdd = 0
AttachedSprite.angleAdd = 0
AttachedSprite.alphaMult = 1

AttachedSprite.copyAngle = true
AttachedSprite.copyAlpha = true
AttachedSprite.copyVisible = false

function AttachedSprite:new(file, anim, library, loop)
    self.super.new(self)
    if anim then
        self:setFrames(Paths.getAtlas(anim, library))
    elseif file then
        self:load(file)
    end
end

function AttachedSprite:update(dt)
    self.super.update(self, dt)

    if self.sprTracker then
        self.x, self.y = self.sprTracker.x + self.xAdd, self.sprTracker.y + self.yAdd
        self.scrollFactor = self.sprTracker.scrollFactor

        if self.copyAngle then
            self.angle = self.sprTracker.angle + self.angleAdd
        end

        if self.copyAlpha then
            self.alpha = self.sprTracker.alpha * self.alphaMult
        end

        if self.copyVisible then
            self.visible = self.sprTracker.visible
        end
    end
end

return AttachedSprite