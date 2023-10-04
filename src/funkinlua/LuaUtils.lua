local LuaUtils = {}

function LuaUtils.getVarInArray(instance, variable)
    local splitProps = variable:split("[")
    if #splitProps > 1 then
        local target = nil
        if PlayState.variables and PlayState.variables[splitProps[1]] then
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

function LuaUtils.setVarInArray(instance, variable, value)
    local splitProps = variable:split("[")
    if #splitProps > 1 then
        local target = nil
        if PlayState.variables and PlayState.variables[splitProps[1]] then
            local retVal = PlayState.variables[splitProps[1]]
            if retVal then target = retVal end
        else
            target = instance[splitProps[1]]
        end
        for i = 1, #splitProps - 1 do
            local j = splitProps[i]:sub(1, #splitProps[i])
            target = target[j]
        end
        target[splitProps[#splitProps]] = value

        return target
    end

    if PlayState.variables[variable] then
        PlayState.variables[variable] = value
        return true
    end

    instance[variable] = value
    return true
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
        if not obj then obj = LuaUtils.getVarInArray(LuaUtils.getTargetInstance(), objectName) end
        if not obj then obj = PlayState[objectName] end
        return obj
    end
end

function LuaUtils.getPropertyLoop(killMe, checkForTextsToo, getProperty)
    local checkForTextsToo = (checkForTextsToo == nil) and true or checkForTextsToo
    local getProperty = (getProperty == nil) and true or getProperty
    local end_ = #killMe - 1
    if getProperty then end_ = #killMe end

    local obj = LuaUtils.getObjectDirectly(killMe[1], checkForTextsToo)
    for i = 2, end_ do
        local j = killMe[i]:sub(1, #killMe[i])
        obj = obj[j]
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
    PlayState.modchartSprites[tag] = nil
end

function LuaUtils.tweenPrepare(tag, vars)
    if tag then Timer.cancel(tag) end
    local variables = vars:split(".")
    local sexyProp = LuaUtils.getObjectDirectly(variables[1])
    if #variables > 1 then
        sexyProp = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(variables), variables[#variables])
    end
    return sexyProp
end

return LuaUtils