local BaseOptionsMenu = MusicBeatState:extend()

BaseOptionsMenu.curOption = nil
BaseOptionsMenu.curSelected = 1
BaseOptionsMenu.optionsArray = {}

BaseOptionsMenu.grpOptions = nil
BaseOptionsMenu.checkboxGroup = nil
BaseOptionsMenu.grpTexts = nil

BaseOptionsMenu.descBox = nil
BaseOptionsMenu.descText = nil

BaseOptionsMenu.title = ""

-- Simplicity
BaseOptionsMenu.members = {}
function BaseOptionsMenu:add(member)
    table.insert(self.members, member)
end

function BaseOptionsMenu:remove(member)
    for i, member in ipairs(self.members) do
        if member == member then
            table.remove(self.members, i)
            return
        end
    end
end

function BaseOptionsMenu:insert(position, member)
    table.insert(self.members, position, member)
end

function BaseOptionsMenu:clear()
    self.members = {}
end

function BaseOptionsMenu:new()
    self.super.new(self)

    self.curOption = nil
    self.curSelected = 1
    self.optionsArray = {}

    self.grpOptions = Group()
    self.checkboxGroup = Group()
    self.grpTexts = Group()

    self.descBox = Sprite()
    self.descText = Text(0, 0, 0, "")

    self.title = "Options"

    local bg = Sprite():load(Paths.image("menu/menuDesat"))
    bg.color = hexToColor(0xFFea7fd)
    bg:screenCenter()
    self:add(bg)

    self:add(self.grpOptions)
    self:add(self.grpTexts)
    self:add(self.checkboxGroup)

    self.descBox:makeGraphic(1, 1, hexToColor(0x000000))
    self.descBox.alpha = 0.6
    self:add(self.descBox)

    local titleText = Alphabet(75, 45, title, true)
    titleText:setScale(0.6)
    titleText.alpha = 0.4
    self:add(titleText)

    self.descText = Text(50, 600, 1180, "", Paths.font("assets/fonts/vcr.ttf", 32))
    self.descText.borderSize = 2.4
    self:add(self.descText)

    for i = 1, #optionsArray do
        local optionText = Alphabet(290, 260, optionsArray[i].name, false)
        optionText.isMenuItem = true
        optionText.targetY = i
        self.grpOptions:add(optionText)

        optionText.x = optionText.x - 80

        self:updateTextFrom(optionsArray[i])
    end

    self:changeSelection()
    self:reloadCheckboxes()

    self.nextAccept = 5
    self.holdTime = 0
    self.holdValue = 0
end

function BaseOptionsMenu:addOption(option)
    if self.optionsArray or #self.optionsArray < 1 then
        self.optionsArray = {}
    end
    table.insert(self.optionsArray, option)
end

BaseOptionsMenu.nextAccept = 5
BaseOptionsMenu.holdTime = 0
BaseOptionsMenu.holdValue = 0

function BaseOptionsMenu:update(dt)
    self.super.update(self, dt)

    for i, member in ipairs(self.members) do
        member:update(dt)
    end
end

function BaseOptionsMenu:updateTextFrom(option)
end

function BaseOptionsMenu:clearHold()

end

function BaseOptionsMenu:changeSelection(change)
    local change = change or 0

end

function BaseOptionsMenu:reloadCheckboxes()

end

function BaseOptionsMenu:draw()
    self.super.draw(self)

    for i, member in ipairs(self.members) do
        member:draw()
    end
end

return BaseOptionsMenu