local oPrint = print
function print(...)
    local args = {...}
    oPrint("[" .. (debug.getinfo(2, "S").source):gsub("@", ""):gsub(".lua", "") .. "] " .. args[1], select(2, ...))
end

function love.load()
    Config = require("Backend.Config")
    Class = require("Lib.Class")
    Json = require("Lib.Json")
    Timer = require("Lib.Timer")
    Xml = require("Lib.Xml")

    require("Backend")
    require("Funkin")

    Game = Group()
    function Game:switchState(newState)
        for _, member in ipairs(Game.members) do
            if member:isInstanceOf(State) then
                member:destroy()
                self:remove(member)
            end
        end

        newState:create()
        self:add(newState)
    end
    Game.width, Game.height = Config.GameWidth, Config.GameHeight
    table.insert(Camera._defaultCameras, Camera(0, 0, 1280, 720))
    Game:add(Camera._defaultCameras[1])

    Game:switchState(TitleState())
end 

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end
