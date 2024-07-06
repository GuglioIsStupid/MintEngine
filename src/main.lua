function love.load()
    Config = require("Backend.Config")
    Class = require("Lib.Class")
    Json = require("Lib.Json")
    Timer = require("Lib.Timer")
    Xml = require("Lib.Xml")

    require("Backend")
    require("Funkin")

    --[[ print(love.filesystem.read(Paths.txt('introText'))) ]]

    CurrentState = TitleState()
end 

function love.update(dt)
    CurrentState:update(dt)
end

function love.draw()
    CurrentState:draw()
end
