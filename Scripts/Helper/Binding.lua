---@alias Internal.ReGui.PlaceHolder.PlaceHolder table
---@alias Internal.ReGui.PlaceHolder.IgnoreCallArguments table


local BindingClassType = "ReGui.PlaceHolder.BindingClass"
local PlaceHolderType = "ReGui.PlaceHolder.PlaceHolder"
local IgnoreCallArgumentsType = "ReGui.PlaceHolder.IgnoreCallArguments"

---@class Internal.ReGui.PlaceHolder.BindingClass
Binding = {}
Binding.__type = BindingClassType

do
    ---@type metatable
    local metatable = {}
    metatable.__name = IgnoreCallArgumentsType
    metatable.__type = IgnoreCallArgumentsType
    metatable.__tostring = CreateCustomTostringFunction(IgnoreCallArgumentsType)
    metatable.__index = function() end
    metatable.__newindex = function() end
    metatable.__metatable = "locked"

    ---@type Internal.ReGui.PlaceHolder.IgnoreCallArguments
    Binding._IGNORE_CALL_ARGUMENTS = setmetatable({}, metatable)
end

local placeholderIndex = {}
local placeholderCount = 0

local function IsPlaceholder(value)
    if type(value) ~= "table" then
        return false
    end

    local metatable = getmetatable(value)
    if metatable ~= "locked" then
        return false
    end

    return rawget(value, "__type") == PlaceHolderType
end

local function IsIgnoreArgs(value)
    if type(value) ~= "table" then
        return false
    end

    local metatable = getmetatable(value)
    if metatable ~= "locked" then
        return false
    end

    return rawget(value, "__type") == IgnoreCallArgumentsType
end

local function RegisterPlaceholder(placeholder)
    placeholderCount = placeholderCount + 1
    placeholderIndex[placeholder] = placeholderCount

    return placeholder
end

---Creates a new positional placeholder for use in CreateBind.
---Placeholders are resolved in order: _1 maps to the first call-time argument, _2 to the second, etc.
---@return Internal.ReGui.PlaceHolder.PlaceHolder
function Binding:CreatePlaceholder()
    ErrorHandler:AssertSelf(self, BindingClassType)

    ---@type metatable
    local metatable = {}
    metatable.__name = PlaceHolderType
    metatable.__type = PlaceHolderType
    metatable.__tostring = CreateCustomTostringFunction(PlaceHolderType)
    metatable.__index = function() end
    metatable.__newindex = function() end
    metatable.__metatable = "locked"

    return RegisterPlaceholder(setmetatable({}, metatable))
end

---Binds a function with pre-set arguments and optional placeholders.
---Placeholders (Binding._1, _2, ...) are replaced with call-time arguments by position.
---Pass Binding.IgnoreArgs as the first bound argument to discard all call-time arguments entirely.
---@param func function — the function to bind
---@param ... any bound arguments, placeholders, or Binding.IgnoreArgs
---@return function
function Binding:CreateBind(func, ...)
    ErrorHandler:AssertSelf(self, BindingClassType, true)
    ErrorHandler:AssertArgument(func, 2, "function")

    local boundArguments = { ... }
    local boundCount = select("#", ...)

    local ignoreCallArgs = boundCount >= 1 and IsIgnoreArgs(boundArguments[1])

    return function(...)
        local resolved = {}

        if ignoreCallArgs then
            for index = 2, boundCount do
                resolved[index - 1] = boundArguments[index]
            end

            return func(unpack(resolved, 1, boundCount - 1))
        end

        local callArguments = { ... }
        for index = 1, boundCount do
            local boundedArgument = boundArguments[index]

            if IsPlaceholder(boundedArgument) then
                local holderIndex = placeholderIndex[boundedArgument]
                resolved[index] = callArguments[holderIndex]
            else
                resolved[index] = boundedArgument
            end
        end

        return func(unpack(resolved, 1, boundCount))
    end
end

Binding._1 = Binding:CreatePlaceholder()
Binding._2 = Binding:CreatePlaceholder()
Binding._3 = Binding:CreatePlaceholder()
Binding._4 = Binding:CreatePlaceholder()
Binding._5 = Binding:CreatePlaceholder()

print("Loaded Helper/Binding.lua")