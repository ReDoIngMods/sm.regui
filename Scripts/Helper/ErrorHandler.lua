ErrorHandler = {}

local function GetRealType(value)
    if type(value) ~= "number" then
        return type(value)
    end

    if value ~= value then
        return "nan"
    end

    if math.floor(value) == value then
        return "integer"
    end

    return "number"
end

local function TypeMatches(value, expected)
    local realType = GetRealType(value)
    local luaType = type(value)

    if type(expected) == "table" then
        for _, allowed in pairs(expected) do
            if allowed == realType or allowed == luaType then
                return true
            end
        end

        return false
    end

    return expected == realType or expected == luaType
end

local function FormatExpected(expected)
    if type(expected) == "table" then
        return table.concat(expected, ", ")
    end

    return expected
end

local function ResolvePathValue(sourceTable, path)
    local value = sourceTable
    local pathIndex = 1

    while pathIndex <= #path do
        while pathIndex <= #path and string.sub(path, pathIndex, pathIndex) == "." do
            pathIndex = pathIndex + 1
        end

        if pathIndex > #path then
            break
        end

        if string.sub(path, pathIndex, pathIndex) == "[" then
            local endBracket = string.find(path, "%]", pathIndex)
            if not endBracket then
                break
            end

            local indexStr = string.sub(path, pathIndex + 1, endBracket - 1)
            local index = tonumber(indexStr)

            value = value[index or indexStr]
            pathIndex = endBracket + 1
        else
            local nextDot = string.find(path, "%.", pathIndex)
            local nextBracket = string.find(path, "%[", pathIndex)

            local nextEnd = #path + 1

            if nextDot then
                nextEnd = math.min(nextEnd, nextDot)
            end

            if nextBracket then
                nextEnd = math.min(nextEnd, nextBracket)
            end

            local key = string.sub(path, pathIndex, nextEnd - 1)

            value = value[key]
            pathIndex = nextEnd
        end
    end

    return value
end

---@param argumentIndex integer
---@param expected string
---@param got string
---@return string
function ErrorHandler.MakeArgumentError(argumentIndex, expected, got)
    local gotStr = got and (", got " .. got) or ""
    if argumentIndex then
        if argumentIndex == -1 then
            return string.format("expected %s%s.", expected, gotStr)
        end

        return string.format("Bad argument #%d: expected %s%s.", argumentIndex, expected, gotStr)
    end

    return string.format("Bad argument: expected %s%s.", expected, gotStr)
end

---@param argument any
---@param argumentIndex integer
---@param expected string|string[]
---@param overwrite string|string[]
function ErrorHandler.AssertArgument(argument, argumentIndex, expected, overwrite)
    if TypeMatches(argument, expected) then
        return
    end

    local expectedStr

    if type(expected) == "table" then
        local displayNames = {}
        for index, expectedType in pairs(expected) do
            displayNames[index] = (overwrite and overwrite[index]) or expectedType
        end

        expectedStr = FormatExpected(displayNames)
    else
        expectedStr = overwrite or expected
    end

    error(ErrorHandler.MakeArgumentError(argumentIndex, expectedStr, GetRealType(argument)), 2)
end

---@param sourceTable table
---@param argumentIndex integer
---@param path string
---@param expected string|string[]
---@param displayPath string
---@param overwrite string|string[]
function ErrorHandler.AssertTableValue(sourceTable, argumentIndex, path, expected, displayPath, overwrite)
    local value = ResolvePathValue(sourceTable, path)

    if TypeMatches(value, expected) then
        return
    end

    local expectedStr

    if type(expected) == "table" then
        local displayNames = {}

        for index, expectedType in pairs(expected) do
            displayNames[index] = (overwrite and overwrite[index]) or expectedType
        end

        expectedStr = FormatExpected(displayNames)
    else
        expectedStr = overwrite or expected
    end

    local message = ErrorHandler.MakeArgumentError(argumentIndex, expectedStr, GetRealType(value))
    error(string.format("'%s': %s", displayPath or path, message), 2)
end

---@param argument any
---@param argumentIndex integer
function ErrorHandler.AssertNotNaN(argument, argumentIndex)
    if argument == argument then
        return
    end

    if argumentIndex then
        error(string.format("Bad argument #%d: value must not be NaN.", argumentIndex), 2)
    else
        error("Bad argument: value must not be NaN.", 2)
    end
end

---@param condition boolean
---@param argumentIndex integer
---@param message string
function ErrorHandler.AssertCondition(condition, argumentIndex, message)
    if condition then
        return
    end

    if argumentIndex then
        error(string.format("Bad argument #%d: %s", argumentIndex, message), 2)
    end

    error(string.format("Bad argument: %s", message), 2)
end


---@param argument any
---@param argumentIndex integer
---@param checker fun(argument: any): boolean
---@param message string
function ErrorHandler.AssertValue(argument, argumentIndex, checker, message)
    ErrorHandler.AssertCondition(checker(argument), argumentIndex, message)
end

---@param self table
---@param expected string
---@param hasMultipleArguments boolean
function ErrorHandler.AssertSelf(self, expected, hasMultipleArguments)
    if type(self) == "table" and self.__type == expected then
        return
    end

    local got = type(self) == "table" and tostring(self.__type) or GetRealType(self)
    error(string.format("Bad argument%s: expected %s instance, got %s.", hasMultipleArguments and " #1" or "", expected, got), 2)
end

---@param expectsServer boolean
---@param isCallback boolean
function ErrorHandler.AssertEnvironment(expectsServer, isCallback)
    if expectsServer == sm.isServerMode() then
        return
    end

    local expectedEnvironment = expectsServer and "server" or "client"
    local gotEnvironment = expectsServer and "client" or "server"

    error(string.format("Sandbox violation: calling %s function from %s%s.", expectedEnvironment, gotEnvironment, isCallback and "" or " callback"), 2)
end

print("Loaded Helper/ErrorHandler.lua")