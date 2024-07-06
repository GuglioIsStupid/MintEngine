local path = ...

local function r(p)
    return require(path .. "." .. p)
end

Constants = r("util.Constants")
Paths = r("Paths")
Conductor = r("Conductor")