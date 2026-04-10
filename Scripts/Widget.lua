---@class Internal.ReGui.Widget.Class
local Widget = {}
Widget.__type = "ReGui.Widget"
Widget.__index = Widget
Widget.__tostring = CreateCustomTostringFunction(Widget.__type)

local GUI_INTERFACE_TYPE = "ReGui.GUIInterface"

---@param parent Internal.ReGui.Widget.Object
---@param child Internal.ReGui.Widget.Object
---@return integer?
local function FindChildIndex(parent, child)
    for index, value in pairs(parent.children) do
        if value == child then
            return index
        end
    end

    return nil
end

---@param widget Internal.ReGui.Widget.Object
---@param guiInterface Internal.ReGui.GUIInterface.Object?
local function ApplyGUIInterfaceRecursive(widget, guiInterface)
    widget.guiInterface = guiInterface

    for _, child in pairs(widget.children) do
        ApplyGUIInterfaceRecursive(child, guiInterface)
    end
end

---@param node Internal.ReGui.Meta.RelayoutFile.Child
---@param parent Internal.ReGui.Widget.Object?
---@param guiInterface Internal.ReGui.GUIInterface.Object?
function Widget.parseWidget(node, parent, guiInterface)
    ---@class Internal.ReGui.Widget.Object : Internal.ReGui.Widget.Class
    local self = {}
    self.nodeProperties = CloneTable(node.nodeProperties)
    self.properties = CloneTable(node.properties)
    self.userStrings = CloneTable(node.userStrings)
    self.controllers = CloneTable(node.controllers)
    self.coordinate = node.coordinate

    self.parent = parent
    self.guiInterface = guiInterface

    ---@type Internal.ReGui.Widget.Object[]
    self.children = {}
    for _, childNode in pairs(node.children) do
        local childWidget = Widget.parseWidget(childNode, self, guiInterface)
        table.insert(self.children, childWidget)
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

-- PARENT --

---@param self Internal.ReGui.Widget.Object
---@return Internal.ReGui.Widget.Object?
function Widget:getParent()
    ErrorHandler:AssertSelf(self, Widget.__type, true)

    return self.parent
end

---@param self Internal.ReGui.Widget.Object
---@param parent Internal.ReGui.Widget.Object?
function Widget:setParent(parent)
    ErrorHandler:AssertSelf(self, Widget.__type, true)

    ErrorHandler:AssertValue(parent, 2, function(value)
        return value == nil or (type(value) == "table" and value.__type == Widget.__type)
    end, "Expected ReGui.Widget instance or nil")

    ErrorHandler:AssertCondition(parent ~= self, 2, "Widget cannot be its own parent")

    if self.parent ~= nil then
        local currentIndex = FindChildIndex(self.parent, self)
        if currentIndex ~= nil then
            table.remove(self.parent.children, currentIndex)
        end
    end

    self.parent = parent

    if parent ~= nil and FindChildIndex(parent, self) == nil then
        table.insert(parent.children, self)
    end

    ApplyGUIInterfaceRecursive(self, parent and parent.guiInterface or nil)
end

---@param self Internal.ReGui.Widget.Object
---@return Internal.ReGui.GUIInterface.Object?
function Widget:getGUIInterface()
    ErrorHandler:AssertSelf(self, Widget.__type, true)

    return self.guiInterface
end

---@param self Internal.ReGui.Widget.Object
---@param guiInterface Internal.ReGui.GUIInterface.Object?
function Widget:setGUIInterface(guiInterface)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertValue(guiInterface, 2, function(value)
        return value == nil or (type(value) == "table" and value.__type == GUI_INTERFACE_TYPE)
    end, "Expected ReGui.GUIInterface instance or nil")

    ApplyGUIInterfaceRecursive(self, guiInterface)
end

-- RENDERING --

---@param self Internal.ReGui.Widget.Object
function Widget:renderWidget(indentationLevel, prettify)
    ErrorHandler:AssertSelf(self, Widget.__type, true)
    ErrorHandler:AssertArgumentMulti(indentationLevel, 2, { "number", "nil" })
    ErrorHandler:AssertArgumentMulti(prettify, 3, { "boolean", "nil" })

    indentationLevel = indentationLevel or 0

    prettify = type(prettify) == "boolean" and prettify or false

    local buffer = {}

    local function generateIndentation(level)
        return string.rep("    ", level)
    end

    local function renderMinimal()
        table.insert(buffer, "<Widget")

        table.insert(buffer, " ")
        table.insert(buffer, string.format("position=\"%d %d %d %d\"", self.coordinate.x, self.coordinate.y, self.coordinate.width, self.coordinate.height))

        if next(self.nodeProperties) then
            table.insert(buffer, " ")

            local fullString = {}
            for key, value in PredictablePairs(self.nodeProperties) do
                table.insert(fullString, string.format("%s=%q", key, value))
            end

            table.insert(buffer, table.concat(fullString, " "))
        end

        table.insert(buffer, ">")

        for key, value in PredictablePairs(self.properties) do
            table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
        end

        for _, value in PredictablePairs(self.children) do
            table.insert(buffer, value:renderWidget(indentationLevel + 1, prettify))
        end

        table.insert(buffer, "</Widget>")
    end

    local function renderPrettified()
        table.insert(buffer, generateIndentation(indentationLevel))
        table.insert(buffer, "<Widget")
        
        table.insert(buffer, " ")
        table.insert(buffer, string.format("position=\"%d %d %d %d\"", self.coordinate.x, self.coordinate.y, self.coordinate.width, self.coordinate.height))

        if next(self.nodeProperties) then
            table.insert(buffer, " ")

            local fullString = {}
            for key, value in PredictablePairs(self.nodeProperties) do
                table.insert(fullString, string.format("%s=%q", key, value))
            end

            table.insert(buffer, table.concat(fullString, " "))
        end

        table.insert(buffer, ">")

        for key, value in PredictablePairs(self.properties) do
            table.insert(buffer, "\n")
            table.insert(buffer, generateIndentation(indentationLevel + 1))
            table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
        end

        for _, value in PredictablePairs(self.children) do
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
