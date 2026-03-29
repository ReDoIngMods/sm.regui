ErrorHandler = {}

local function IsNaNValue(value)
    return type(value) == "number" and value ~= value
end

local function IsTypeInteger(value)
    return type(value) == "number" and value == value and math.floor(value) == value
end

local function TypeMatches(value, expected)
    if expected == "integer" then
        return IsTypeInteger(value)
    elseif expected == "nan" then
        return IsNaNValue(value)
    else
        return type(value) == expected
    end
end

local function GetRealType(value)
    if IsNaNValue(value) then
        return "nan"
    end
    if IsTypeInteger(value) then
        return "integer"
    end
    return type(value)
end

local function FormatExpected(expectedArray)
    return table.concat(expectedArray, ", ")
end

-- Builds a "Bad argument" message without raising. expected can be a string or string[].
---@param argumentIndex integer? The 1-based position of the argument (omit to exclude from message).
---@param expected string|string[] The display type name or an array of display type names.
---@param got string? The actual type string. If omitted, it is excluded from the message.
---@return string
function ErrorHandler:MakeArgumentError(argumentIndex, expected, got)
    local expectedStr = type(expected) == "table" and FormatExpected(expected) or expected
    local gotStr = got and (", got " .. got) or ""
    
    if argumentIndex then
        return string.format("Bad argument #%d: expected %s%s.", argumentIndex, expectedStr, gotStr)
    end

    return string.format("Bad argument: expected %s%s.", expectedStr, gotStr)
end

-- Asserts argument matches expected type. overwrite is a display alias for expected in the error
-- message (e.g. "table" + "Vec2" checks for table but reports "expected Vec2").
---@param argument any The argument to type-check.
---@param argumentIndex integer? The 1-based position of the argument in the calling function (used in the error message).
---@param expected string The real expected type: any Lua type string, "integer", or "nan".
---@param overwrite string? Display alias shown in the error message in place of expected.
function ErrorHandler:AssertArgument(argument, argumentIndex, expected, overwrite)
    if not TypeMatches(argument, expected) then
        error(self:MakeArgumentError(argumentIndex, overwrite or expected, GetRealType(argument)), 2)
    end
end

-- Asserts argument matches one of the expected types. overwriteArray[index] is a display alias for
-- expectedArray[index] in the error message; nil slots fall back to the real type name.
---@param argument any The argument to type-check.
---@param argumentIndex integer? The 1-based position of the argument in the calling function (used in the error message).
---@param expectedArray string[] List of real accepted types, e.g. {"integer", "string", "nan"}.
---@param overwriteArray string[]? Display aliases aligned by index with expectedArray. nil slots fall back to the real type name.
function ErrorHandler:AssertArgumentMulti(argument, argumentIndex, expectedArray, overwriteArray)
    for _, expected in ipairs(expectedArray) do
        if TypeMatches(argument, expected) then
            return
        end
    end

    local displayNames = {}
    for index, expected in ipairs(expectedArray) do
        displayNames[index] = (overwriteArray and overwriteArray[index]) or expected
    end

    error(self:MakeArgumentError(argumentIndex, displayNames, GetRealType(argument)), 2)
end

-- Asserts argument is not NaN. overwrite is a display alias shown in place of "NaN".
---@param argument number The number to check.
---@param argumentIndex integer? The 1-based position of the argument in the calling function (used in the error message).
---@param overwrite string? Display alias shown in the error message in place of "NaN".
function ErrorHandler:AssertNotNaN(argument, argumentIndex, overwrite)
    if IsNaNValue(argument) then
        if overwrite then
            error(self:MakeArgumentError(argumentIndex, overwrite, GetRealType(argument)), 2)
        elseif argumentIndex then
            error(string.format("Bad argument #%d: value must not be NaN.", argumentIndex), 2)
        else
            error("Bad argument: value must not be NaN.", 2)
        end
    end
end

-- Asserts a custom condition on argument. checker receives the argument and must return true to pass.
-- message is the error detail; argumentIndex prepends the standard "Bad argument #N: " prefix.
---@param argument any The argument to check.
---@param argumentIndex integer? The 1-based position of the argument in the calling function (used in the error message).
---@param checker fun(argument: any): boolean Returns true if the argument is valid.
---@param message string The error detail appended after the "Bad argument" prefix.
function ErrorHandler:AssertValue(argument, argumentIndex, checker, message)
    if not checker(argument) then
        if argumentIndex then
            error(string.format("Bad argument #%d: %s", argumentIndex, message), 2)
        else
            error(string.format("Bad argument: %s", message), 2)
        end
    end
end

-- Asserts a condition is false; if false, raises an error with optional argument index prefix.
---@param condition boolean The condition to check.
---@param argumentIndex integer? The 1-based position of the argument in the calling function (used in the error message).
---@param message string The error detail appended after the "Bad argument" prefix.
function ErrorHandler:AssertCondition(condition, argumentIndex, message)
    if condition then
        return
    end

    if argumentIndex then
        error(string.format("Bad argument #%d: %s", argumentIndex, message), 2)
    else
        error(string.format("Bad argument: %s", message), 2)
    end
end

-- Asserts self is a valid instance of the expected class by checking self.__type == expected.
---@param self any The self argument to validate.
---@param expected string The expected value of self.__type.
---@param hasMultipleArguments boolean? Whether the function that is calling this has multiple arguments or not. Defaults to false
function ErrorHandler:AssertSelf(self, expected, hasMultipleArguments)
    if type(self) ~= "table" or self.__type ~= expected then
        local got = type(self) == "table" and tostring(self.__type) or GetRealType(self)
        
        error(string.format("Bad argument%s: expected %s instance, got %s.", hasMultipleArguments and " #1" or "", expected, got), 2)
    end
end

print("Loaded Helper/ErrorHandler.lua")