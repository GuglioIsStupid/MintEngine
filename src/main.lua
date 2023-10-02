function love.load()
    -- Libraries
    input = (require "libs.baton").new {
        controls = {
            note_left = {"key:left", "key:a", "axis:leftx-", "button:dpleft"},
            note_right = {"key:right", "key:d", "axis:leftx+", "button:dpright"},
            note_up = {"key:up", "key:w", "axis:lefty-", "button:dpup"},
            note_down = {"key:down", "key:s", "axis:lefty+", "button:dpdown"},

            accept = {"key:return", "button:a"},
            back = {"key:escape", "button:b"},

            ui_down = {"key:down", "button:dpdown"},
            ui_up = {"key:up", "button:dpup"},
            ui_left = {"key:left", "button:dpleft"},
            ui_right = {"key:right", "button:dpright"},
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
    local cur_locale = SaveVariables.locale
    if love.system.getOS() == "NX" then
        cur_locale = cur_locale .. "_nx"
    end
    locale = json.decode(love.filesystem.read("locales/" .. cur_locale .. ".json"))

    -- Modules
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

    StrumNote = require "objects.StrumNote"
    Note = require "objects.Note"
    EventNote = require "objects.EventNote"
    Character = require "objects.Character"
    BGSprite = require "objects.BGSprite"

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

    Gamestate.switch(TitleState)

    firstStartup = false
end

function love.update(dt)
    Gamestate.update(dt)
    Flicker:update(dt)
    Timer.update(dt)
    input:update()
end

function love.resize(w, h)
    push.resize(w, h)
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
    love.graphics.print(locale.debug.fps .. love.timer.getFPS() .. "\n" .. 
                        locale.debug.memory .. math.floor(collectgarbage("count")) .. " KB\n" .. 
                        locale.debug.graphics_memory .. math.floor(love.graphics.getStats().texturememory / 1024 / 1024) .. " MB\n" ..
                        locale.debug.draw_calls .. love.graphics.getStats().drawcalls, 10, 10)
end
