function CreateCustomTostringFunction(name)
    ErrorHandler.AssertArgument(name, nil, "string")

    return function ()
        return name
    end
end

print("Loaded Helper/CustomTostring.lua")