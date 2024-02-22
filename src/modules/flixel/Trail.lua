local Trail = Group:extend() -- I really need to get to porting sprite group...

--[[ Trail.target = nil
Trail.delay = 0
Trail.xEnabled = true
Trail.yEnabled = true
Trail.rotationsEnabled = true
Trail.scaledEnabled = true
Trail.framesEnabled = true

Trail._counter = 0
Trail._trailLength = 0

Trail._graphic = nil

Trail._transp = 1
Trail._difference = 0

Trail._recentPositions = {}
Trail._recentAngles = {}
Trail._recentScales = {}
Trail._recentFrames = {}
Trail._recentFlipX = {}
Trail._recentFlipY = {}
Trail._recentAnimations = {}

Trail._spriteOrigin = nil
 ]]
function Trail:new(target, graphic, length, delay, alpha, diff, camera, col)
    self.super.new(self)

    self._spriteOrigin = target.origin
    self.target = target
    self.delay = delay or 3
    self.graphic = graphic
    self._transp = alpha or 0.4
    self._difference = diff or 0.05
    self.camera = camera or target.camera
    self.colour = col or 0xFFFFFF

    self.xEnabled = true
    self.yEnabled = true
    self.rotationsEnabled = true
    self.scaledEnabled = true
    self.framesEnabled = true

    self._counter = 0
    self._trailLength = 0
    
    self._recentPositions = {}
    self._recentAngles = {}
    self._recentScales = {}
    self._recentFrames = {}
    self._recentFlipX = {}
    self._recentFlipY = {}
    self._recentAnimations = {}
    self._recentOffsets = {}

    self:increaseLength(length)
    self.solid = false
end

function Trail:destroy()
    self._recentAngles = nil
    self._recentPositions = nil
    self._recentScales = nil
    self._recentFrames = nil
    self._recentFlipX = nil
    self._recentFlipY = nil
    self._recentAnimations = nil
    self._spriteOrigin = nil
    self._recentOffsets = nil

    self.target = nil
    self._graphic = nil
end

function Trail:update(dt)
    self._counter = self._counter + 1

    if self._counter >= self.delay and self._trailLength >= 1 then
        self._counter = 0
        
        local spritePosition = {x=0,y=0}
        if #self._recentPositions == self._trailLength then
            spritePosition = table.remove(self._recentPositions, 1)
        else
            spritePosition = {x = self.target.x, y = self.target.y}
        end
        table.insert(self._recentPositions, 1, spritePosition)

        if self.rotationsEnabled then
            self:cacheValue(self._recentAngles, self.target.angle)
        end

        if self.scaledEnabled then
            local spriteScale = {x = 1, y = 1}
            if #self._recentScales == self._trailLength then
                spriteScale = table.remove(self._recentScales, 1)
            end

            spriteScale = {x = self.target.scale.x, y = self.target.scale.y}
            table.insert(self._recentScales, 1, spriteScale)
        end

        if self.framesEnabled then
            self:cacheValue(self._recentFrames, self.target.curFrame)
            self:cacheValue(self._recentFlipX, self.target.flipX)
            self:cacheValue(self._recentFlipY, self.target.flipY)
            self:cacheValue(self._recentAnimations, self.target.curAnim)
            self:cacheValue(self._recentOffsets, {x = self.target.offset.x, y = self.target.offset.y})
        end

        local trailSprite = nil

        for i = 1, #self._recentPositions do
            trailSprite = self.members[i]
            trailSprite.x = self._recentPositions[i].x
            trailSprite.y = self._recentPositions[i].y

            

            if self.rotationsEnabled then
                trailSprite.angle = self._recentAngles[i] 
                trailSprite.origin.x = self._spriteOrigin.x 
                trailSprite.origin.y = self._spriteOrigin.y 
            end

            if self.scaledEnabled then
                trailSprite.scale.x = self._recentScales[i].x 
                trailSprite.scale.y = self._recentScales[i].y 
            end

            if self.framesEnabled then
                trailSprite.curFrame = self._recentFrames[i]
                trailSprite.flipX = self._recentFlipX[i]
                trailSprite.flipY = self._recentFlipY[i]
                trailSprite.curAnim = self._recentAnimations[i]
                trailSprite.offset.x = self._recentOffsets[i].x
                trailSprite.offset.y = self._recentOffsets[i].y
            end

            trailSprite.exists = true
        end
    end

    self.super.update(self, dt)
end

function Trail:cacheValue(array, value)
    table.insert(array, value)
    if #array > self._trailLength then
        table.remove(array, 1)
    end
end

function Trail:resetTrail()
    -- splice all the tables
    self._recentPositions = table.splice(self._recentPositions, 1, #self._recentPositions)
    self._recentAngles = table.splice(self._recentAngles, 1, #self._recentAngles)
    self._recentScales = table.splice(self._recentScales, 1, #self._recentScales)
    self._recentFrames = table.splice(self._recentFrames, 1, #self._recentFrames)
    self._recentFlipX = table.splice(self._recentFlipX, 1, #self._recentFlipX)
    self._recentFlipY = table.splice(self._recentFlipY, 1, #self._recentFlipY)

    for i = 1, #self.members do
        if self.members[i] then
            self.members[i].exists = false
        end
    end
end

function Trail:increaseLength(amount)
    if amount <= 0 then
        return
    end

    self._trailLength = self._trailLength + amount

    for i = 1, self._trailLength do
        local trailSprite = Sprite(0, 0)

        trailSprite.exists = false
        trailSprite.active = false
        trailSprite:loadFromSprite(self.target)
        trailSprite.camera = PlayState.camGame
        self:add(trailSprite)
        trailSprite.alpha = self._transp
        self._transp = self._transp - self._difference
        trailSprite.color = hexToColor(self.colour or 0xFFFFFF)

        if trailSprite.alpha <= 0 then
            trailSprite:kill()
        end
    end
end

return Trail