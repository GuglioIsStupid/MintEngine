local mouseTimer, maxMouseTimer = 0, 1 -- time before mouse is hidden
local lastMouseX, lastMouseY = 0, 0
local pc = {"Windows", "Linux", "OS X"}
function love.load()
    require "config"
    -- Libraries

    local note_left, note_right, note_up, note_down, accept, back
    if love.system.getOS() == "NX" then
        note_left = {"key:left", "key:a", "axis:leftx-", "button:dpleft",  "axis:triggerleft+", "button:y", "axis:rightx-"}
        note_right = {"key:right", "key:d", "axis:leftx+", "button:dpright", "button:a", "axis:triggerright+", "axis:rightx+"}
        note_up = {"key:up", "key:w", "axis:lefty-", "button:dpup", "button:rightshoulder", "button:x", "axis:righty-"}
        note_down = {"key:down", "key:s", "axis:lefty+", "button:dpdown", "button:leftshoulder", "button:b", "axis:righty+"}
    else
        -- same thing, but y/x, a/b are swapped
        note_left = {"key:left", "key:a", "axis:leftx-", "button:dpleft",  "axis:triggerleft+", "button:x", "axis:rightx-"}
        note_right = {"key:right", "key:d", "axis:leftx+", "button:dpright", "button:b", "axis:triggerright+", "axis:rightx+"}
        note_up = {"key:up", "key:w", "axis:lefty-", "button:dpup", "button:rightshoulder", "button:y", "axis:righty-"}
        note_down = {"key:down", "key:s", "axis:lefty+", "button:dpdown", "button:leftshoulder", "button:a", "axis:righty+"}
    end
    input = (require "libs.baton").new {
        controls = {
            note_left = note_left,
            note_right = note_right,
            note_up = note_up,
            note_down = note_down,

            accept = {"key:return", "button:a"},
            back = {"key:escape", "button:b"},

            ui_down = {"key:down", "button:dpdown", "axis:lefty+"},
            ui_up = {"key:up", "button:dpup", "axis:lefty-"},
            ui_left = {"key:left", "button:dpleft", "axis:leftx-"},
            ui_right = {"key:right", "button:dpright", "axis:leftx+"},
        },
        joystick = love.joystick.getJoysticks()[1],
    }
    push = require "libs.push"
    Gamestate = require "libs.gamestate"
    json = require "libs.json"
    xml = require "libs.xml"
    Object = require "libs.classic"
    Timer = require "libs.timer"

    ClientPrefs = require "backend.ClientPrefs".ClientPrefs
    SaveVariables = require "backend.ClientPrefs".SaveVariables
    -- locales -- todo. add more languages & switch specifics
    --[[ local cur_locale = SaveVariables.locale
    if love.system.getOS() == "NX" then
        cur_locale = cur_locale .. "_nx"
    end
    locale = json.decode(love.filesystem.read("locales/" .. cur_locale .. ".json")) ]]

    -- Modules
    Mods = require "backend.Mods"
    require "modules.override"
    CoolUtil = require "modules.CoolUtil"
    Paths = require "backend.Paths"
    Cache = require "backend.Cache"
    Conductor = require "backend.Conductor"
    Camera = require "backend.Camera"
    Sprite = require "modules.Sprite"
    AtlasSprite = require "animateatlas.Sprite"
    Text = require "modules.Text"
    Group = require "modules.flixel.Group"
    SpriteGroup = require "modules.flixel.SpriteGroup"
    Flicker = require "modules.flixel.Flicker"
    Song = require "backend.Song"
    MusicBeatState = require "backend.MusicBeatState"
    BaseStage = require "backend.BaseStage"
    StageData = require "backend.StageData"
    WeekData = require "backend.WeekData"
    Difficulty = require "backend.Difficulty"
    Sound = require "modules.sound"
    Rating = require "backend.Rating"
    HealthIcon = require "objects.HealthIcon"
    Trail = require "modules.flixel.Trail"
    Point = require "modules.flixel.math.Point"
    Button = require "modules.flixel.ui.FlxButton"
    UITabMenu = require "modules.flixel.ui.FlxUITabMenu"

    -- FunkinLua
    ModchartSprite = require "FunkinLua.ModchartSprite"
    LuaUtils = require "FunkinLua.LuaUtils"
    FunkinLua = require "FunkinLua.FunkinLua"

    -- Objects
    StrumNote = require "objects.StrumNote"
    Note = require "objects.Note"
    EventNote = require "objects.EventNote"
    Character = require "objects.Character"
    BGSprite = require "objects.BGSprite"
    Alphabet = require "objects.Alphabet"
    AttachedSprite = require "objects.AttachedSprite"

    DialogueBox = require "cutscenes.DialogueBox"
    HealthBar = require "objects.HealthBar"

    Stages = {
        Stage = require "states.stages.stage",
        Spooky = require "states.stages.spooky",
        Philly = require "states.stages.philly",
        Limo = require "states.stages.limo",
        Mall = require "states.stages.mall",
        MallEvil = require "states.stages.mallEvil",
        School = require "states.stages.school",
        SchoolEvil = require "states.stages.schoolEvil",
        Tank = require "states.stages.tank",
    }

    push.setupScreen(1280, 720, {upscale = "normal"})

    firstStartup = true

    -- Preloaded sounds
    Paths.sound("assets/sounds/cancelMenu.ogg")
    Paths.sound("assets/sounds/confirmMenu.ogg")
    Paths.sound("assets/sounds/scrollMenu.ogg")

    -- States
    TitleState = require "states.Title"
    MainMenuState = require "states.MainMenu"
    StoryMenuState = require "states.StoryMenu"
    PlayState = require "states.Play"
    FreeplayState = require "states.Freeplay"
    CreditsState = require "states.Credits"

    Editors = {
        ChartingState = require "states.editors.ChartingState",
    }

    Gamestate.switch(TitleState)

    firstStartup = false

    -- create mods folder if it doesn't exist
    if not love.filesystem.getInfo("mods") then
        love.filesystem.createDirectory("mods")
    end

    if table.contains(pc, love.system.getOS()) then
        love.mouse.setCursor(love.mouse.newCursor("assets/images/png/flixel/ui/cursor.png"))
    end
end

function love.update(dt)
    local newMouseX, newMouseY = love.mouse.getPosition()
    if newMouseX ~= lastMouseX or newMouseY ~= lastMouseY then
        mouseTimer = 0
        love.mouse.setVisible(true)
    else
        mouseTimer = mouseTimer + dt
        if mouseTimer >= maxMouseTimer then
            love.mouse.setVisible(false)
        end
    end
    Gamestate.update(dt)
    Flicker:update(dt)
    Timer.update(dt)
    input:update()

    lastMouseX, lastMouseY = love.mouse.getPosition()
end

function love.resize(w, h)
    push.resize(w, h)
end


function love.keypressed(key, scancode, isrepeat)
    if key == "7" then
        Gamestate.switch(Editors.ChartingState)
    end
end

function love.draw()
    push:start()    
        -- for testing why things aren't on screen
        --love.graphics.translate(love.graphics.getWidth() / 3, love.graphics.getHeight() /3)
        --love.graphics.scale(0.25, 0.25)
        -- 
        Gamestate.draw()

        if MusicBeatState.fade.graphic then
            love.graphics.draw(MusicBeatState.fade.graphic, 0, MusicBeatState.fade.y, 0, push:getWidth(), MusicBeatState.fade.height)
        end
    push:finish()

    -- print fps
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("FPS:" .. love.timer.getFPS() .. "\n" .. 
                        "Lua Memory: " .. math.floor(collectgarbage("count")) .. " KB\n" .. 
                        "Graphics Memory: " .. math.floor(love.graphics.getStats().texturememory / 1024 / 1024) .. " MB\n" ..
                        "Draw Calls: " .. love.graphics.getStats().drawcalls, 10, 10)
end
