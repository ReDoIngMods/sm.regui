local string_gmatch = string.gmatch

function CreateFunctionForwarder(path)
    return function (...)
        local parts = {}
        for part in string_gmatch(path, "([^%.]+)") do
            table.insert(parts, part)
        end

        local destination = _G
        local functionName = nil
        for index, part in pairs(parts) do
            if index == #parts then
                functionName = part
            else
                destination = destination[part]
            end
        end

        return destination[functionName](...)
    end
end

print("Loaded Helper/FunctionForwarder.lua")