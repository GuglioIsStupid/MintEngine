function love.load()
    Class = require("Lib.Class")
    require("Backend")
    require("Funkin")

    print(love.filesystem.read(Paths.txt('introText')))
end 

function love.update()

end

function love.draw()

end
