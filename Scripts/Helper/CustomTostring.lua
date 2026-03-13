function CreateCustomTostringFunction(name)
    return function ()
        return name
    end
end

print("Loaded Helper/CustomTostring.lua")