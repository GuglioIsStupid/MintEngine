local MenuCharacter = Sprite:extend()

--[[
-- reference
typedef MenuCharacterFile = {
	var image:String;
	var scale:Float;
	var position:Array<Int>;
	var idle_anim:String;
	var confirm_anim:String;
	var flipX:Bool;
}
]]

MenuCharacter.character = ""
MenuCharacter.DEFAULT_CHARACTER = "bf"

function MenuCharacter:new(x, character)
    local character = character or ""
    self.character = ""
    self.hasConfirmAnimation = false
    self.super.new(self, x, 0)
    
    self:changeCharacter(character)

    return self
end

function MenuCharacter:changeCharacter(character)
    local character = character or ""
    if character == self.character then return end

    self.character = character
    self.visible = true

    local dontPlayAnim = false
    self.scale = {x=1,y=1}
    self:updateHitbox()

    self.hasConfirmAnimation = false

    if character == "" then
        self.visible = false
        self.dontPlayAnim = true
    else
        local characterPath = "assets/menucharacters/" .. character .. ".json"
        local rawJson = nil

        if MODS_ALLOWED then
            local path = Paths.modFolders("images/menucharacters/" .. character .. ".json")
            if love.filesystem.getInfo(path) then
                rawJson = love.filesystem.read(path)
            elseif love.filesystem.getInfo(characterPath) then
                rawJson = love.filesystem.read(characterPath)
            else
                rawJson = love.filesystem.read("assets/menucharacters/" .. self.DEFAULT_CHARACTER .. ".json")
            end
        else
            if love.filesystem.getInfo(characterPath) then
                rawJson = love.filesystem.read(characterPath)
            else
                rawJson = love.filesystem.read("assets/menucharacters/" .. self.DEFAULT_CHARACTER .. ".json")
            end
        end

        local charFile = json.decode(rawJson)
        self.frames = {}
        self.animations = {}
        self:setFrames(Paths.getAtlas("menucharacters/" .. charFile.image, "menucharacters/" .. charFile.image .. ".xml"))
        self:addByPrefix("idle", charFile.idle_anim, 24)

        local confirmAnim = charFile.confirm_anim
        if confirmAnim and #confirmAnim > 0 and confirmAnim ~= charFile.idle_anim then
            self:addByPrefix("confirm", confirmAnim, 24)
            if self.animations["confirm"] and charFile.confirm_anim ~= "M Dad Idle" then -- literally why
                self.hasConfirmAnimation = true
            end
        end

        self.flipX = (charFile.flipX == true)

        if charFile.scale ~= 1 then
            self.scale.x = charFile.scale
            self.scale.y = charFile.scale
            self:updateHitbox()
        end

        self.offset = {x = charFile.position[1], y = charFile.position[2]}
        self:play("idle", true)
    end
end

return MenuCharacter