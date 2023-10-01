local HealthBar = Object:extend()

function HealthBar:new(x, y, img, minBound, maxBound, leftToRight, valueFunction)
    self.x = x or 0
    self.y = y or 0
    self.img = Paths.image(img)
    self.width = self.img:getWidth()
    self.height = self.img:getHeight()
    self.boundX = minBound or 0
    self.boundY = maxBound or 100
    self.scrollFactor = {x=0, y=0}
    self.leftToRight = leftToRight or false
    self.barLeftColor = hexToColor(0xFFFFFFFF)
    self.barRightColor = hexToColor(0x00000000)
    self.alpha = 1
    self.camera = self.camHUD
    self.valueFunction = valueFunction or function() 
        return 0.5
    end
    self.percent = 0
    self.barCenter = 1
end

function HealthBar:screenCenter(axis)
    local axis = axis or "XY"
    if axis:find("X") then
        self.x = (push:getWidth() / 2) - (self.img:getWidth() / 2)
    end
    if axis:find("Y") then
        self.y = (push:getHeight() / 2) - (self.img:getHeight() / 2)
    end
end

function HealthBar:draw()
    love.graphics.push()
        if self.camera then
            love.graphics.translate(push:getWidth()/2, push:getHeight()/2)
            love.graphics.scale(self.camera.zoom, self.camera.zoom)
            love.graphics.translate(-push:getWidth()/2, -push:getHeight()/2)
        end
        if self.leftToRight then
            self.percent = self.valueFunction() / self.boundY
        else
            self.percent = 1 - (self.valueFunction() / self.boundY)
        end
        -- use NORMAL rectangles from love.graphics
        love.graphics.setColor(self.barLeftColor[1] / 255, self.barLeftColor[2] / 255, self.barLeftColor[3] / 255, self.alpha)
        love.graphics.rectangle("fill", self.x + 3, self.y + 3, self.width - 6, self.height - 6)
        love.graphics.setColor(self.barRightColor[1] / 255, self.barRightColor[2] / 255, self.barRightColor[3] / 255, self.alpha)
        love.graphics.rectangle("fill", self.x + 3, self.y + 3, (self.width-6) * self.percent, self.height - 3)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.img, self.x, self.y)

        -- set self.barCenter to the percent rects position
        self.barCenter = self.x + (self.width * self.percent)
    love.graphics.pop()
end

return HealthBar