---@class Internal.ReGui.GUIInterface.Class
local GUIInterface = {}
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
        ErrorHandler.AssertTableValue(node.nodeProperties, nil, "name", "string", path .. ".nodeProperties.name")
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
        ErrorHandler.AssertTableValue(node.coordinate, nil, "x", { "number" }, path .. ".coordinate.x")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "y", { "number" }, path .. ".coordinate.y")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "width", { "number" }, path .. ".coordinate.width")
        ErrorHandler.AssertTableValue(node.coordinate, nil, "height", { "number" }, path .. ".coordinate.height")
        ErrorHandler.AssertTableValue(node, nil, "controllers", "table", path .. ".controllers")
        ErrorHandler.AssertTableValue(node, nil, "children", "table", path .. ".children")

        for index, controller in ipairs(node.controllers) do
            local controllerPath = string.format("%s.controllers[%d]", path, index)
            ErrorHandler.AssertArgument(controller, nil, "table")
            ErrorHandler.AssertTableValue(controller, nil, "type", { "string" }, controllerPath .. ".type")

            if controller.type == "ControllerPosition" then
                ErrorHandler.AssertTableValue(controller, nil, "Coord", "table", controllerPath .. ".Coord")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "x", { "number" }, controllerPath .. ".Coord.x")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "y", { "number" }, controllerPath .. ".Coord.y")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "width", { "number" }, controllerPath .. ".Coord.width")
                ErrorHandler.AssertTableValue(controller.Coord, nil, "height", { "number" }, controllerPath .. ".Coord.height")
                ErrorHandler.AssertTableValue(controller, nil, "Position", "table", controllerPath .. ".Position")
                ErrorHandler.AssertTableValue(controller.Position, nil, "x", { "number" }, controllerPath .. ".Position.x")
                ErrorHandler.AssertTableValue(controller.Position, nil, "y", { "number" }, controllerPath .. ".Position.y")
                ErrorHandler.AssertTableValue(controller, nil, "Size", "table", controllerPath .. ".Size")
                ErrorHandler.AssertTableValue(controller.Size, nil, "x", { "number" }, controllerPath .. ".Size.x")
                ErrorHandler.AssertTableValue(controller.Size, nil, "y", { "number" }, controllerPath .. ".Size.y")
                ErrorHandler.AssertTableValue(controller, nil, "Function", "string", controllerPath .. ".Function")
                ErrorHandler.AssertTableValue(controller, nil, "Time", "number", controllerPath .. ".Time")
            elseif controller.type == "ControllerFadeAlpha" then
                ErrorHandler.AssertTableValue(controller, nil, "Alpha", "number", controllerPath .. ".Alpha")
                ErrorHandler.AssertTableValue(controller, nil, "Coef", "number", controllerPath .. ".Coef")
                ErrorHandler.AssertTableValue(controller, nil, "Enabled", "boolean", controllerPath .. ".Enabled")
            elseif controller.type == "ControllerEdgeHide" then
                ErrorHandler.AssertTableValue(controller, nil, "RemainPixels", { "number" }, controllerPath .. ".RemainPixels")
                ErrorHandler.AssertTableValue(controller, nil, "ShadowSize", { "number" }, controllerPath .. ".ShadowSize")
                ErrorHandler.AssertTableValue(controller, nil, "Time", { "number" }, controllerPath .. ".Time")
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
        ErrorHandler.AssertTableValue(contents, argumentIndex, "version", "number",  "version")
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
    local self = {}
    self.filePath = path
    self.data = result

    self.renderer = {
        needsRendering = true,
        renderPath = ""
    }

    ---@type Internal.ReGui.Widget.Object[]
    self.rootWidgets = {}

    for _, child in ipairs(self.data.data.children) do
        table.insert(self.rootWidgets, sm.regui.widgets.parseWidget(child, nil, self))
    end

    return setmetatable(self, GUIInterface)
end

function GUIInterface.newBlank()
    local self = {}
    self.filePath = nil

    return setmetatable(self, GUIInterface)
end

---@param self Internal.ReGui.GUIInterface.Object
function GUIInterface:render(prettify)
    ErrorHandler.AssertSelf(self, GUIInterface.__type, true)
    ErrorHandler.AssertArgument(prettify, 2, { "boolean", "nil" })

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

    local layout = sm.gui.createGuiFromLayout(filePath, true)
    layout:open()
end

sm.regui.guiinterface = GUIInterface

print("Loaded GUIInterface.lua")
