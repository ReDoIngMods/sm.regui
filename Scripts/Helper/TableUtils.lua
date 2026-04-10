function IsTableArray(tbl)
    if type(tbl) ~= "table" then
        return false
    end

    local expectedIndex = 1
    for index, _ in pairs(tbl) do
        if type(index) ~= "number" then
            return false
        end
        if index ~= expectedIndex then
            return false
        end

        expectedIndex = expectedIndex + 1
    end

    return true
end

function GetTableSize(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

print("Loaded Helpers/TableUtils.lua")