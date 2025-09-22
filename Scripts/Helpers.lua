function GetTableSize(tbl)
    local size = 0
    for _, _ in pairs(tbl) do
        size = size + 1
    end

    return size
end

function CloneTable(tbl)
    local sharedReferences = {}
    local function cloneInternal(original)
        if type(original) ~= "table" then
            return original
        end

        if sharedReferences[original] then
            return sharedReferences[original]
        end

        local copy = {}
        sharedReferences[original] = copy

        for key, value in pairs(original) do
            copy[cloneInternal(key)] = cloneInternal(value)
        end

        return copy
    end

    return cloneInternal(tbl)
end

print("Loaded Helpers!")