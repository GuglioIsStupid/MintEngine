local LuaUtils = {}

function LuaUtils.getVarInArray(instance, variable)
    local splitProps = variable:split("[")
    if #splitProps > 1 then
        local target = nil
        if PlayState.variables[splitProps[1]] then
            local retVal = PlayState.variables[splitProps[1]]
            if retVal then target = retVal end
        else
            target = instance[splitProps[1]]
        end
        for i = 1, #splitProps do
            local j = splitProps[i]:sub(1, #splitProps[i])
            target = target[j]
        end
        return target
    end
end

function LuaUtils.getTargetInstance()
    return PlayState.isDead and GameOverSubstate or PlayState
end

function LuaUtils.getObjectDirectly(objectName, checkForTextsToo)
    local checkForTextsToo = (checkForTextsToo == nil) and true or checkForTextsToo

    if objectName == "this" or objectName == "instance" or objectName == "game" then
        return PlayState
    else
        local obj = PlayState:getLuaObject(objectName, checkForTextsToo)
        if not obj then obj = LuaUtils.getVarInArray(self.getTargetInstance(), objectName) end
        return obj
    end
end

function LuaUtils.getPropertyLoop(killMe, checkForTextsToo, getProperty)
    local checkForTextsToo = (checkForTextsToo == nil) and true or checkForTextsToo
    local getProperty = (getProperty == nil) and true or getProperty
    local end_ = #killMe - 1
    if getProperty then end_ = #killMe end

    for i = 1, end_ do
        obj = LuaUtils.getVarInArray(obj, killMe[i])
    end
    return obj
end

function LuaUtils.loadFrames(spr, image, spriteType)
    local spriteType = spriteType:lower()

    if spriteType == "texture" or spriteType == "textureatlas" or spriteType == "tex" then
    elseif spriteType == "texture_noaa" or spriteType == "textureatlas_noaa" or spriteType == "tex_noaa" then
    elseif spriteType == "packer" or spriteType == "packeratlas" or spriteType == "pac" then
        spr:setFrames(Paths.getPackerAtlas(image, image))
    else
        spr:setFrames(Paths.getSparrowAtlas(image, image))
    end
end

function LuaUtils.resetSpriteTag(tag)
    if not PlayState.modchartSprites[tag] then return end

    local target = PlayState.modchartSprites[tag]
    target:kill()
    PlayState:remove(target)
    target:destroy()
    table.remove(PlayState.modchartSprites, tag)
end

return LuaUtils