local SpriteGroup = Group:extend()
SpriteGroup.x = 0
SpriteGroup.y = 0
SpriteGroup.scale = {x = 1, y = 1}
SpriteGroup.angle = 0
SpriteGroup.alpha = 1
SpriteGroup.width, SpriteGroup.height = 0, 0

function SpriteGroup:getWidth()
    if #self.members < 1 then
        return 0
    end

    local minX, maxX = 0, 0
    for i, member in ipairs(self.members) do
        if member then
            local minX2 = member.x or 0
            local maxX2 = member.x or 0 + member.width or 0

            if minX2 < minX then
                minX = minX2
            end
            if maxX2 > maxX then
                maxX = maxX2
            end
        end
    end
    return maxX - minX
end

function SpriteGroup:getHeight()
    if not #self.members > 0 then
        return 0
    end

    local minY, maxY = 0, 0
    for i, member in ipairs(self.members) do
        if member then
            local minY2 = member.y or 0
            local maxY2 = member.y or 0 + member.height or 0

            if minY2 < minY then
                minY = minY2
            end
            if maxY2 > maxY then
                maxY = maxY2
            end
        end
    end
    return maxY - minY
end

function SpriteGroup:screenCenter(axis)
    local axies = axis or "XY"

    if axies == "XY" then
        self.x = push:getWidth() / 2 - self.width / 2
        self.y = push:getHeight() / 2 - self.height / 2
    elseif axies == "X" then
        self.x = push:getWidth() / 2 - self.width / 2
    elseif axies == "Y" then
        self.y = push:getHeight() / 2 - self.height / 2
    end
end

function SpriteGroup:draw()
    love.graphics.push()
    love.graphics.translate(push:getWidth() / 2, push:getHeight() / 2)
    love.graphics.rotate(math.rad(self.angle))
    love.graphics.translate(-push:getWidth() / 2, -push:getHeight() / 2)
    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scale.x, self.scale.y)
    for _, member in ipairs(self.members) do
        member.alpha = self.alpha
        member:draw()
    end
    love.graphics.pop()
end

return SpriteGroup