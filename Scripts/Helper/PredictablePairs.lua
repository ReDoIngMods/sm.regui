---@generic T: table, K, V
---@param tbl T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
function PredictablePairs(tbl)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end

    table.sort(keys)

    local index = 0
    return function()
        index = index + 1

        local key = keys[index]
        return key, tbl[key]
    end, tbl
end

print("Loaded Helpers/PredictablePairs.lua")