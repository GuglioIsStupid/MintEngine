function love.load()
    Config = require("Backend.Config")
    Class = require("Lib.Class")
    Json = require("Lib.Json")
    Timer = require("Lib.Timer")
    Xml = require("Lib.Xml")

    require("Backend")
    require("Funkin")

    --[[ print(love.filesystem.read(Paths.txt('introText'))) ]]

    currentState = TitleState()
end 

function love.update(dt)
    currentState:update(dt)
end

function love.draw()
    currentState:draw()
end
