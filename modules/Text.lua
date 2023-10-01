local Text = Object:extend()
Text.alignment = "center"
Text.borderColor = hexToColor(0x000000)
Text.borderSize = 1
Text.font = nil
Text.text = " " -- cant be empty
Text.color = hexToColor(0xFFFFFFFF)
Text.alpha = 1
Text.camera = nil
Text.visible = true
Text.exists = true
Text.blend = "alpha"
Text.x = 0
Text.y = 0
Text.scrollFactor = {x=1,y=1}
Text.limit = 0
Text.fullText = ""
Text.scale = {x=1,y=1}
Text.camera = nil

function Text:new(x, y, limit, text, font)
    local x = x or 0
    local y = y or 0
    local limit = limit or 0
    local text = text or " "
    self.alignment = "center"
    self.borderColor = hexToColor(0x000000)
    self.font = font
    self.text = text
    self.fullText = text -- for dialogue
    self.color = hexToColor(0xFFFFFFFF)
    self.alpha = 1
    self.camera = nil
    self.visible = true
    self.exists = true
    self.blend = "alpha"
    self.x = x
    self.y = y
    self.limit = limit
    self.scale = {x=1,y=1}
    self.angle = 0
    self.camera = nil

    if not self.font then
        self.font = love.graphics.newFont(12)
    end

    self.scrollFactor = {x=1,y=1}

    self.borderSize = 1

    return self
end

function Text:screenCenter(axis)
    local axies = axis or "XY"

    if axis:find("X") then
        self.x = (push.getWidth() - self.font:getWidth(self.text)) / 2
    end
    if axis:find("Y") then
        self.y = (push.getHeight() - self.font:getHeight(self.text)) / 2
    end
end

function Text:draw()
    love.graphics.push()
        if self.exists and self.visible and self.text ~= "" and self.alpha > 0 then
            if self.camera then
                love.graphics.translate(push:getWidth()/2, push:getHeight()/2)
                love.graphics.scale(self.camera.zoom, self.camera.zoom)
                love.graphics.translate(-push:getWidth()/2, -push:getHeight()/2)
            end
            local _currentFont = love.graphics.getFont()
            local _currentColor = {love.graphics.getColor()}

            if self.shader then
                love.graphics.setShader(self.shader)
            end
            love.graphics.setBlendMode(self.blend)

            love.graphics.setFont(self.font)
            love.graphics.setColor(self.borderColor[1], self.borderColor[2], self.borderColor[3], self.alpha)

            love.graphics.push()
            love.graphics.translate(-(self.font:getWidth(self.text) * (self.scale.x - 1)), -(self.font:getHeight(self.text) * (self.scale.y - 1)))
                if self.borderSize > 0 then
                    for dx = -self.borderSize, self.borderSize do
                        for dy = -self.borderSize, self.borderSize do
                            if dx ~= 0 or dy ~= 0 then
                                -- if limit is 0, use the fonts width
                                if self.limit == 0 then
                                    love.graphics.printf(self.text, self.x + dx, self.y + dy, self.font:getWidth(self.text), self.alignment, self.angle, self.scale.x, self.scale.y)
                                else
                                    love.graphics.printf(self.text, self.x + dx, self.y + dy, self.limit, self.alignment, self.angle, self.scale.x, self.scale.y)
                                end
                            end
                        end
                    end
                end
            love.graphics.pop()

            love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
            love.graphics.push()
                -- translate based off scale so its always in the same spot
                love.graphics.translate(-(self.font:getWidth(self.text) * (self.scale.x - 1)), -(self.font:getHeight(self.text) * (self.scale.y - 1)))
                if self.limit == 0 then
                    love.graphics.printf(self.text, self.x, self.y, self.font:getWidth(self.text), self.alignment, self.angle, self.scale.x, self.scale.y)
                else
                    love.graphics.printf(self.text, self.x, self.y, self.limit, self.alignment, self.angle, self.scale.x, self.scale.y)
                end
            love.graphics.pop()

            love.graphics.setFont(_currentFont)
            love.graphics.setColor(_currentColor)


            love.graphics.setBlendMode("alpha")
            if self.shader then
                love.graphics.setShader()
            end
        end
    love.graphics.pop()
end

return Text