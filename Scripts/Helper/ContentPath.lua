local contentData = "$CONTENT_DATA"
local modData = "$MOD_DATA"

---Resolves $CONTENT_DATA and $MOD_DATA paths into direct $CONTENT_[UUID] paths.
---@param path string The path to resolve
---@return string resolvedPath The resolved path
function ResolveContentPath(path)
    local directPath = ""
    if path:sub(1, #contentData) == contentData then
        directPath = path:sub(#contentData + 1)
    elseif path:sub(1, #modData) == modData then
        directPath = path:sub(#modData + 1)
    else
        return path
    end

    ---@type boolean, Internal.ReGui.Meta.DescriptionJson
    local success, result = pcall(sm.json.open, "$CONTENT_DATA/description.json")
    if not success then
        return path
    end

    local localId = result.localId
    return "$CONTENT_" .. localId .. directPath
end

print("Loaded Helper/ContentPath.lua")