local CreditsState = MusicBeatState:extend()

CreditsState.curSelected = -1
CreditsState.grpOptions = nil
CreditsState.iconArray = {}
CreditsState.creditsStuff = {}

CreditsState.bg = nil
CreditsState.descText = nil
CreditsState.intendedColor = nil
CreditsState.colorTween = nil
CreditsState.descBox = nil

CreditsState.offsetThing = -75

CreditsState.quitting = false
CreditsState.holdTime = 0
CreditsState.colorTween = nil

-- Simplicity
CreditsState.members = {}
function CreditsState:add(member)
    table.insert(self.members, member)
end

function CreditsState:remove(member)
    for i, member in ipairs(self.members) do
        if member == member then
            table.remove(self.members, i)
            return
        end
    end
end

function CreditsState:insert(position, member)
    table.insert(self.members, position, member)
end

function CreditsState:clear()
    self.members = {}
end
--

function CreditsState:resetValues()
    self.curSelected = -1
    self.grpOptions = nil
    self.iconArray = {}
    self.creditsStuff = {}
    self.bg = nil
    self.descText = nil
    self.intendedColor = nil
    self.colorTween = nil
    self.descBox = nil
    self.offsetThing = -75
    self.members = {}
    self.quitting = false
    self.holdTime = 0
    self.colorTween = nil
end

function CreditsState:enter()
    self:resetValues()
    self.bg = Sprite():load("menu/menuDesat"):screenCenter()
    self:add(self.bg)

    self.grpOptions = Group()

    local defaultList = { 
        -- Name - Icon name - Description - Link - BG Color
        -- if Icon name is n/a, none will be loaded.
        {"Mint Engine Team"},
        {"GuglioIsStupid", "n/a", "Main Programmer of Mint Engine", "https://twitter.com/GuglioIsStupid", "#FF00FF"},
        {""},
        {"Special Thanks"},
        {"Shadow Mario", "shadowmario", "Main Programmer of Psych Engine", "https://twitter.com/Shadow_Mario_", "#444444"},
        {"Psych Engine Contributors", "n/a", "For helping with Psych Engine's development", "https://github.com/ShadowMario/FNF-PsychEngine/graphs/contributors", "#444444"},
        {"Funkin Crew", "n/a", "Making Friday Night Funkin'", "https://github.com/FunkinCrew/Funkin", "#00FF00"},
        {"HTV04", "n/a", "Making Funkin Rewritten, what inspired me to make my own engine", "https://twitter.com/HTV04_", "#9966ff"} -- purply colour
    }

    for i = 1, #defaultList do
        table.insert(self.creditsStuff, defaultList[i])
    end

    for i = 1, #self.creditsStuff do
        local isSelectable = not self:unselectableCheck(i)
        if isSelectable and not self.creditsStuff[i][2] then
            isSelectable = false
        end
        local optionText = Alphabet(push:getWidth()/2, 300, self.creditsStuff[i][1], not isSelectable)
        optionText.isMenuItem = true
        optionText.targetY = i
        optionText.changeX = false
        optionText:snapToPosition()
        self.grpOptions:add(optionText)

        if isSelectable then
            local str = "credits/missing_icon"
            if self.creditsStuff[i][2] and self.creditsStuff[i][2] ~= "n/a" then
                if Paths.image("credits/" .. self.creditsStuff[i][2]) then
                    str = "credits/" .. self.creditsStuff[i][2]
                end
                local icon = AttachedSprite(str)
                icon.xAdd = optionText:getWidth() + 50
                icon.sprTracker = optionText

                table.insert(self.iconArray, icon)
                self:add(icon)
            else
                local icon = AttachedSprite()
                icon.xAdd = optionText:getWidth() + 50
                icon.sprTracker = optionText

                table.insert(self.iconArray, icon)
                self:add(icon)
            end

            if self.curSelected == -1 then
                self.curSelected = i
            end
        else
            optionText.alignment = AlphabetAlignment.CENTERED
        end
    end
    self:add(self.grpOptions)

    self.descBox = AttachedSprite():makeGraphic(1, 1, 0xFFFFFF)
    self.descBox.xAdd = -10
    self.descBox.yAdd = -10
    self.descBox.alphaMult = 0.6
    self:add(self.descBox)

    self.descText = Text(50, push:getHeight() + self.offsetThing - 25, 1180, "", Paths.font("assets/fonts/vcr.ttf", 32))
    self.descText.borderSize = 0

    self.bg.color = hexToColor(self.creditsStuff[2][5] or 0xFFFFFF)
    self.intendedColor = self.bg.color
    self:changeSelection(1, true)

    MusicBeatState:fadeIn(0.3)
end

function CreditsState:update(dt)
    for _, member in ipairs(self.members) do
        if member.update then
            member:update(dt)
        end
    end
    if not self.quitting then
        if #self.creditsStuff > 1 then
            local shiftMult = 1
            if love.keyboard.isDown("lshift") then
                shiftMult = 3
            end

            local upP = input:pressed("ui_up")
            local downP = input:pressed("ui_down")

            if upP then
                self:changeSelection(-shiftMult)
                self.holdTime = 0
            end
            if downP then
                self:changeSelection(shiftMult)
                self.holdTime = 0
            end

            if input:down("ui_down") or input:down("ui_up") then
                local checkLastHold = math.floor((self.holdTime - 0.5) * 10)
                self.holdTime = self.holdTime + dt
                local checkNewHold = math.floor((self.holdTime - 0.5) * 10)

                if self.holdTime > 0.5 and checkNewHold - checkLastHold > 0 then
                    self:changeSelection((checkNewHold - checkLastHold) * (input:down("ui_down") and 1 or -1))
                end
            end

            if input:pressed("accept") and (self.creditsStuff[self.curSelected][4] and #self.creditsStuff[self.curSelected][3] > 4) then
                love.system.openURL(self.creditsStuff[self.curSelected][4] or "")
            end
        end
    end

    for _, item in ipairs(self.grpOptions.members) do
        if not item.bold then
            local lerpVal = math.bound(dt*12, 0, 1)
            if item.targetY == 0 then
                local lastX = item.x
                item:screenCenter("X")
                item.x = math.lerp(lastX, item.x-70, lerpVal)
            else
                item.x = math.lerp(item.x, 200 + -40 * math.abs(item.targetY), lerpVal)
            end
        end
    end

    self.descText.y = math.lerp(self.descText.y, push:getHeight() + self.offsetThing, math.bound(dt*12, 0, 1))
end

function CreditsState:changeSelection(change, onOpen)
    local change = change or 1
    Sound.play(Paths.sound("assets/sounds/scrollMenu.ogg"))
    self.curSelected = self.curSelected + change

    if self.curSelected > #self.creditsStuff then
        self.curSelected = 1
    elseif self.curSelected < 1 then
        self.curSelected = #self.creditsStuff
    end

    -- while current is unselectable, keep going
    while self:unselectableCheck(self.curSelected) do
        self.curSelected = self.curSelected + change

        if self.curSelected > #self.creditsStuff then
            self.curSelected = 1
        elseif self.curSelected < 1 then
            self.curSelected = #self.creditsStuff
        end
    end
    self.curSelected = not onOpen and self.curSelected or 1

    local newColor = hexToColor(self.creditsStuff[self.curSelected][5] or 0xFFFFFF)
    if newColor ~= self.intendedColor then
        if self.colorTween then
            Timer.cancel(self.colorTween)
        end
        self.intendedColor = newColor
        self.colorTween = Timer.tween(1, self.bg, {color = newColor}, "linear", function()
            self.colorTween = nil
        end)
    end
    local bullshit = 0

    for _, item in ipairs(self.grpOptions.members) do
        bullshit = bullshit + 1
        item.targetY = bullshit - self.curSelected

        if not self:unselectableCheck(bullshit) then
            item.alpha = 0.6
            if item.targetY == 0 then
                item.alpha = 1
            end
        end
    end

    self.descText.text = self.creditsStuff[self.curSelected][2]
    self.descText.y = push:getHeight() - self.descText.height + self.offsetThing - 60

    if self.moveTween then
        Timer.cancel(self.moveTween)
    end
    self.moveTween = Timer.tween(0.25, self.descText, {y = self.descText.y + 75}, "out-sine", function()
        self.moveTween = nil
    end)

    self.descBox:setGraphicSize(math.floor(self.descText.width+50), math.floor(self.descText.height+25))
    self.descBox:updateHitbox()
end

function CreditsState:unselectableCheck(index)
    return #self.creditsStuff[index][1] <= 1
end

function CreditsState:draw()
    for _, member in ipairs(self.members) do
        if member.draw then
            member:draw()
        end
    end
end

return CreditsState