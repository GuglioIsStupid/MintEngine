local VersionUtil = {}

-- rule is like this: "2.1.x"
local function satisfyVersion(raw, rule)
    local version = raw
    local versionRule = rule

    local versionParts = version:split(".")
    local ruleParts = versionRule:split(".")

    for i = 1, #ruleParts do
        local rulePart = ruleParts[i]
        local versionPart = versionParts[i]

        if rulePart == "x" then
            return true
        end

        if rulePart == "x" and versionPart == nil then
            return false
        end

        if rulePart ~= versionPart then
            return false
        end
    end

    return true
end

function VersionUtil:validateVersion(version, versionRule)
    local ok, err = pcall(function()
        local versionRaw = version
        return satisfyVersion(versionRaw, versionRule)
    end)

    if not ok then
        return false
    end
end

function VersionUtil:reparVersion(version)

end

function VersionUtil:validateVersionStr(version, versionRule)
    local ok, err = pcall(function()
        return satisfyVersion(version, versionRule)
    end)

    if not ok then
        return false
    end
end

function VersionUtil:getVersionFromJSON(input)
    if input == nil then
        return nil
    end

    local parsed = Json.decode(input)
    if parsed == nil then
        return nil
    end
    if parsed.version == nil then
        return nil
    end
    local versionStr = parsed.version
    return versionStr
end

function VersionUtil:parseVersion(input)
    if input == nil then
        return nil
    end

    local versionStr = input
    return versionStr
end

return VersionUtil