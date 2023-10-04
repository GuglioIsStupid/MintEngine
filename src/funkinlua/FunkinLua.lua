local FunkinLua = Object:extend()
local chunkMeta = {__index = _G}

local Function_Stop = "##PSYCHLUA_FUNCTIONSTOP"
local Function_Continue = "##PSYCHLUA_FUNCTIONCONTINUE"
local Function_StopLua = "##PSYCHLUA_FUNCTIONSTOPLUA"
FunkinLua.Function_Stop = Function_Stop
FunkinLua.Function_Continue = Function_Continue
FunkinLua.Function_StopLua = Function_StopLua

FunkinLua.vars = {}
FunkinLua.camTarget = nil
FunkinLua.scriptName = ""
FunkinLua.closed = false

function FunkinLua:set(var, value)
    -- set the chunk's variable
    self.vars[var] = value
end

function FunkinLua:new(scriptName)
    TryExcept(
        function()
            chunk = love.filesystem.load(scriptName)
            print("Loaded script " .. scriptName)
        end,
        function(e)
            print("Error loading script " .. scriptName .. ": " .. e)
            return
        end
    )
    setfenv(chunk, setmetatable(FunkinLua.vars, chunkMeta))
    chunk()

    -- Lua
    self:set('Function_StopLua', Function_StopLua);
	self:set('Function_Stop', Function_Stop);
	self:set('Function_Continue', Function_Continue);
	self:set('luaDebugMode', false);
	self:set('luaDeprecatedWarnings', true);
	self:set('inChartEditor', false);

    -- Song/Week shit
    self:set('curBpm', Conductor.bpm);
	self:set('bpm', PlayState.SONG.bpm);
	self:set('scrollSpeed', PlayState.SONG.speed);
	self:set('crochet', Conductor.crochet);
	self:set('stepCrochet', Conductor.stepCrochet);
	self:set('songLength', PlayState.inst and PlayState.inst:getDuration() or 100);
	self:set('songName', PlayState.SONG.song);
	self:set('songPath', Paths.formatToSongPath(PlayState.SONG.song));
	self:set('startedCountdown', false);
	self:set('curStage', PlayState.SONG.stage);

    self:set('isStoryMode', PlayState.isStoryMode);
	self:set('difficulty', PlayState.storyDifficulty);

	self:set('difficultyName', Difficulty:getString());
	self:set('difficultyPath', Paths.formatToSongPath(Difficulty:getString()));
	self:set('weekRaw', PlayState.storyWeek);
	self:set('week', WeekData.weeksList[PlayState.storyWeek]);
	self:set('seenCutscene', PlayState.seenCutscene);
	self:set('hasVocals', PlayState.SONG.needsVoices);

    self:set('cameraX', 0);
    self:set('cameraY', 0);

    self:set('screenWidth', push:getWidth());
    self:set('screenHeight', push:getHeight());

    self:set('curBeat', 0);
    self:set('curStep', 0);
    self:set('curDecBeat', 0);
    self:set('curDecStep', 0);

    self:set('score', 0);
    self:set('misses', 0);
    self:set('hits', 0);

    self:set('rating', 0);
    self:set('ratingName', '');
    self:set('ratingFC', '');

    self:set('version', "MintEngine");

    self:set('inGameOver', false);
	self:set('mustHitSection', false);
	self:set('altAnim', false);
	self:set('gfSection', false);

    self:set('healthGainMult', PlayState.healthGain);
    self:set('healthLossMult', PlayState.healthLoss);
    self:set('playbackRate', PlayState.playbackRate);
    self:set('instakillOnMiss', PlayState.instakillOnMiss);
    self:set('botPlay', PlayState.cpuControlled);
    self:set('practice', PlayState.practiceMode);

    for i = 1, 4 do
        self:set('defaultPlayerStrumX' .. i-1, 0);
		self:set('defaultPlayerStrumY'.. i-1, 0);
		self:set('defaultOpponentStrumX' .. i-1, 0);
		self:set('defaultOpponentStrumY' .. i-1, 0);
    end

    for i = 1, 8 do
        self:set("strumLineNotes" .. i-1, {x=0, y=0})
    end

    self:set('defaultBoyfriendX', PlayState.BF_X);
    self:set('defaultBoyfriendY', PlayState.BF_Y);
    self:set('defaultOpponentX', PlayState.DAD_X);
    self:set('defaultOpponentY', PlayState.DAD_Y);
    self:set('defaultGirlfriendX', PlayState.GF_X);
    self:set('defaultGirlfriendY', PlayState.GF_Y);

    self:set('boyfriendName', PlayState.SONG.player1);
    self:set('dadName', PlayState.SONG.player2);
    self:set('gfName', PlayState.SONG.gfVersion);

    --[[ self:set('downscroll', ClientPrefs.data.downScroll);
    self:set('middlescroll', ClientPrefs.data.middleScroll);
    self:set('framerate', ClientPrefs.data.framerate);
    self:set('ghostTapping', ClientPrefs.data.ghostTapping);
    self:set('hideHud', ClientPrefs.data.hideHud);
    self:set('timeBarType', ClientPrefs.data.timeBarType);
    self:set('scoreZoom', ClientPrefs.data.scoreZoom);
    self:set('cameraZoomOnBeat', ClientPrefs.data.camZooms);
    self:set('flashingLights', ClientPrefs.data.flashing);
    self:set('noteOffset', ClientPrefs.data.noteOffset);
    self:set('healthBarAlpha', ClientPrefs.data.healthBarAlpha);
    self:set('noResetButton', ClientPrefs.data.noReset);
    self:set('lowQuality', ClientPrefs.data.lowQuality);
    self:set('shadersEnabled', ClientPrefs.data.shaders); ]]
    self:set('scriptName', scriptName);
    self:set('currentModDirectory', Mods.currentModDirectory);

    self:set(
        "openCustomSubstate",
        function(name, pauseGame)
            return false, "NOT_IMPLEMENTED"
        end
    )
    self:set(
        "cluseCustomSubstate",
        function()
            return false, "NOT_IMPLEMENTED"
        end
    )
    self:set(
        "getRunningScripts",
        function()
            local runningScripts = {}
            for i, script in PlayState.luaArray do
                table.insert(runningScripts, script.scriptName)
            end
            return runningScripts
        end
    )
    self:set(
        "setOnLuas",
        function(varName, arg, exclusions)
            exclusions = exclusions or {}
            PlayState.setOnLuas(varName, arg, exclusions)
        end
    )
    self:set(
        "callOnLuas",
        function(funcName, args, ignoreStops, exclusions)
            if not funcName then
                print("Error: callOnLuas called with no function name")
                return
            end
            local args = args or {}
            local exclusions = exclusions or {}
            PlayState.callOnLuas(funcName, args, ignoreStops, exclusions)
        end
    )
    self:set(
        "callScript",
        function(luaFile, funcName, args)
            if not luaFile then
                print("Error: callScript called with no lua file")
                return
            end
            if not funcName then
                print("Error: callScript called with no function name")
                return
            end

            local args = args or {}
            local cervix = luaFile .. ".lua"
            if luaFile:endsWith(".lua") then cervix = luaFile end
            local doPush = false
            if MODS_ALLOWED then
                if love.filesystem.getInfo(Paths.modFolders(cervix)) then
                    cervix = Paths.modFolders(cervix)
                    doPush = true
                elseif love.filesystem.getInfo(cervix) then
                    doPush = true
                else
                    cervix = "assets/" .. cervix
                end
            else
                cervix = "assets/" .. cervix
                if love.filesystem.getInfo(cervix) then
                    doPush = true
                end
            end

            if doPush then
                for i, luaInstance in PlayState.luaArray do
                    if luaInstance.scriptName == cervix then
                        luaInstance:call(funcName, args)

                        return
                    end
                end
            end
        end
    )
    self:set(
        "getGlobalFromScript",
        function(luaFile, global)
            if not luaFile then
                print("Error: getGlobalFromScript called with no lua file")
                return
            end
            if not global then
                print("Error: getGlobalFromScript called with no global name")
                return
            end

            local cervix = luaFile .. ".lua"
            if luaFile:endsWith(".lua") then cervix = luaFile end
            local doPush = false
            if MODS_ALLOWED then
                if love.filesystem.getInfo(Paths.modFolders(cervix)) then
                    cervix = Paths.modFolders(cervix)
                    doPush = true
                elseif love.filesystem.getInfo(cervix) then
                    doPush = true
                else
                    cervix = "assets/" .. cervix
                end
            else
                cervix = "assets/" .. cervix
                if love.filesystem.getInfo(cervix) then
                    doPush = true
                end
            end

            if doPush then
                for i, luaInstance in PlayState.luaArray do
                    if luaInstance.scriptName == cervix then
                        local globalValue = _G[global]
                        if globalValue then
                            return globalValue
                        else
                            print("Error: getGlobalFromScript called with invalid global name")
                            return
                        end
                    end
                end
            end
        end
    )
    self:set(
        "setGlobalFromScript",
        function(luaFile, global, val)

        end
    )
    self:set(
        "isRunning",
        function(luaFile)

        end
    )
    self:set(
        "addLuaScript",
        function(luaFile, ignoreAlreadyRunning)

        end
    )
    self:set(
        "removeLuaScript",
        function(luaFile)

        end
    )
    self:set(
        "loadSong",
        function(name, difficultyNum)
            local name = name
            local difficultyNum = difficultyNum or -1
            if not name or #name < 1 then
                name = PlayState.SONG.song
            end
            if difficultyNum == -1 then
                difficultyNum = PlayState.storyDifficulty
            end

            PlayState.SONG = Song:loadFromJson(name .. Difficulty.getStr(difficultyNum))
        end
    )
    self:set(
        "loadGraphic",
        function(variable, image, spriteType)
            local spriteType = spriteType or "sparrow"
            local killMe = variable:split(".")
            local spr = LuaUtils.getObjectDirectly(killMe[1])
            if #killme > 1 then
                spr = LuaUtils.getVarInArray(PlayState, LuaUtils.propertyLoop(killMe), killMe[#killMe])
            end

            if spr and image and #image > 0 then
                LuaUtils.loadFrames(spr, image, spriteType)
            end
        end
    )
    self:set(
        "makeLuaSprite",
        function(tag, image, x, y)
            local x = x or 0
            local y = y or 0
            LuaUtils.resetSpriteTag(tag)
            local leSprite = ModchartSprite(x, y)
            if image and #image > 0 then
                leSprite:load(Paths.image(image))
            end
            PlayState.modchartSprites[tag] = leSprite
            leSprite.active = true
        end
    )
    self:set(
        "setScrollFactor",
        function(obj, scrollX, scrollY)
            if PlayState:getLuaObject(obj, false) then
                PlayState:getLuaObject(obj, false).scrollFactor = {x=scrollX, y=scrollY}
                return
            end

            local object = LuaUtils.getTargetInstance()[obj] 
            if object then
                object.scrollFactor = {x=scrollX, y=scrollY}
            end
        end
    )
    self:set(
        "scaleObject",
        function(obj, x, y, updateHitbox)
            local updateHitbox = (updateHitbox == nil) and true or updateHitbox

            if PlayState:getLuaObject(obj, false) then
                PlayState:getLuaObject(obj, false).scale = {x=x, y=y}
                if updateHitbox then
                    PlayState:getLuaObject(obj, false):updateHitbox()
                end
                return
            end

            local killMe = obj:split(".")
            local poop = LuaUtils.getObjectDirectly(killMe[1])
            if #killMe > 1 then
                poop = LuaUtils.getVarInArray(PlayState, LuaUtils.getPropertyLoop(killMe, false))
            end

            if poop then
                poop.scale = {x=x, y=y}
                if updateHitbox then
                    poop:updateHitbox()
                end
            end
            print("Error: scaleObject called with invalid object name")
        end
    )
    self:set(
        "addLuaSprite",
        function(tag, front)
            if PlayState.modchartSprites[tag] then
                local shit = PlayState.modchartSprites[tag]
                shit.camera = PlayState.camGame
                if front then
                    LuaUtils.getTargetInstance():add(shit)
                else
                    if PlayState.isDead then

                    else
                        local position = table.indexOf(PlayState.members, PlayState.gf)
                        if table.indexOf(PlayState.members, PlayState.boyfriend) < position then
                            position = table.indexOf(PlayState.members, PlayState.boyfriend)
                        elseif table.indexOf(PlayState.members, PlayState.dad) < position then
                            position = table.indexOf(PlayState.members, PlayState.dad)
                        end

                        PlayState:add(shit, position)
                    end
                end
            end
        end
    )
    self:set(
        "makeAnimatedLuaSprite",
        function(tag, image, x, y, spriteType)
            local x = x or 0
            local y = y or 0
            local spriteType = spriteType or "sparrow"

            LuaUtils.resetSpriteTag(tag)
            local leSprite = ModchartSprite(x, y)
            LuaUtils.loadFrames(leSprite, image, spriteType)
            PlayState.modchartSprites[tag] = leSprite
        end
    )
    self:set(
        "addAnimationByPrefix",
        function(obj, name, prefix, framerate, loop)
            local framerate = framerate or 24
            local loop = (loop == nil) and true or loop
            local obj = LuaUtils.getObjectDirectly(obj, false)
            if obj and obj.frames then
                obj:addByPrefix(name, prefix, framerate, loop)
                if not obj.curAnim then
                    obj:play(name, true)
                end
                return true
            end
            return false
        end
    )
    self:set(
        "objectPlayAnimation", -- depracted, gotta add the old one
        function(obj, name, forced, startFrame)
            local startFrame = startFrame and startFrame+1 or 1
            if PlayState:getLuaObject(obj, false) then
                PlayState:getLuaObject(obj, false):play(name, forced, startFrame)
                return true
            end

            local spr = LuaUtils.getTargetInstance()[obj]
            if spr then
                spr:play(name, forced, startFrame)
                return true
            end
            return false
        end
    )
    self:set(
        "makeGraphic",
        function(obj, width, height, color)
            local width = width or 256
            local height = height or 256
            local color = color or "FFFFFF"

            local spr = PlayState:getLuaObject(obj, false)
            if spr then
                spr:makeGraphic(width, height, hexToColor(color))
                return
            end

            local object = LuaUtils.getTargetInstance()[obj]
            if object then
                object:makeGraphic(width, height, hexToColor(color))
            end
        end
    )
    self:set(
        "screenCenter",
        function(obj, pos)
            local pos = pos and pos:upper() or "XY"
            local spr = PlayState:getLuaObject(obj)

            if not spr then
                local killme = obj.split(".")
                spr = LuaUtils.getObjectDirectly(killMe[1])
                if #killMe > 1 then
                    spr = LuaUtils.getVarInArray(PlayState, LuaUtils.getPropertyLoop(killMe, false))
                end
            end

            if spr then
                spr:screenCenter(pos)
                return
            end

            print("Error: screenCenter called with invalid object name")
        end
    )
    self:set(
        "setProperty",
        function(variable, value)
            local killMe = variable:split(".")
            if #killMe > 1 then
                if PlayState[killMe[1]] then
                    PlayState[killMe[1]][killMe[2]] = value
                elseif PlayState.modchartSprites[killMe[1]] then
                    PlayState.modchartSprites[killMe[1]][killMe[2]] = value
                elseif PlayState.modchartTexts[killMe[1]] then
                    PlayState.modchartTexts[killMe[1]][killMe[2]] = value
                end
            end
            if PlayState[variable] then
                PlayState[variable] = value
            elseif PlayState.modchartSprites[variable] then
                PlayState.modchartSprites[variable] = value
            elseif PlayState.modchartTexts[variable] then
                PlayState.modchartTexts[variable] = value
            end
        end 
    )
    self:set(
        "getProperty",
        function(variable)
            local killMe = variable:split(".")
            if #killMe > 1 then
                if PlayState[killMe[1]] then
                    return PlayState[killMe[1]][killMe[2]]
                elseif PlayState.modchartSprites[killMe[1]] then
                    return PlayState.modchartSprites[killMe[1]][killMe[2]]
                elseif PlayState.modchartTexts[killMe[1]] then
                    return PlayState.modchartTexts[killMe[1]][killMe[2]]
                end
            end
            if PlayState[variable] then
                return PlayState[variable]
            elseif PlayState.modchartSprites[variable] then
                return PlayState.modchartSprites[variable]
            elseif PlayState.modchartTexts[variable] then
                return PlayState.modchartTexts[variable]
            end
        end
    )
    self:set(
        "getPropertyFromClass",
        function(class, var)
            return _G[class][var]
        end
    )
    self:set(
        "doTweenAlpha",
        function(tag, vars, value, duration, ease)
            self:oldTweenFunction(tag, vars, {alpha = value}, duration, ease, "doTweenAlpha")
        end
    )
    self:set(
        "doTweenColor",
        function(tag, vars, targetColor, duration, ease)
            local penisExam = LuaUtils:tweenPrepare(tag, vars) -- the ACTUAL name for it... what the fuck??
            if penisExam then
                local curColor = penisExam.color
                curColor.alphaFloat = penisExam.alpha
                PlayState.modchartTweens[tag] = Timer.tween(
                    duration, penisExam, {color = hexToColor(targetColor)}, LuaUtils.getTweenEaseByString(ease),
                    function(twn)
                        PlayState.modchartTweens[tag] = nil
                        PlayState:callOnLuas("onTweenCompleted", {tag, vars})
                    end
                )
            end
        end
    )
    self:set(
        "close",
        function()
            closed = true
            return closed
        end
    )

    self:call("onCreate", {})
end

function FunkinLua:call(func, args)
    if self.closed then return Function_Continue end

    self.lastCalledFunction = func

    TryExcept(
        function()
            if not self.vars then return Function_Continue end
            -- call the function
            -- make sure args isn't a table when its called! simple just to make it betyter
            if self.vars[func] then self.vars[func](unpack(args)) end
        end,
        function(err)
            print("ERROR! " .. err)
        end
    )
end

function FunkinLua:oldTweenFunction(tag, vars, tweenValue, duration, ease, tweenType)
    local target = LuaUtils.tweenPrepare(tag, vars)
    if target then
        PlayState.modchartTweens[tag] = Timer.tween(
            duration, target, tweenValue, LuaUtils.getTweenEaseByString(ease),
            function(twn)
                PlayState.modchartTweens[tag] = nil
                PlayState:callOnLuas("onTweenCompleted", {tag, vars})
            end
        )
    else
        print("Error: " .. tweenType .. " called with invalid object name")
    end
end

return FunkinLua