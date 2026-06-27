---@class Internal.ReGui.GUIInterface.Class
local GUIInterface = sm.regui.guiinterface or {}
GUIInterface.__type = "ReGui.GUIInterface"
GUIInterface.__index = GUIInterface
GUIInterface.__tostring = CreateCustomTostringFunction(GUIInterface.__type)

---@param contents Internal.ReGui.Meta.RelayoutFile
local function VerifyLayoutFile(contents, argumentIndex)
    local function VerifyNode(node, path)
        ErrorHandler.AssertArgument(node, nil, "table")
        ErrorHandler.AssertTableValue(node, nil, "nodeProperties", "table", path .. ".nodeProperties")
        ErrorHandler.AssertTableValue(node.nodeProperties, nil, "type", "string", path .. ".nodeProperties.type")
        ErrorHandler.AssertTableValue(node.nodeProperties, nil, "skin", "string", path .. ".nodeProperties.skin")
        ErrorHandler.AssertTableValue(node.nodeProperties, nil, "name", {"string", "nil"}, path .. ".nodeProperties.name")
        node.nodeProperties.name = node.nodeProperties.name or ""
        
        ErrorHandler.AssertTableValue(node, nil, "properties", "table", path .. ".properties")
        ErrorHandler.AssertTableValue(node, nil, "userStrings", "table", path .. ".userStrings")

        for key, value in pairs(node.properties) do
            ErrorHandler.AssertArgument(key, nil, "string")
            ErrorHandler.AssertArgument(value, nil, "string")
        end

        for key, value in pairs(node.userStrings) do
            ErrorHandler.AssertArgument(key, nil, "string")
            ErrorHandler.AssertArgument(value, nil, "string")
        end

        ErrorHandler.AssertTableValue(node, nil, "coordinate", "table", path .. ".coordinate")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "x", {"number"}, path .. ".coordinate.x")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "y", {"number"}, path .. ".coordinate.y")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "width", {"number"}, path .. ".coordinate.width")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "height", {"number"}, path .. ".coordinate.height")
        ErrorHandler.AssertTableValue(node, nil, "controllers", "table", path .. ".controllers")
        ErrorHandler.AssertTableValue(node, nil, "children", "table", path .. ".children")

        for index, controller in ipairs(node.controllers) do
            local controllerPath = string.format("%s.controllers[%d]", path, index)
            ErrorHandler.AssertArgument(controller, nil, "table")
            ErrorHandler.AssertTableValue(controller, nil, "type", {"string"}, controllerPath .. ".type")

            if controller.type == "ControllerPosition" then
                ErrorHandler.AssertTableValue(controller, nil, "Coord", "table", controllerPath .. ".Coord")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "x", {"number"}, controllerPath .. ".Coord.x")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "y", {"number"}, controllerPath .. ".Coord.y")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "width", {"number"}, controllerPath .. ".Coord.width")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "height", {"number"}, controllerPath .. ".Coord.height")
                ErrorHandler.AssertTableValue(controller, nil, "Position", "table", controllerPath .. ".Position")
                ErrorHandler.AssertTableValue(controller.Position, nil, "x", {"number"}, controllerPath .. ".Position.x")
                ErrorHandler.AssertTableValue(controller.Position, nil, "y", {"number"}, controllerPath .. ".Position.y")
                ErrorHandler.AssertTableValue(controller, nil, "Size", "table", controllerPath .. ".Size")
                ErrorHandler.AssertTableValue(controller.Size, nil, "x", {"number"}, controllerPath .. ".Size.x")
                ErrorHandler.AssertTableValue(controller.Size, nil, "y", {"number"}, controllerPath .. ".Size.y")
                ErrorHandler.AssertTableValue(controller, nil, "Function", "string", controllerPath .. ".Function")
                ErrorHandler.AssertTableValue(controller, nil, "Time", "number", controllerPath .. ".Time")
            elseif controller.type == "ControllerFadeAlpha" then
                ErrorHandler.AssertTableValue(controller, nil, "Alpha", "number", controllerPath .. ".Alpha")
                ErrorHandler.AssertTableValue(controller, nil, "Coef", "number", controllerPath .. ".Coef")
                ErrorHandler.AssertTableValue(controller, nil, "Enabled", "boolean", controllerPath .. ".Enabled")
            elseif controller.type == "ControllerEdgeHide" then
                ErrorHandler.AssertTableValue(controller, nil, "RemainPixels", {"number"}, controllerPath .. ".RemainPixels")
                ErrorHandler.AssertTableValue(controller, nil, "ShadowSize", {"number"}, controllerPath .. ".ShadowSize")
                ErrorHandler.AssertTableValue(controller, nil, "Time", {"number"}, controllerPath .. ".Time")
            else
                ErrorHandler.AssertCondition(false, nil, string.format("'%s.type': unknown controller type '%s'", controllerPath, controller.type))
            end
        end

        for index, child in ipairs(node.children) do
            VerifyNode(child, string.format("%s.children[%d]", path, index))
        end
    end

    local success, message = pcall(function()
        ErrorHandler.AssertArgument(contents, argumentIndex, "table")
        ErrorHandler.AssertTableValue(contents, argumentIndex, "version", "number", "version")
        ErrorHandler.AssertTableValue(contents, argumentIndex, "metadata", "table", "metadata")
        ErrorHandler.AssertTableValue(contents.metadata, argumentIndex, "screenWidth", "number", "metadata.screenWidth")
        ErrorHandler.AssertTableValue(contents.metadata, argumentIndex, "screenHeight", "number", "metadata.screenHeight")
        ErrorHandler.AssertTableValue(contents, argumentIndex, "data", "table", "data")
        ErrorHandler.AssertTableValue(contents.data, argumentIndex, "type", "string", "data.type")
        ErrorHandler.AssertCondition(contents.data.type == "Layout", argumentIndex, string.format("'%s': expected 'Layout', got '%s'", "data.type", contents.data.type))
        ErrorHandler.AssertTableValue(contents.data, argumentIndex, "version", "string", "data.version")
        ErrorHandler.AssertTableValue(contents.data, argumentIndex, "children", "table", "data.children")

        for index, child in ipairs(contents.data.children) do
            VerifyNode(child, string.format("root.data.children[%d]", index))
        end
    end)

    if not success then
        return false, message
    end

    return true
end

function GUIInterface.new(path)
    ErrorHandler.AssertArgument(path, 1, "string")
    ErrorHandler.AssertValue(path, 1, sm.json.fileExists, "File not found")

    ---@type boolean, Internal.ReGui.Meta.RelayoutFile
    local success, result = pcall(sm.json.open, path)
    ErrorHandler.AssertCondition(success, 1, "Failed to load layout file. ")

    local success, message = VerifyLayoutFile(result, 1)
    ErrorHandler.AssertCondition(success, 1, message)

    ---@class Internal.ReGui.GUIInterface.Object : Internal.ReGui.GUIInterface.Class
    local self = setmetatable({}, GUIInterface)
    self.filePath = path
    self.data = result
    self.toRealCoordinates = true

    self.renderer = {
        needsRendering = true,
        renderPath = ""
   }

    ---@type Internal.ReGui.Widget.Object[]
    self.rootWidgets = {}

    for _, child in ipairs(self.data.data.children) do
        table.insert(self.rootWidgets, sm.regui.widgets.parseWidget(child, nil, self))
    end

    self.activeInternalGui = nil ---@type GuiInterface?
    self.settings = nil ---@type GuiSettings?

    self.textManager = TextManager.new(self)

    self.commands = {}

    return self
end

function GUIInterface.newBlank()
    local screenWidth, screenHeight = GetMyGuiScreenSize()

    local self = setmetatable({}, GUIInterface)
    self.filePath = nil
    self.data = {
        version = 2,
        metadata = {
            screenWidth = screenWidth,
            screenHeight = screenHeight,
       },
        data = {
            type = "Layout",
            version = "3.2.0",
            children = {}
       }
   }
    self.toRealCoordinates = true

    self.renderer = {
        needsRendering = true,
        renderPath = ""
   }

    ---@type Internal.ReGui.Widget.Object[]
    self.rootWidgets = {}
    self.activeInternalGui = nil ---@type GuiInterface?
    self.settings = nil ---@type GuiSettings?

    self.textManager = TextManager.new(self)

    self.commands = {}

    return self
end

---@param self Internal.ReGui.GUIInterface.Object
---@return Internal.ReGui.TextManager.Object
function GUIInterface:getTextManager()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    return self.textManager
end

---@param self Internal.ReGui.GUIInterface.Object
---@return Internal.ReGui.GUIInterface.Object
function GUIInterface:clone()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    local clone = GUIInterface.newBlank()
    clone.data = CloneTable(self.data)
    clone.toRealCoordinates = self.toRealCoordinates
    clone.settings = self.settings or CloneTable(self.settings)
    clone.textManager = self.textManager:clone()
    clone.commands = CloneTable(self.commands)

    for _, widget in pairs(self.rootWidgets) do
        table.insert(clone.rootWidgets, widget:clone(clone))
    end

    ---@diagnostic disable-next-line: return-type-mismatch
    return clone
end

---@param self Internal.ReGui.GUIInterface.Object
function GUIInterface:render(prettify)
    ErrorHandler.AssertSelf(self, GUIInterface.__type, true)
    ErrorHandler.AssertArgument(prettify, 2, {"boolean", "nil"})

    prettify = type(prettify) == "boolean" and prettify or false

    local buffer = {}
    if prettify then
        table.insert(buffer, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
    end
    table.insert(buffer, "<MyGUI type=\"Layout\" version=\"" .. self.data.data.version .. "\">")

    if prettify then
        table.insert(buffer, "\n")
    end

    for _, value in pairs(self.rootWidgets) do
        table.insert(buffer, value:renderWidget(1, prettify))
    end

    if prettify then
        table.insert(buffer, "    <CodeGeneratorSettings/>\n")
    end
    table.insert(buffer, "</MyGUI>")

    return table.concat(buffer)
end

---@param self Internal.ReGui.GUIInterface.Object
function GUIInterface:open()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    local data = self:render(false)
    local hashedString = GenerateHashedString(data)

    local filePath = sm.regui.cache.generateCachePath(hashedString)
    sm.regui.cache.writeCachedFile(filePath, GenerateValidXMLFileForLayouts(data))

    self:close()
    
    self.activeInternalGui = sm.gui.createGuiFromLayout(filePath, true, self.settings)
    for _, command in pairs(self.commands) do
        self.activeInternalGui[command.name](self.activeInternalGui, unpack(command.arguments))
    end

    self.activeInternalGui:open()
end

---@param self Internal.ReGui.GUIInterface.Object
function GUIInterface:close()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    if self.activeInternalGui and sm.exists(self.activeInternalGui) then
        self.activeInternalGui:destroy()
        self.activeInternalGui = nil
    end
end

---@param self Internal.ReGui.GUIInterface.Object
function GUIInterface:destroy()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    self.commands = {}
    self:close()
end

---@param self Internal.ReGui.GUIInterface.Object
---@param widgetName string
---@param properties table<string, boolean|number|string>
function GUIInterface:setData(widgetName, properties)
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    ErrorHandler.AssertArgument(widgetName, 2, "string")
    ErrorHandler.AssertArgument(properties, 3, "table")

    local widget = self:findWidget(widgetName, true)
    ErrorHandler.AssertCondition(widget, 2, string.format("Widget '%s' not found", widgetName))

    for key, value in pairs(properties) do
        ErrorHandler.AssertArgument(key, nil, "string")
        ErrorHandler.AssertArgument(value, nil, {"boolean", "number", "string"})
    end

    for key, value in pairs(properties) do
        widget:setProperty(key, value)
    end
end

---@param self Internal.ReGui.GUIInterface.Object
function GUIInterface:isActive()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    return self.activeInternalGui and sm.exists(self.activeInternalGui) and self.activeInternalGui:isActive()
end

---@param self Internal.ReGui.GUIInterface.Object
---@return boolean
function GUIInterface:isAutoConversionToRealUnitsEnabled()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    return self.toRealCoordinates
end

---@param self Internal.ReGui.GUIInterface.Object
---@param value boolean
function GUIInterface:toggleAutomaticConversionToRealUnits(value)
    ErrorHandler.AssertSelf(self, GUIInterface.__type, true)
    ErrorHandler.AssertArgument(value, 2, "boolean")

    self.toRealCoordinates = value
end

---@param self Internal.ReGui.GUIInterface.Object
---@return ReGui.GuiSettings?
function GUIInterface:getSettings()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)

    return CloneTable(self.settings)
end

---@param self Internal.ReGui.GUIInterface.Object
---@param settings ReGui.GuiSettings?
function GUIInterface:setSettings(settings)
    ErrorHandler.AssertSelf(self, GUIInterface.__type, true)
    ErrorHandler.AssertArgument(settings, 2, {"table", "nil"})

    if not settings then
        self.settings = nil
        return
    end

    ErrorHandler.AssertTableValue(settings, 2, "isHud", {"boolean", "nil"})
    ErrorHandler.AssertTableValue(settings, 2, "isInteractive", {"boolean", "nil"})
    ErrorHandler.AssertTableValue(settings, 2, "needsCursor", {"boolean", "nil"})
    ErrorHandler.AssertTableValue(settings, 2, "hidesHotbar", {"boolean", "nil"})
    ErrorHandler.AssertTableValue(settings, 2, "isOverlapped", {"boolean", "nil"})
    ErrorHandler.AssertTableValue(settings, 2, "backgroundAlpha", {"number", "nil"})

    self.settings = CloneTable(settings)
end


---@param self Internal.ReGui.GUIInterface.Object
---@param widgetName string
---@param recursive boolean
---@return Internal.ReGui.Widget.Object?
function GUIInterface:findWidget(widgetName, recursive)
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    ErrorHandler.AssertArgument(widgetName, 2, "string")
    ErrorHandler.AssertArgument(recursive, 3, {"boolean", "nil"})

    for _, widget in pairs(self.rootWidgets) do
        if widget:getName() == widgetName then
            return widget
        end

        if recursive then
            local foundWidget = widget:findWidget(widgetName, true)
            if foundWidget then
                return foundWidget
            end
        end
    end

    return nil
end

---@param self Internal.ReGui.GUIInterface.Object
---@return Internal.ReGui.Widget.Object[]
function GUIInterface:getRootWidgets()
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    return self.rootWidgets
end

---@param self Internal.ReGui.GUIInterface.Object
---@param widgetName string
---@param widgetType string?
---@param widgetSkin string?
---@return Internal.ReGui.Widget.Object
function GUIInterface:createWidget(widgetName, widgetType, widgetSkin)
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    ErrorHandler.AssertArgument(widgetName, 2, "string")
    ErrorHandler.AssertArgument(widgetType, 3, {"string", "nil"})
    ErrorHandler.AssertArgument(widgetSkin, 4, {"string", "nil"})

    local widgetData = {
        nodeProperties = {
            name = widgetName,
            type = widgetType or "Widget",
            skin = widgetSkin or "PanelEmpty"
       },
        properties = {},
        userStrings = {},
        coordinate = {
            x = 0,
            y = 0,
            width = 100,
            height = 100
       },
        controllers = {},
        children = {}
   }

    local widgetObject = sm.regui.widgets.parseWidget(widgetData, nil, self)
    table.insert(self.rootWidgets, widgetObject)

    return widgetObject
end

---@param self Internal.ReGui.GUIInterface.Object
---@param widgetName string
---@param ... any
function GUIInterface:setText(widgetName, ...)
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    ErrorHandler.AssertArgument(widgetName, 2, "string")
    ErrorHandler.AssertArgument(text, 3, "string")

    local widget = self:findWidget(widgetName, true)
    if not widget then
        sm.log.warning(string.format("Failed to set text for widget '%s': widget not found", widgetName))
        return
    end

    widget:setText(...)
end

---@param self Internal.ReGui.GUIInterface.Object
---@param widgetName string
---@return string?
function GUIInterface:getText(widgetName)
    ErrorHandler.AssertSelf(self, GUIInterface.__type)
    ErrorHandler.AssertArgument(widgetName, 2, "string")

    local widget = self:findWidget(widgetName, true)
    if not widget then
        sm.log.warning(string.format("Failed to get text for widget '%s': widget not found", widgetName))
        return ""
    end

    return widget:getText()
end

sm.regui.guiinterface = GUIInterface

print("Loaded GUIInterface.lua")
