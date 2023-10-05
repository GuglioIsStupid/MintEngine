local UITabMenu = Object:extend()

function UITabMenu:new(tabs)
    self.x, self.y = 0, 0
    self.curTab = 1
    self.font = Paths.font("assets/fonts/vcr.ttf", 12)
    self.width = 300
    self.height = 400
    self.tabHeight = 20
    self.tabs = tabs
end

function UITabMenu:resize(w, h)
    self.width = w
    self.height = h
end

function UITabMenu:update(dt)
    local x, y
    if love.system.getOS() == "Windows" or love.system.getOS() == "Linux" or love.system.getOS() == "OS X" then
        x, y = push.toGame(love.mouse.getX(), love.mouse.getY())
    else
        -- get touch position
        x, y = push.toGame(love.touch.getPosition(1))
    end

    for i, tab in ipairs(self.tabs) do
        local tabX = self.x + (i-1) * ((self.width/#self.tabs) + 1)
        local tabY = self.y + 2
        if x >= tabX and x <= tabX + (self.width/#self.tabs) and y >= tabY and y <= tabY + self.tabHeight then
            if love.mouse.isDown(1) or next(love.touch.getTouches()) ~= nil then
                self.curTab = i
            end
        end
    end
end

function UITabMenu:draw()
    love.graphics.push()
        for i, tab in ipairs(self.tabs) do
            local x = self.x + (i-1) * ((self.width/#self.tabs) + 1)
            local y = self.y + 2

            love.graphics.setColor(i == self.curTab and {0.7, 0.7, 0.7, 1} or {0.45, 0.45, 0.45, 1})
            love.graphics.rectangle("fill", x, y, (self.width/#self.tabs), self.tabHeight)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(self.font)
            local textWidth = self.font:getWidth(tab.label)
            local textHeight = self.font:getHeight(tab.label)
            love.graphics.print(tab.label, x + ((self.width/#self.tabs) - textWidth) / 2, y + (self.tabHeight - textHeight) / 2)
        end

        love.graphics.setColor(0.7, 0.7, 0.7, 1)
        love.graphics.rectangle("fill", self.x, self.y + self.tabHeight, self.width + (#self.tabs-1), self.height, 4, 4)
    love.graphics.pop()
end

return UITabMenu