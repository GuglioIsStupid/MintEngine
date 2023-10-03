local FlxBasePoint = Object:extend()

function FlxBasePoint:get(x, y)
    return FlxBasePoint:new(x or 0, y or 0)
end

function FlxBasePoint:set(x, y)
    self.x = x or 0
    self.y = y or 0
    return self
end

local FlxPoint = FlxBasePoint:extend()
FlxPoint.EPSILON = 0.0000001
FlxPoint.EPSILON_SQUARED = FlxPoint.EPSILON * FlxPoint.EPSILON

FlxPoint._point1 = FlxPoint:new()
FlxPoint._point2 = FlxPoint:new()
FlxPoint._point3 = FlxPoint:new()

function FlxPoint:get(x,y)
    return FlxBasePoint:get(x or 0, y or 0)
end

function FlxPoint:subtract(x, y)
    self.x = self.x - x
    self.y = self.y - y
    return self
end

function FlxPoint:floor()
    self.x = math.floor(self.x)
    self.y = math.floor(self.y)
    return self
end

function FlxPoint:new(x, y)
    self:set(x, y)
    return self
end

return FlxPoint