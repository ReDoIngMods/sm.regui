function ValueAssert(value, argumentIndex, errMsg)
    if value then return end

    local badMessage = argumentIndex and ("Bad argument #" .. tostring(argumentIndex) .. "! ") or ""
    error(badMessage .. errMsg)
end


function AssertArgument(value, argumentIndex, allowedTypes, nameOverwrites)
    local valueType = (value ~= value) and "NaN" or type(value)
    local valueHasCorrectType = false

    for _, allowedType in pairs(allowedTypes) do
        local allowedTypeIsInteger = allowedType == "integer"
        if valueType == (allowedTypeIsInteger and "number" or allowedType) then
            if not allowedTypeIsInteger or math.floor(value) == value then
                valueHasCorrectType = true
                break
            end
        end
    end

    if valueHasCorrectType then return end

    local allowedTypesMessage = ""
    for i, allowedType in ipairs(allowedTypes) do
        local typeMessage = nameOverwrites and (nameOverwrites[i] or allowedType) or allowedType
        allowedTypesMessage = allowedTypesMessage .. (i == 1 and "" or (i == #allowedTypes and " or " or ", ")) .. typeMessage
    end

    local badArgument = argumentIndex and ("Bad argument #" .. tostring(argumentIndex) .. "! ") or ""
    error(string.format("%sExpected %s, got %s instead!", badArgument, allowedTypesMessage, valueType))
end

function SandboxAssert(isServer)
    assert(sm.isServerMode() == isServer, string.format("Attempted to run a %s-side only function as %s!", isServer and "server" or "client", isServer and "client" or "server"))
end

function SelfAssert(self)
    assert(type(self) == "table", "No userdata provided or unknown")
end

print("Loaded ErrorHandler")