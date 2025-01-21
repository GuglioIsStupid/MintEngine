local SpriteGroup = Sprite:extend()

function SpriteGroup:new(x, y, maxSize)
    self:initGroup(maxSize)
    Sprite.new(self, x, y)
end

function SpriteGroup:initGroup(maxSize)
    self.group = Group(maxSize)
end

function SpriteGroup:destroy()
    self.group:destroy()
    Sprite.destroy(self)
end

function SpriteGroup:clone()
    local newGroup = SpriteGroup(self.x, self.y, self.group.maxSize)
    for _, sprite in ipairs(self.group.members) do
        if sprite ~= nil then
            newGroup:add(sprite:clone())
        end
    end
    return newGroup
end

function SpriteGroup:isOnScreen(camera)
    for _, sprite in ipairs(self.group.members) do
        if sprite ~= nil and sprite.exists and sprite.visible and sprite:isOnScreen(camera) then
            return true
        end
    end
    return false
end

function SpriteGroup:overlapsPoint(point, InScreenSpace, Camera)
    local result = false
    for _, sprite in ipairs(self.group.members) do
        if sprite ~= nil and sprite.exists and sprite.visible then
            result = result or sprite:overlapsPoint(point, InScreenSpace, Camera)
        end
    end
    return result
end

--[[
{
		var result:Bool = false;
		for (sprite in group.members)
		{
			if (sprite != null && sprite.exists && sprite.visible)
			{
				result = result || sprite.pixelsOverlapPoint(point, Mask, Camera);
			}
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		group.update(elapsed);

		if (path != null && path.active)
			path.update(elapsed);

		if (moves)
			updateMotion(elapsed);
	}]]

function SpriteGroup:update(dt)
    self.group:update(dt)
    
    if self.path and self.path.active then
        self.path:update(dt)
    end

    --[[ if self.moves then
        self:updateMotion(dt)
    end ]]
end

function SpriteGroup:draw()
    self.group:draw()
end

function SpriteGroup:add(sprite)
    self:preAdd(sprite)
    return self.group:add(sprite)
end

function SpriteGroup:insert(pos, sprite)
    self:preAdd(Sprite)
    return self.group:insert(pos, sprite)
end

function SpriteGroup:preAdd(sprite)
    sprite.x = sprite.x + self.x
    sprite.y = sprite.y + self.y 
    sprite.alpha = sprite.alpha * self.alpha
    sprite.scrollFactor = table.copy(self.scrollFactor or {})
    sprite.cameras = table.copy(self.cameras or {})
end

function SpriteGroup:recycle(spriteClass, factory, force)
    return self.group:recycle(spriteClass, factory, force)
end

function SpriteGroup:remove(sprite, splice)
    sprite.x = sprite.x - self.x
    sprite.y = sprite.y - self.y
    sprite.cameras = {}
    return self.group:remove(sprite, splice)
end

function SpriteGroup:replace(old, new)
    self:preAdd(new)
    return self.group:replace(old, new)
end

function SpriteGroup:sort(func, order)
    return self.group:sort(func, order)
end

function Sprite:refresh()
    return self.group:refresh()
end

return SpriteGroup