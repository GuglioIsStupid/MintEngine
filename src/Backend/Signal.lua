---@class Signal
local Signal = Class:extend()

function Signal:new()
    self.functions = {}

    print("[Signal] Created Signal")
end

function Signal:add(...)
    local args = {...}
    for i = 1, #args do
        table.insert(self.functions, args[i])
    end
end

function Signal:dispatch()
    for _, func in ipairs(self.functions) do
        if type(func) == "function" then
            func()
        else
            print("[Signal] Non-function attempted to be called.")
        end
    end
end

return Signal