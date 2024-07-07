---@class Signal
local Signal = Class:extend()

function Signal:new()
    self.functions = {}

    --[[ print("Created Signal") ]]
end

---@param func function
function Signal:add(func)
    table.insert(self.functions, func)
end

---@param func function
function Signal:remove(func)
    for i, f in ipairs(self.functions) do
        if f == func then
            table.remove(self.functions, i)
            break
        end
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