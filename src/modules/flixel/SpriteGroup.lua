local SpriteGroup = Group:extend()
SpriteGroup.x = 0
SpriteGroup.y = 0
SpriteGroup.scale = {x = 1, y = 1}
SpriteGroup.angle = 0
SpriteGroup.alpha = 1

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