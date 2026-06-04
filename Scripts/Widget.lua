---@class Internal.ReGui.Widget.Class
local Widget = {}
Widget.__type = "ReGui.Widget"
Widget.__index = function (tbl, index)
    local isDeleted = rawget(tbl, "isDeleted")
    if isDeleted then
        error(string.format("Attempt to access %s on deleted widget", tostring(index)), 2)
    end

    return Widget[index]
end
Widget.__tostring = CreateCustomTostringFunction(Widget.__type)

local VALID_WIDGET_TYPES = {
    ["Button"] = true,
    ["Canvas"] = true,
    ["ComboBox"] = true,
    ["DDContainer"] = true,
    ["EditBox"] = true,
    ["ItemBox"] = true,
    ["ListBox"] = true,
    ["MenuBar"] = true,
    ["MultiListBox"] = true,
    ["PopupMenu"] = true,
    ["ProgressBar"] = true,
    ["ScrollBar"] = true,
    ["ScrollView"] = true,
    ["ImageBox"] = true,
    ["TextBox"] = true,
    ["TabControl"] = true,
    ["Widget"] = true,
    ["Window"] = true,
    ["StrangeButton"] = true
}

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
    local self = setmetatable({}, Widget)
    self.nodeProperties = CloneTable(node.nodeProperties) ---@type PropertyTable
    self.properties = CloneTable(node.properties) ---@type PropertyTable
    self.userStrings = CloneTable(node.userStrings) ---@type PropertyTable
    self.controllers = CloneTable(node.controllers) ---@type Internal.ReGui.Meta.RelayoutFile.Controller[]
    self.coordinate = CloneTable(node.coordinate) ---@type Internal.ReGui.Meta.RelayoutFile.Child.Coordinate

    self.parent = parent
    self.guiInterface = guiInterface

    self.nodeProperties.name = self.nodeProperties.name or ""
    self.nodeProperties.skin = self.nodeProperties.skin or "PanelEmpty"
    self.nodeProperties.type = self.nodeProperties.type or "Widget"

    if not VALID_WIDGET_TYPES[self.nodeProperties.type] then
        warn(string.format("Widget '%s' has invalid type '%s', defaulting to 'Widget'", self.nodeProperties.name, self.nodeProperties.type))
        self.nodeProperties.type = "Widget"
    end

    ---@type Internal.ReGui.Widget.Object[]
    self.children = {}
    for _, childNode in pairs(node.children) do
        table.insert(self.children, Widget.parseWidget(childNode, self, guiInterface))
    end

    return self
end

-- CLONING & DELETION --

---@param self Internal.ReGui.Widget.Object
---@return Internal.ReGui.Widget.Object
function Widget:clone()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    local clone = Widget.parseWidget({
        nodeProperties = CloneTable(self.nodeProperties),
        properties = CloneTable(self.properties),
        userStrings = CloneTable(self.userStrings),
        controllers = CloneTable(self.controllers),
        coordinate = CloneTable(self.coordinate),
        children = {}
    }, nil, nil)

    for _, child in pairs(self.children) do
        local childClone = child:clone()
        childClone:setParent(clone)
    end

    return clone
end

---@param self Internal.ReGui.Widget.Object
function Widget:destroy()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    self:setParent(nil)
    self:setGUIInterface(nil)
    self.isDeleted = true

    for _, child in pairs(self.children) do
        child:destroy()
    end

    self.children = {}
end

-- USER STRINGS --

---@param self Internal.ReGui.Widget.Object
function Widget:getUserString(key)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(key, 2, "string")

    return self.userStrings[key]
end

---@param self Internal.ReGui.Widget.Object
function Widget:setUserString(key, value)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(key, 2, "string")
    ErrorHandler.AssertArgument(value, 3, "string")

    self.userStrings[key] = value
end

---@param self Internal.ReGui.Widget.Object
function Widget:getAllUserStringKeys()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    local keys = {}
    for key in pairs(self.userStrings) do
        table.insert(keys, key)
    end

    return keys
end

-- NODE PROPERTIES --

---@param self Internal.ReGui.Widget.Object
function Widget:getNodeProperty(key)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(key, 2, "string")

    return self.nodeProperties[key]
end

---@param self Internal.ReGui.Widget.Object
function Widget:setNodeProperty(key, value)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(key, 2, "string")
    ErrorHandler.AssertArgument(value, 3, "string")

    self.nodeProperties[key] = value
end

---@param self Internal.ReGui.Widget.Object
function Widget:getAllNodePropertyKeys()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    local keys = {}
    for key in pairs(self.nodeProperties) do
        table.insert(keys, key)
    end

    return keys
end

-- PROPERTIES --

---@param self Internal.ReGui.Widget.Object
function Widget:getProperty(key)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(key, 2, "string")

    return self.properties[key]
end

---@param self Internal.ReGui.Widget.Object
function Widget:setProperty(key, value)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(key, 2, "string")
    ErrorHandler.AssertArgument(value, 3, "string")

    self.properties[key] = value
end

---@param self Internal.ReGui.Widget.Object
function Widget:getAllPropertyKeys()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

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
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    return self.parent
end

---@param self Internal.ReGui.Widget.Object
---@param parent Internal.ReGui.Widget.Object?
function Widget:setParent(parent)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(parent, 2, { "ReGui.Widget", "nil" })
    ErrorHandler.AssertCondition(parent ~= self, 2, "Widget cannot be its own parent")

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
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    return self.guiInterface
end

---@param self Internal.ReGui.Widget.Object
---@param guiInterface Internal.ReGui.GUIInterface.Object?
function Widget:setGUIInterface(guiInterface)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(guiInterface, 2, { "ReGui.GUIInterface", "nil" })

    ApplyGUIInterfaceRecursive(self, guiInterface)
end

-- BASIC NODE PROPERTIES --

---@param self Internal.ReGui.Widget.Object
---@return string name
function Widget:getName()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    
    ---@diagnostic disable-next-line: return-type-mismatch
    return self.nodeProperties.name
end

---@param self Internal.ReGui.Widget.Object
---@return string skin
function Widget:getSkin()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    
    ---@diagnostic disable-next-line: return-type-mismatch
    return self.nodeProperties.skin
end

---@param self Internal.ReGui.Widget.Object
---@return string type
function Widget:getType()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    
    ---@diagnostic disable-next-line: return-type-mismatch
    return self.nodeProperties.type
end

---@param self Internal.ReGui.Widget.Object
---@param name string
function Widget:setName(name)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(name, 2, "string")
    
    self.nodeProperties.name = name
end

---@param self Internal.ReGui.Widget.Object
---@param skin string
function Widget:setSkin(skin)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(skin, 2, "string")
    
    self.nodeProperties.skin = skin
end

---@param self Internal.ReGui.Widget.Object
---@param type string
function Widget:setType(type)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(type, 2, "string")
    ErrorHandler.AssertCondition(VALID_WIDGET_TYPES[type] == true, 2, "Invalid widget type: " .. type)

    self.nodeProperties.type = type
end

-- WIDGET HIERARCHY --

---@param self Internal.ReGui.Widget.Object
---@param name string
---@param recursive boolean
---@return Internal.ReGui.Widget.Object?
function Widget:findWidget(name, recursive)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(name, 2, "string")
    ErrorHandler.AssertArgument(recursive, 3, { "boolean", "nil" })

    for _, child in pairs(self.children) do
        if child:getName() == name then
            return child
        end
        
        if recursive then
            local foundInChild = child:findWidget(name, true)
            if foundInChild then
                return foundInChild
            end
        end
    end

    return nil
end

-- PIXEL POSITION/SIZE --

---@param self Internal.ReGui.Widget.Object
---@return integer
---@return integer
function Widget:getPosition()
    ErrorHandler.AssertSelf(self, Widget.__type)

    return self.coordinate.x, self.coordinate.y
end

---@param self Internal.ReGui.Widget.Object
---@return integer
---@return integer
function Widget:getSize()
    ErrorHandler.AssertSelf(self, Widget.__type)

    return self.coordinate.width, self.coordinate.height
end

---@param self Internal.ReGui.Widget.Object
---@param x integer
---@param y integer
function Widget:setPosition(x, y)
    ErrorHandler.AssertSelf(self, Widget.__type)
    ErrorHandler.AssertArgument(x, 2, "number")
    ErrorHandler.AssertArgument(y, 3, "number")

    self.coordinate.x = x
    self.coordinate.y = y
end

---@param self Internal.ReGui.Widget.Object
---@param width integer
---@param height integer
function Widget:setSize(width, height)
    ErrorHandler.AssertSelf(self, Widget.__type)
    ErrorHandler.AssertArgument(width, 2, "number")
    ErrorHandler.AssertArgument(height, 3, "number")

    self.coordinate.width = width
    self.coordinate.height = height
end

-- REAL UNITS POSITION/SIZE --

---@param self Internal.ReGui.Widget.Object
---@return number
---@return number
function Widget:getPositionReal()
    local screenWidth = self.guiInterface.data.metadata.screenWidth
    local screenHeight = self.guiInterface.data.metadata.screenHeight
    ErrorHandler.AssertSelf(self, Widget.__type)

    local x, y = self:getPosition()
    local parent = self.parent

    if parent then
        local pw, ph = parent:getSize()
        pw = pw ~= 0 and pw or 1
        ph = ph ~= 0 and ph or 1
        return x / pw, y / ph
    end

    screenWidth = (screenWidth ~= 0 and screenWidth) or 1
    screenHeight = (screenHeight ~= 0 and screenHeight) or 1

    return x / screenWidth, y / screenHeight
end

---@param self Internal.ReGui.Widget.Object
---@return number
---@return number
function Widget:getSizeReal()
    local screenWidth = self.guiInterface.data.metadata.screenWidth
    local screenHeight = self.guiInterface.data.metadata.screenHeight
    ErrorHandler.AssertSelf(self, Widget.__type)

    local w, h = self:getSize()
    local parent = self.parent

    if parent then
        local pw, ph = parent:getSize()
        pw = pw ~= 0 and pw or 1
        ph = ph ~= 0 and ph or 1
        return w / pw, h / ph
    end

    screenWidth = (screenWidth ~= 0 and screenWidth) or 1
    screenHeight = (screenHeight ~= 0 and screenHeight) or 1

    return w / screenWidth, h / screenHeight
end

---@param self Internal.ReGui.Widget.Object
---@param rx number
---@param ry number
function Widget:setPositionReal(rx, ry)
    ErrorHandler.AssertSelf(self, Widget.__type)
    ErrorHandler.AssertArgument(rx, 2, "number")
    ErrorHandler.AssertArgument(ry, 3, "number")

    local parent = self.parent
    if parent then
        local pw, ph = parent:getSize()
        pw = pw ~= 0 and pw or 1
        ph = ph ~= 0 and ph or 1

        local x = math.floor(rx * pw + 0.5)
        local y = math.floor(ry * ph + 0.5)

        self:setPosition(x, y)
        return
    end

    local screenWidth = self.guiInterface and self.guiInterface.data.metadata.screenWidth or 1
    local screenHeight = self.guiInterface and self.guiInterface.data.metadata.screenHeight or 1
    screenWidth = (screenWidth ~= 0 and screenWidth) or 1
    screenHeight = (screenHeight ~= 0 and screenHeight) or 1

    local x = math.floor(rx * screenWidth + 0.5)
    local y = math.floor(ry * screenHeight + 0.5)

    self:setPosition(x, y)
end

---@param self Internal.ReGui.Widget.Object
---@param rw number
---@param rh number
function Widget:setSizeReal(rw, rh)
    ErrorHandler.AssertSelf(self, Widget.__type)
    ErrorHandler.AssertArgument(rw, 2, "number")
    ErrorHandler.AssertArgument(rh, 3, "number")

    local parent = self.parent
    if parent then
        local pw, ph = parent:getSize()
        pw = pw ~= 0 and pw or 1
        ph = ph ~= 0 and ph or 1

        local w = math.floor(rw * pw + 0.5)
        local h = math.floor(rh * ph + 0.5)

        self:setSize(w, h)
        return
    end

    local screenWidth = self.guiInterface and self.guiInterface.data.metadata.screenWidth or 1
    local screenHeight = self.guiInterface and self.guiInterface.data.metadata.screenHeight or 1
    screenWidth = (screenWidth ~= 0 and screenWidth) or 1
    screenHeight = (screenHeight ~= 0 and screenHeight) or 1

    local w = math.floor(rw * screenWidth + 0.5)
    local h = math.floor(rh * screenHeight + 0.5)

    self:setSize(w, h)
end

-- RENDERING --


---@param self Internal.ReGui.Widget.Object
function Widget:renderWidget(indentationLevel, prettify)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(indentationLevel, 2, { "number", "nil" })
    ErrorHandler.AssertArgument(prettify, 3, { "boolean", "nil" })

    indentationLevel = indentationLevel or 0

    prettify = type(prettify) == "boolean" and prettify or false

    self.nodeProperties.name = self.nodeProperties.name or ""
    self.nodeProperties.skin = self.nodeProperties.skin or "PanelEmpty"
    self.nodeProperties.type = self.nodeProperties.type or "Widget"

    if not VALID_WIDGET_TYPES[self.nodeProperties.type] then
        warn(string.format("Widget '%s' has invalid type '%s', defaulting to 'Widget'", self.nodeProperties.name, self.nodeProperties.type))
        self.nodeProperties.type = "Widget"
    end

    local buffer = {}

    local function generateIndentation(level)
        return string.rep("    ", level)
    end

    local function insertCoordinates()
        local useRealCoordinates = self.guiInterface and self.guiInterface:isAutoConversionToRealUnitsEnabled()
        if useRealCoordinates then
            -- TODO
            local realPositionX, realPositionY = self:getPositionReal()
            local realSizeX, realSizeY = self:getSizeReal()

            table.insert(buffer, string.format("position_real=\"%.3f %.3f %.3f %.3f\"", realPositionX, realPositionY, realSizeX, realSizeY))
            --table.insert(buffer, string.format("position=\"%d %d %d %d\"", self.coordinate.x, self.coordinate.y, self.coordinate.width, self.coordinate.height))
        else
            table.insert(buffer, string.format("position=\"%d %d %d %d\"", self.coordinate.x, self.coordinate.y, self.coordinate.width, self.coordinate.height))
        end
    end

    local function renderMinimal()
        table.insert(buffer, "<Widget")

        table.insert(buffer, " ")
        insertCoordinates()

        table.insert(buffer, " ")
        
        local fullString = {}
        for key, value in PredictablePairs(self.nodeProperties) do
            table.insert(fullString, string.format("%s=%q", key, value))
        end

        table.insert(buffer, table.concat(fullString, " "))
        table.insert(buffer, ">")

        for key, value in PredictablePairs(self.properties) do
            table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
        end

        for _, controller in PredictablePairs(self.controllers) do
            table.insert(buffer, "<Controller ")
            table.insert(buffer, "type=")
            table.insert(buffer, string.format("%q", controller.type))
            table.insert(buffer, ">")

            for key, value in PredictablePairs(controller) do
                if key ~= "type" then
                    table.insert(buffer, generateIndentation(indentationLevel + 2))
                    table.insert(buffer, string.format("<Property key=%q value=", key))

                    if key == "Coord" then
                        table.insert(buffer, string.format("\"%d %d %d %d\"", value.x, value.y, value.width, value.height))
                    elseif key == "Position" or key == "Size" then
                        table.insert(buffer, string.format("\"%d %d\"", value.x, value.y))
                    else
                        table.insert(buffer, string.format("%q", value))
                    end

                    table.insert(buffer, "/>")
                end
            end

            table.insert(buffer, "</Controller>")
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
        insertCoordinates()

        table.insert(buffer, " ")

        local fullString = {}
        for key, value in PredictablePairs(self.nodeProperties) do
            table.insert(fullString, string.format("%s=%q", key, value))
        end

        table.insert(buffer, table.concat(fullString, " "))
        table.insert(buffer, ">")

        for key, value in PredictablePairs(self.properties) do
            table.insert(buffer, "\n")
            table.insert(buffer, generateIndentation(indentationLevel + 1))
            table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
        end

        for _, controller in PredictablePairs(self.controllers) do
            table.insert(buffer, "\n")
            table.insert(buffer, generateIndentation(indentationLevel + 1))
            table.insert(buffer, "<Controller ")
            table.insert(buffer, "type=")
            table.insert(buffer, string.format("%q", controller.type))
            table.insert(buffer, ">")
            table.insert(buffer, "\n")

            for key, value in PredictablePairs(controller) do
                if key ~= "type" then
                    table.insert(buffer, generateIndentation(indentationLevel + 2))
                    table.insert(buffer, string.format("<Property key=%q value=", key))

                    if key == "Coord" then
                        table.insert(buffer, string.format("\"%d %d %d %d\"", value.x, value.y, value.width, value.height))
                    elseif key == "Position" or key == "Size" then
                        table.insert(buffer, string.format("\"%d %d\"", value.x, value.y))
                    else
                        table.insert(buffer, string.format("%q", value))
                    end

                    table.insert(buffer, "/>")
                end
            end

            table.insert(buffer, "\n")
            table.insert(buffer, generateIndentation(indentationLevel + 1))
            table.insert(buffer, "</Controller>")
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
