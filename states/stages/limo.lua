local Stage = BaseStage:extend()

local BackgroundDancer = require "states.stages.objects.BackgroundDancer"

Stage.grpLimoDancers = Group()
Stage.fastCar = nil
Stage.fastCarCanDrive = true

function Stage:create()
    local bg = BGSprite("stages/limo/limoSunset", -120, -50, 0.1, 0.1)
    self:add(bg)

    local bgLimo = BGSprite("stages/limo/bgLimo", -150, 480, 0.4, 0.4, {"background limo pink"}, true)
    self:add(bgLimo)

    self.grpLimoDancers = Group()
    self:add(self.grpLimoDancers)

    for i = 0, 3 do
        local dancer = BackgroundDancer((370 * i) + 320 + bgLimo.x, bgLimo.y - 400)
        dancer.scrollFactor = {x = 0.4, y = 0.4}
        dancer.camera = PlayState.camGame
        self.grpLimoDancers:add(dancer)
    end

    self.fastCar = BGSprite("stages/limo/fastCarLol", -300, 160)
    self.fastCar.active = true
end

function Stage:createPost()
    self:resetFastCar()
    self:addBehindGF(self.fastCar)

    local limo = BGSprite("stages/limo/limoDrive", -120, 550, 1, 1, {"Limo stage"}, true)
    self:addBehindBF(limo)
end

function Stage:beatHit()
    for i, dancer in ipairs(self.grpLimoDancers.members) do
        dancer.danceDir = not dancer.danceDir
        dancer:dance()
    end

    if love.math.random(10) == 1 then
        self:fastCarDrive()
    end
end

function Stage:resetFastCar()
    self.fastCar.x = -12600
    self.fastCar.y = love.math.random(140, 250)
    self.fastCar.velocity.x = 0
    self.fastCarCanDrive = true
end

function Stage:fastCarDrive()
    Sound.play(Paths.sound("assets/sounds/week4/carPass" .. love.math.random(0, 1) .. ".ogg"))

    self.fastCar.velocity.x = (love.math.random(170, 220) / love.timer.getDelta()) * 3
    self.fastCarCanDrive = false
    if self.carTimer then
        Timer.cancel(self.carTimer)
    end
    self.carTimer = Timer.after(2, function()
        self:resetFastCar()
        self.carTimer = nil
    end)
end

return Stage