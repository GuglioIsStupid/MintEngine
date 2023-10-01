local PhillyGlowParticle = Sprite:extend()

PhillyGlowParticle.lifeTime = 0
PhillyGlowParticle.decay = 0
PhillyGlowParticle.originalScale = 1

function PhillyGlowParticle:new(x, y)
    self.lifeTime = 0
    self.decay = 0
    self.originalScale = 1

    self.super.new(self, x, y)

    self:load("stages/philly/particle")
    self.lifeTime = love.random.float(0.6, 0.9)
    self.decay = love.random.float(0.8, 1)
    self.originalScale = love.random.float(0.75, 1)
    self.scale.x, self.scale.y = self.originalScale, self.originalScale

    self.scrolFactor = {
        x = love.random.float(0.3, 0.75),
        y = love.random.float(0.65, 0.75)
    }
    self.velocity = {
        x = love.random.float(-40, 40),
        y = love.random.float(-175, 250)
    }
    self.acceleration = {
        x = love.random.float(-10, 10),
        y = 25
    }
end

function PhillyGlowParticle:update(dt) 
    self.lifeTime = self.lifeTime - dt
    if self.lifeTime < 0 then
        self.lifeTime = 0
        self.alpha = self.alpha - dt * self.decay
        if self.alpha > 0 then
            self.scale.x = self.originalScale * self.alpha
            self.scale.y = self.originalScale * self.alpha
        end
    end
    self.super.update(self, dt)
end

return PhillyGlowParticle