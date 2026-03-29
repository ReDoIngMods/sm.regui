---@class Internal.ReGui.Widget.Class
local Widget = {}
Widget.__type = "ReGui.Widget"
Widget.__index = Widget
Widget.__tostring = CreateCustomTostringFunction(Widget.__type)

---@param node Internal.ReGui.Meta.RelayoutFile.Child
function Widget.parseWidget(node)
    ---@class Internal.ReGui.Widget.Object : Internal.ReGui.Widget.Class
    local self = {}
    self.nodeProperties = CloneTable(node.nodeProperties)
    self.properties = CloneTable(node.properties)
    self.userStrings = CloneTable(node.userStrings)
    self.controllers = CloneTable(node.controllers)
    
    ---@type Internal.ReGui.Widget.Object[]
    self.children = {}
    for _, childNode in ipairs(node.children) do
        table.insert(self.children, Widget.parseWidget(childNode))
    end

    return setmetatable(self, Widget)
end

-- USER STRINGS --

---@param self Internal.ReGui.Widget.Object
function Widget:getUserString(key)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgument(key, 2, "string")

    return self.userStrings[key]
end

---@param self Internal.ReGui.Widget.Object
function Widget:setUserString(key, value)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgument(key, 2, "string")
    ErrorHandler:AssertArgument(value, 3, "string")

    self.userStrings[key] = value
end

---@param self Internal.ReGui.Widget.Object
function Widget:getAllUserStringKeys()
    ErrorHandler:AssertSelf(self, Widget.__type, true)

    local keys = {}
    for key in pairs(self.userStrings) do
        table.insert(keys, key)
    end

    return keys
end

-- NODE PROPERTIES --

---@param self Internal.ReGui.Widget.Object
function Widget:getNodeProperty(key)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgument(key, 2, "string")

    return self.nodeProperties[key]
end

---@param self Internal.ReGui.Widget.Object
function Widget:setNodeProperty(key, value)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgument(key, 2, "string")
    ErrorHandler:AssertArgument(value, 3, "string")

    self.nodeProperties[key] = value
end

---@param self Internal.ReGui.Widget.Object
function Widget:getAllNodePropertyKeys()
    ErrorHandler:AssertSelf(self, Widget.__type, true)

    local keys = {}
    for key in pairs(self.nodeProperties) do
        table.insert(keys, key)
    end

    return keys
end

-- PROPERTIES --

---@param self Internal.ReGui.Widget.Object
function Widget:getProperty(key)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgument(key, 2, "string")

    return self.properties[key]
end

---@param self Internal.ReGui.Widget.Object
function Widget:setProperty(key, value)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgument(key, 2, "string")
    ErrorHandler:AssertArgument(value, 3, "string")

    self.properties[key] = value
end

---@param self Internal.ReGui.Widget.Object
function Widget:getAllPropertyKeys()
    ErrorHandler:AssertSelf(self, Widget.__type, true)

    local keys = {}
    for key in pairs(self.properties) do
        table.insert(keys, key)
    end

    return keys
end

-- RENDERING --

---@param self Internal.ReGui.Widget.Object
function Widget:renderWidget(indentationLevel, prettify)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgumentMulti(indentationLevel, 2, {"number", "nil"})
    ErrorHandler:AssertArgumentMulti(prettify, 3, {"boolean", "nil"})

    indentationLevel = indentationLevel or 0

    prettify = type(prettify) == "boolean" and prettify or false

    local buffer = {}

    local function generateIndentation(level)
        return string.rep("    ", level)
    end

    local function renderMinimal()
        table.insert(buffer, "<Widget")

        if next(self.nodeProperties) then
            table.insert(buffer, " ")

            local fullString = {}
            for key, value in pairs(self.nodeProperties) do
                table.insert(fullString, string.format("%s=%q", key, value))
            end

            table.insert(buffer, table.concat(fullString, " "))
        end

        table.insert(buffer, ">")

        for key, value in pairs(self.properties) do
            table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
        end

        for _, value in pairs(self.children) do
            table.insert(buffer, value:renderWidget(indentationLevel + 1, prettify))
        end

        table.insert(buffer, "</Widget>")
    end

    local function renderPrettified()
        table.insert(buffer, generateIndentation(indentationLevel))
        table.insert(buffer, "<Widget")

        if next(self.nodeProperties) then
            table.insert(buffer, " ")

            local fullString = {}
            for key, value in pairs(self.nodeProperties) do
                table.insert(fullString, string.format("%s=%q", key, value))
            end

            table.insert(buffer, table.concat(fullString, " "))
        end

        table.insert(buffer, ">")

        for key, value in pairs(self.properties) do
            table.insert(buffer, "\n")
            table.insert(buffer, generateIndentation(indentationLevel + 1))
            table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
        end

        for _, value in pairs(self.children) do
            table.insert(buffer, "\n")
            table.insert(buffer, value:renderWidget(indentationLevel + 1, prettify))
        end

        table.insert(buffer, "\n")
        table.insert(buffer, generateIndentation(indentationLevel))
        table.insert(buffer, "</Widget>\n")
    end

    if prettify then
        renderPrettified()
    else
        renderMinimal()
    end

    return table.concat(buffer)
end

sm.regui.widgets = Widget

print("Loaded Widget.lua")