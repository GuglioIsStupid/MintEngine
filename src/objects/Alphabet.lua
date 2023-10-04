AlphabetAlignment = {
    LEFT = 0,
    CENTERED = 1,
    RIGHT = 2
}

local Alphabet = SpriteGroup:extend()
local AlphaCharacter = require("objects.AlphaCharacter")

Alphabet.text = ""
Alphabet.bold = false
Alphabet.letters = {}

Alphabet.isMenuItem = false
Alphabet.targetY = 0
Alphabet.changeX = true
Alphabet.changeY = true

Alphabet.Alignment = AlphabetAlignment.LEFT
Alphabet.scaleX = 1
Alphabet.scaleY = 1
Alphabet.rows = 0

Alphabet.distancePerItem = Point(20, 120)
Alphabet.startPosition = Point(0, 0)

Alphabet.Y_PER_ROW = 85

Alphabet.width, Alphabet.height = 0, 0

function Alphabet:new(x, y, text, bold)
    self.super.new(self, x, y)
    local x = x or 0
    local y = y or 0
    local text = text or ""
    local bold = (bold == nil) and false or bold

    self.text = text
    self.bold = bold
    self.letters = {}
    self.isMenuItem = false
    self.targetY = 0
    self.changeX = true
    self.changeY = true
    self.Alignment = AlphabetAlignment.LEFT
    self.scaleX = 1
    self.scaleY = 1
    self.rows = 0
    self.distancePerItem = Point(20, 120)
    self.startPosition = Point(x, y)
    self.Y_PER_ROW = 85

    self:setText(text)
end

function Alphabet:setAlignmentFromString(align)
    local align = align:upper() or "LEFT"
    self.Alignment = AlphabetAlignment[align] or AlphabetAlignment.LEFT
end

function Alphabet:updateAlignment()
    for _, letter in ipairs(self.letters) do
        local newOffset = 0
        if self.Alignment == AlphabetAlignment.CENTERED then
            newOffset = letter.rowWidth / 2
        elseif self.Alignment == AlphabetAlignment.RIGHT then
            newOffset = letter.rowWidth
        else
            newOffset = 0
        end

        letter.offset.x = letter.offset.x - letter.alignOffset
        letter.alignOffset = newOffset * self.scale.x
        letter.offset.x = letter.offset.x + letter.alignOffset
    end
end

function Alphabet:setText(newText)
    local newText = newText:replace("\\n", "\n")
    self:clearLetters()
    self:createLetters(newText)
    self:updateAlignment()
    self.text = newText
end

function Alphabet:clearLetters()
    local i = #self.letters
    while i > 0 do
        local letter = self.letters[i]
        if letter then
            letter:kill()
            table.remove(self.letters, i)
            self:remove(letter)
        end
        i = i - 1
    end
    self.letters = {}
    self.rows = 0
end

function Alphabet:setScale(newX, newY)
    self.lastX = self.scale.x
    self.lastY = self.scale.y 
    local newY = newY or newX
    self.scaleX = newX
    self.scaleY = newY

    self.scale.x = newX
    self.scale.y = newY
    self:softReloadLetters(newX / self.lastX, newY / self.lastY)
end

function Alphabet:softReloadLetters(ratioX, ratioY)
    local ratioX = ratioX or 1
    local ratioY = ratioY or ratioX

    for _, letter in ipairs(self.letters) do
        if letter then
            letter:setupAlphaCharacter((letter.x - self.x) * ratioX + self.x, (letter.y - self.y) * ratioY + self.y)
        end
    end
end

function Alphabet:update(dt)
    if self.isMenuItem then
        local lerpVal = math.bound(dt * 9.6, 0, 1)
        if self.changeX then
            self.x = math.lerp(self.x, (self.targetY * self.distancePerItem.x) + self.startPosition.x, lerpVal)
        end
        if self.changeY then
            self.y = math.lerp(self.y, (self.targetY * 1.3 * self.distancePerItem.y) + self.startPosition.y, lerpVal)
        end
    end
    self.super.update(self, dt)
end

function Alphabet:snapToPosition()
    if self.isMenuItem then
        if self.changeX then
            self.x = (self.targetY * self.distancePerItem.x) + self.startPosition.x
        end
        if self.changeY then
            self.y = (self.targetY * 1.3 * self.distancePerItem.y) + self.startPosition.y
        end
    end
end

function Alphabet:createLetters(newText)
    local consecutiveSpaces = 0

    local xPos = 0
    local rowData = {}
    self.rows = 0

    for _, character in ipairs(newText:split("")) do
        if character ~= "\n" and character ~= "" then
            local spaceChar = (character == " " or (self.bold and character == "_"))
            if spaceChar then consecutiveSpaces = consecutiveSpaces + 1 end

            local isAlphabet = AlphaCharacter:isTypeAlphabet(character:lower()) and not spaceChar
            if (not spaceChar) then
                if consecutiveSpaces > 0 then
                    xPos = xPos + 28 * consecutiveSpaces * self.scale.x
                    if not self.bold and xPos >= push:getWidth() * 0.65 then
                        xPos = 0
                        self.rows = self.rows + 1
                    end
                end
                consecutiveSpaces = 0

                local letter = AlphaCharacter(xPos, self.rows * self.Y_PER_ROW)
                letter:setupAlphaCharacter(xPos, self.rows * self.Y_PER_ROW * self.scale.y, character, self.bold)
                letter.parent = self

                letter.row = self.rows
                local off = 0
                if not self.bold then off = 2 end
                xPos = xPos + letter.width + ((letter.letterOffset[0] or 0) + off) * self.scale.x
                rowData[self.rows] = xPos

                self:add(letter)
                table.insert(self.letters, letter)
                --print("Added letter " .. character .. " at " .. xPos .. ", " .. self.rows * self.Y_PER_ROW)
            end
        else
            xPos = 0
            self.rows = self.rows + 1
        end
    end 

    for _, letter in ipairs(self.letters) do
        letter.rowWidth = rowData[letter.row]
    end 

    if #self.letters > 0 then
        self.rows = self.rows + 1
    end

    self.width = xPos
    self.height = self.rows * self.Y_PER_ROW
end

return Alphabet