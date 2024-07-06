local path = ...

local function r(p)
    return require(path .. "." .. p)
end

Signal = r("Signal")
r("Lua.String")
r("Lua.Table")