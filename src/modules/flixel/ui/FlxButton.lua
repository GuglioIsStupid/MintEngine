-- https://github.com/HaxeFlixel/flixel/blob/master/flixel/ui/FlxButton.hx

local FlxTypedButton = Sprite:extend()

FlxTypedButton.label = nil
FlxTypedButton.labelOffsets = {Point(), Point(), Point(0, 1)}
FlxTypedButton.labelAlpha = {0.8, 1, 0.5}
FlxTypedButton.statusAnimations = {"normal", "highlighted", "pressed"}
FlxTypedButton.allowSkipping = true
FlxTypedButton.mouseButtons = {1}
FlxTypedButton.maxInputMovement = math.huge
FlxTypedButton.status = 0
FlxTypedButton.onUp = nil
FlxTypedButton.onDown = nil
FlxTypedButton.onOver = nil
FlxTypedButton.onOut = nil

FlxTypedButton.justReleased = false
FlxTypedButton.released = false
FlxTypedButton.pressed = false
FlxTypedButton.justPressed = false
FlxTypedButton._spriteLabel = nil
FlxTypedButton.lastStatus = -1

function FlxTypedButton:new(x, y, onClick)
    
end

function FlxTypedButton:graphicLoaded()
    self:setupAnimation("normal", 1)
    self:setupAnimation("highlight", 2)
    self:setupAnimation("pressed", 3)
end

function FlxTypedButton:loadDefaultGraphic()
    self:load("flixel/ui/button.png", true, 80, 20)
    self:graphicLoaded()
end

function FlxTypedButton:setupAnimation(animationName, frameIndex)
    local frameIndex = math.floor(math.min(frameIndex, #self.frames.frames))
    self:addAnimation(animationName, {frameIndex})
end

function FlxTypedButton:update(dt)
    self.super.update(self, dt)
end

FlxButton = Sprite:extend()
FlxButton.text = ""

function FlxButton:new(x, y, text, onClick)
    self.text = ""
    self.label = nil
    self.labelOffsets = {Point(), Point(), Point(0, 1)}
    self.labelAlpha = {0.8, 1, 0.5}
    self.statusAnimations = {"normal", "highlighted", "pressed"}
    self.allowSkipping = true
    self.mouseButtons = {1}
    self.maxInputMovement = math.huge
    self.status = 0
    self.onUp = nil
    self.onDown = nil
    self.onOver = nil
    self.onOut = nil

    self.justReleased = false
    self.released = false
    self.pressed = false
    self.justPressed = false
    self._spriteLabel = nil
    self.lastStatus = -1

    self.super.new(self, x, y)
    self:loadDefaultGraphic()
    --self.onUp = FlxButtonEvent(self.onClick)
    --self.onDown = FlxButtonEvent()
    --self.onOver = FlxButtonEvent()
    --self.onOut = FlxButtonEvent()

    self.status = 1
    self.scrollFactor = Point()

    for i, point in ipairs(self.labelOffsets) do
        point.y = point.y + 3
    end

    self:initLabel(text)
end

function FlxButton:graphicLoaded()
    self:setupAnimation("normal", 1)
    self:setupAnimation("highlight", 2)
    self:setupAnimation("pressed", 3)

    self:play("normal")
end

function FlxButton:loadDefaultGraphic()
    self:load("flixel/ui/button", true, 80, 20)
    self:graphicLoaded()
end

function FlxButton:setupAnimation(animationName, frameIndex)
    self:addByTiles(animationName, {frameIndex})
end

function FlxButton:update(dt)
    self.super.update(self, dt)
    local x, y
    if love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X" then
        x, y = push.toGame(love.mouse.getX(), love.mouse.getY())
    else
        -- get touch position
        x, y = push.toGame(love.touch.getPosition(1))
    end

    if x < self.x or x > self.x + self.width or y < self.y or y > self.y + self.height then
        return false
    end

    if self.status ~= 0 and x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
        self.status = 0
        self:play("normal")
        self.pressed = false
        self.justPressed = false
        self.released = false
        self.justReleased = false
    end

    if self.status ~= 2 and love.mouse.isDown(1) then
        self.status = 2
        self:play("pressed")
        self.pressed = true
        self.justPressed = true
        self.released = false
        self.justReleased = false
    end
end

function FlxButton:initLabel(text)
    if text then
        self.label = Text(self.x + self.labelOffsets[1].x, self.y + self.labelOffsets[1].y, 80, text, Paths.font("assets/fonts/vcr.ttf", 8))
        self.label.color = hexToColor(0x333333)
        self.label.alpha = self.labelAlpha[1]
        self.label.drawFrame = true
    end
end

return FlxButton