--[[
    typedef Letter = {
	?anim:Null<String>,
	?offsets:Array<Float>,
	?offsetsBold:Array<Float>
}
]]

local AlphaCharacter = Sprite:extend()
AlphaCharacter.image = ""
AlphaCharacter.parent = nil
AlphaCharacter.alignOffset = 0
AlphaCharacter.letterOffset = {0, 0}
AlphaCharacter.row = 0
AlphaCharacter.rowWidth = 0
AlphaCharacter.character = "?"
AlphaCharacter.bold = false
AlphaCharacter.curLetter = nil

--[[ AlphaCharacter.allLetters = { -- decided it would be better if I just check if the entry exists in the table
    a = nil, b = nil, c = nil, d = nil, e = nil, f = nil,
    g = nil, h = nil, i = nil, j = nil, k = nil, l = nil,
    m = nil, n = nil, o = nil, p = nil, q = nil, r = nil,
    s = nil, t = nil, u = nil, v = nil, w = nil, x = nil,
    y = nil, z = nil,
    ["á"] = nil, ["é"] = nil, ["í"] = nil, ["ó"] = nil
} ]]

AlphaCharacter.allLetters = {
    ["ç"] = {offsetsBold = {0, -11}},
    ["&"] = {offsetsBold = {0, 2}},
    ["]"] = {offsets = {0, -1}},
    ["*"] = {offsets = {0, 28}, offsetsBold = {0, 40}},
    ["+"] = {offsets = {0, 7}, offsetsBold = {0, 12}},
    ['-'] = {offsets = {0, 16}, offsetsBold = {0, 16}},
    ['<'] = {offsetsBold = {0, -2}},
    ['>'] = {offsetsBold = {0, -2}},
    ['\''] = {anim = 'apostrophe', offsets = {0, 32}, offsetsBold = {0, 40}},
    ['"'] = {anim = 'quote', offsets = {0, 32}, offsetsBold = {0, 40}},
    ['!'] = {anim = 'exclamation'},
    ['?'] = {anim = 'question'}, -- also used for "unknown"
    ['.'] = {anim = 'period'},
    ['❝'] = {anim = 'start quote', offsets = {0, 24}, offsetsBold = {0, 40}},
    ['❞'] = {anim = 'end quote', offsets = {0, 24}, offsetsBold = {0, 40}},
    [':'] = {offsets = {0, 2}, offsetsBold = {0, 8}},
    [';'] = {offsets = {0, -2}, offsetsBold = {0, 4}},
    ['^'] = {offsets = {0, 28}, offsetsBold = {0, 38}},
    [','] = {anim = 'comma', offsets = {0, -6}, offsetsBold = {0, -4}},
    ['\\'] = {anim = 'back slash', offsets = {0, 0}},
    ['/'] = {anim = 'forward slash', offsets = {0, 0}},
    ['~'] = {offsets = {0, 16}, offsetsBold = {0, 20}},
    ['¡'] = {anim = 'inverted exclamation', offsets = {0, -20}, offsetsBold = {0, -20}},
    ['¿'] = {anim = 'inverted question', offsets = {0, -20}, offsetsBold = {0, -20}},
    ['•'] = {anim = 'bullet', offsets = {0, 18}, offsetsBold = {0, 20}},
}

function AlphaCharacter:new(x, y)
    self.super.new(self, x, y)
    self:setFrames(Paths.getAtlas("alphabet", "assets/images/png/alphabet"))
end

function AlphaCharacter:setupAlphaCharacter(x, y, character, bold)
    self.x = x or 0
    self.y = y or 0

    if self.parent then
        if not bold then
            bold = self.parent.bold
        end
        self.scale.x = self.parent.scale.x
        self.scale.y = self.parent.scale.y
    end

    if character then
        self.character = character
        self.curLetter = nil
        local lowercase = self.character:lower()
        if AlphaCharacter.allLetters[lowercase] then
            self.curLetter = AlphaCharacter.allLetters[lowercase]
        end

        local suffix = ""
        if not bold then
            if (self:isTypeAlphabet(lowercase)) then
                if lowerCase ~= self.character then
                    suffix = " uppercase" 
                else
                    suffix = " lowercase"
                end
            else
                suffix = " normal"
            end
        else
            suffix = " bold"
        end

        local alphaAnim = lowercase
        if self.curLetter and self.curLetter.anim then alphaAnim = self.curLetter.anim end

        local anim = alphaAnim .. suffix
        self:addByPrefix(anim, anim, 24)
        self:play(anim, true)
        if not self.curAnim then
            if not suffix:find("bold") then suffix = " normal" end
            anim = "question" .. suffix
            self:addByPrefix(anim, anim, 24)
            self:play(anim, true)
        end
    end

    self:updateHitbox()
end

function AlphaCharacter:isTypeAlphabet(c)
    return c:find("[a-záéíóú]")
end

function AlphaCharacter:updateLetterOffset()
    if not self.curAnim then
        return
    end

    local add = 110
    if self.curAnim.name:endsWith("bold") then
        if self.curLetter and self.curLetter.offsetsBold then
            self.letterOffset[1] = self.curLetter.offsetsBold[1]
            self.letterOffset[2] = self.curLetter.offsetsBold[2]
        end
        add = 70
    else
        if self.curLetter and self.curLetter.offsets then
            self.letterOffset[1] = self.curLetter.offsets[1]
            self.letterOffset[2] = self.curLetter.offsets[2]
        end
        add = add * self.scale.y
        self.offset.x = self.offset.x + self.letterOffset[1] * self.scale.x
        self.offset.y = self.offset.y + self.letterOffset[2] * self.scale.y - (add - self.height)
    end
end

function AlphaCharacter:updateHitbox()
    self.super.updateHitbox(self)
    self:updateLetterOffset()
end

return AlphaCharacter