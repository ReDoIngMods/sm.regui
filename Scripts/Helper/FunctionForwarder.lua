---Creates a function that forwards calls to a global function at the given dot-separated path.
---@param path string e.g. "MyModule.Utils.doThing"
---@return function
function CreateFunctionForwarder(path)
    ErrorHandler:AssertArgument(path, nil, "string")

    return function (...)
        local parts = {}
        for part in path:gmatch("([^%.]+)") do
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