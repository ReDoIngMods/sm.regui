
print("Loaded Helper/TableClone.lua")

function CloneTable(original)
    ErrorHandler:AssertArgument(original, 1, "table")

    local copy = {}

    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = CloneTable(value)
        else
            copy[key] = value
        end
    end
    
    return copy
end