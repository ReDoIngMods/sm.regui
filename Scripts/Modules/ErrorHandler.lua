sm.regui.errorHandler = {}

local __getmetatable_unsafe = __getmetatable_unsafe or getmetatable

local math_floor = math.floor
local table_concat = table.concat
local string_find = string.find
local string_sub = string.sub
local math_min = math.min
local string_format = string.format

local function getRealType(value)
    local luaType = type(value)
    if luaType ~= "number" then
        if luaType == "table" then
            local meta = __getmetatable_unsafe(value)
            if type(meta) == "table" and type(meta.__type) == "string" then
                return meta.__type
            end
        end
        
        return luaType
    end

    if value ~= value then
        return "nan"
    end

    if math_floor(value) == value then
        return "integer"
    end

    return "number"
end

---@param value any
---@param expected string|string[]
---@param enableRawTypeCheck boolean?
---@return boolean
local function typeMatches(value, expected, enableRawTypeCheck)
    local realType = getRealType(value)
    if type(expected) == "table" then
        for _, allowed in ipairs(expected) do
            if allowed == "number" and realType == "integer" then
                return true
            end

            if allowed == realType then
                return true
            end

            if enableRawTypeCheck and allowed == type(value) then
                return true
            end
        end

        return false
    end

    if expected == "number" and realType == "integer" then
        return true
    end

    if enableRawTypeCheck and expected == type(value) then
        return true
    end

    return expected == realType
end

local function resolvePathValue(sourceTable, path)
    local value = sourceTable
    local pathIndex = 1

    while pathIndex <= #path do
        while pathIndex <= #path and string_sub(path, pathIndex, pathIndex) == "." do
            pathIndex = pathIndex + 1
        end

        if pathIndex > #path then
            break
        end

        if string_sub(path, pathIndex, pathIndex) == "[" then
            local endBracket = string_find(path, "%]", pathIndex)
            if not endBracket then
                break
            end

            local indexStr = string_sub(path, pathIndex + 1, endBracket - 1)
            local index = tonumber(indexStr)

            value = value[index or indexStr]
            pathIndex = endBracket + 1
        else
            local nextDot = string_find(path, "%.", pathIndex)
            local nextBracket = string_find(path, "%[", pathIndex)

            local nextEnd = #path + 1

            if nextDot then
                nextEnd = math_min(nextEnd, nextDot)
            end

            if nextBracket then
                nextEnd = math_min(nextEnd, nextBracket)
            end

            local key = string_sub(path, pathIndex, nextEnd - 1)

            value = value[key]
            pathIndex = nextEnd
        end
    end

    return value
end

---@param argumentIndex integer?
---@param expected string
---@param got string
---@return string
local function makeArgumentError(argumentIndex, expected, got)
    local gotStr = got and (", got " .. got) or ""
    if type(argumentIndex) == "number" then
        if argumentIndex == -1 then
            return string_format("expected %s%s.", expected, gotStr)
        end

        return string_format("Bad argument #%d: expected %s%s.", argumentIndex, expected, gotStr)
    end

    return string_format("Bad argument: expected %s%s.", expected, gotStr)
end

---@param argument any
---@param argumentIndex integer
---@param expected string|string[]
---@param overwrite string|string[]
---@param enableRawTypeCheck boolean?
function sm.regui.errorHandler.assertArgument(argument, argumentIndex, expected, overwrite, enableRawTypeCheck)
    if typeMatches(argument, expected, enableRawTypeCheck) then
        return
    end

    local expectedStr
    if type(expected) == "table" then
        local displayNames = {}
        for index, expectedType in ipairs(expected) do
            displayNames[index] = (overwrite and overwrite[index]) or expectedType
        end

        expectedStr = table_concat(displayNames, ", ")
    else
        expectedStr = overwrite or expected
    end

    error(makeArgumentError(argumentIndex, expectedStr, GetRealType(argument)), 2)
end

---@param sourceTable table
---@param argumentIndex integer
---@param path string
---@param expected string|string[]
---@param displayPath string
---@param overwrite string|string[]
---@param enableRawTypeCheck boolean?
function sm.regui.errorHandler.assertTableValue(sourceTable, argumentIndex, path, expected, displayPath, overwrite, enableRawTypeCheck)
    local value = ResolvePathValue(sourceTable, path)

    if TypeMatches(value, expected, enableRawTypeCheck) then
        return
    end

    local expectedStr

    if type(expected) == "table" then
        local displayNames = {}
        for index, expectedType in pairs(expected) do
            displayNames[index] = (overwrite and overwrite[index]) or expectedType
        end

        expectedStr = table_concat(displayNames, ", ")
    else
        expectedStr = overwrite or expected
    end

    local message = makeArgumentError(argumentIndex, expectedStr, GetRealType(value))
    error(string_format("'%s': %s", displayPath or path, message), 2)
end

---@param argument any
---@param argumentIndex integer
function sm.regui.errorHandler.assertNotNaN(argument, argumentIndex)
    if argument == argument then
        return
    end

    if argumentIndex then
        error(string_format("Bad argument #%d: value must not be NaN.", argumentIndex), 2)
    else
        error("Bad argument: value must not be NaN.", 2)
    end
end

---@param condition boolean
---@param argumentIndex integer
---@param message string
function sm.regui.errorHandler.assertCondition(condition, argumentIndex, message)
    if condition then
        return
    end

    if argumentIndex then
        error(string_format("Bad argument #%d: %s", argumentIndex, message), 2)
    end

    error(string_format("Bad argument: %s", message), 2)
end


---@param argument any
---@param argumentIndex integer
---@param checker fun(argument: any): boolean
---@param message string
function sm.regui.errorHandler.assertValue(argument, argumentIndex, checker, message)
    sm.regui.errorHandler.assertCondition(checker(argument), argumentIndex, message)
end

---@param self table
---@param expected string
---@param hasMultipleArguments boolean
function sm.regui.errorHandler.assertSelf(self, expected, hasMultipleArguments)
    if type(self) == "table" and self.__type == expected then
        return
    end

    local got = type(self) == "table" and tostring(self.__type) or getRealType(self)
    error(string_format("Bad argument%s: expected %s instance, got %s.", hasMultipleArguments and " #1" or "", expected, got), 2)
end

---@param expectsServer boolean
---@param isCallback boolean
function sm.regui.errorHandler.assertEnvironment(expectsServer, isCallback)
    if expectsServer == sm_isServerMode() then
        return
    end

    local expectedEnvironment = expectsServer and "server" or "client"
    local gotEnvironment = expectsServer and "client" or "server"

    error(string_format("Sandbox violation: calling %s function from %s%s.", expectedEnvironment, gotEnvironment, isCallback and "" or " callback"), 2)
end