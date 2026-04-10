---@class Internal.ReGui.GUIInterface.Class
local GUIInterface = {}
GUIInterface.__type = "ReGui.GUIInterface"
GUIInterface.__index = GUIInterface
GUIInterface.__tostring = CreateCustomTostringFunction(GUIInterface.__type)

---@param contents Internal.ReGui.Meta.RelayoutFile
local function VerifyLayoutFile(contents)
    local function MakeError(path, expected, actual)
        return false, string.format("'%s': expected %s, got %s", path, expected, type(actual))
    end

    local function VerifyNode(node, path)
        if type(node) ~= "table" then
            return MakeError(path, "table", node)
        end

        local nodeProperties = node.nodeProperties
        if type(nodeProperties) ~= "table" then
            return MakeError(path .. ".nodeProperties", "table", nodeProperties)
        end

        if type(nodeProperties.type) ~= "string" then
            return MakeError(path .. ".nodeProperties.type", "string", nodeProperties.type)
        end

        if type(nodeProperties.skin) ~= "string" then
            return MakeError(path .. ".nodeProperties.skin", "string", nodeProperties.skin)
        end

        if type(nodeProperties.name) ~= "string" then
            return MakeError(path .. ".nodeProperties.name", "string", nodeProperties.name)
        end

        for _, mapKey in ipairs({ "properties", "userStrings" }) do
            local map = node[mapKey]
            if type(map) ~= "table" then
                return MakeError(path .. "." .. mapKey, "table", map)
            end

            for key, value in pairs(map) do
                if type(key) ~= "string" then
                    return MakeError(path .. "." .. mapKey .. ".<key>", "string", key)
                end

                if type(value) ~= "string" then
                    return MakeError(path .. "." .. mapKey .. "." .. key, "string", value)
                end
            end
        end

        local coordinate = node.coordinate
        if type(coordinate) ~= "table" then
            return MakeError(path .. ".coordinate", "table", coordinate)
        end

        for _, field in ipairs({ "x", "y", "width", "height" }) do
            if type(coordinate[field]) ~= "number" then
                return MakeError(path .. ".coordinate." .. field, "number", coordinate[field])
            end
        end

        if type(node.controllers) ~= "table" then
            return MakeError(path .. ".controllers", "table", node.controllers)
        end

        for index, controller in ipairs(node.controllers) do
            local controllerPath = string.format("%s.controllers[%d]", path, index)
            if type(controller) ~= "table" then
                return MakeError(controllerPath, "table", controller)
            end

            if type(controller.type) ~= "string" then
                return MakeError(controllerPath .. ".type", "string", controller.type)
            end

            if controller.type == "ControllerPosition" then
                local coord = controller.Coord
                if type(coord) ~= "table" then
                    return MakeError(controllerPath .. ".Coord", "table", coord)
                end

                for _, field in ipairs({ "x", "y", "width", "height" }) do
                    if type(coord[field]) ~= "number" then
                        return MakeError(controllerPath .. ".Coord." .. field, "number", coord[field])
                    end
                end

                for _, vecName in ipairs({ "Position", "Size" }) do
                    local vector = controller[vecName]
                    if type(vector) ~= "table" then
                        return MakeError(controllerPath .. "." .. vecName, "table", vector)
                    end

                    if type(vector.x) ~= "number" then
                        return MakeError(controllerPath .. "." .. vecName .. ".x", "number", vector.x)
                    end

                    if type(vector.y) ~= "number" then
                        return MakeError(controllerPath .. "." .. vecName .. ".y", "number", vector.y)
                    end
                end

                if type(controller.Function) ~= "string" then
                    return MakeError(controllerPath .. ".Function", "string", controller.Function)
                end

                if type(controller.Time) ~= "number" then
                    return MakeError(controllerPath .. ".Time", "number", controller.Time)
                end
            elseif controller.type == "ControllerFadeAlpha" then
                if type(controller.Alpha) ~= "number" then
                    return MakeError(controllerPath .. ".Alpha", "number", controller.Alpha)
                end

                if type(controller.Coef) ~= "number" then
                    return MakeError(controllerPath .. ".Coef", "number", controller.Coef)
                end

                if type(controller.Enabled) ~= "boolean" then
                    return MakeError(controllerPath .. ".Enabled", "boolean", controller.Enabled)
                end
            elseif controller.type == "ControllerEdgeHide" then
                if type(controller.RemainPixels) ~= "number" then
                    return MakeError(controllerPath .. ".RemainPixels", "number", controller.RemainPixels)
                end

                if type(controller.ShadowSize) ~= "number" then
                    return MakeError(controllerPath .. ".ShadowSize", "number", controller.ShadowSize)
                end

                if type(controller.Time) ~= "number" then
                    return MakeError(controllerPath .. ".Time", "number", controller.Time)
                end
            else
                return false, string.format("'%s.type': unknown controller type '%s'", controllerPath, controller.type)
            end
        end

        if type(node.children) ~= "table" then
            return MakeError(path .. ".children", "table", node.children)
        end

        for index, child in ipairs(node.children) do
            local success, message = VerifyNode(child, string.format("%s.children[%d]", path, index))

            if not success then
                return false, message
            end
        end

        return true
    end

    if type(contents) ~= "table" then
        return MakeError("root", "table", contents)
    end

    if type(contents.version) ~= "number" then
        return MakeError("root.version", "number", contents.version)
    end

    local metadata = contents.metadata
    if type(metadata) ~= "table" then
        return MakeError("root.metadata", "table", metadata)
    end

    if type(metadata.screenWidth) ~= "number" then
        return MakeError("root.metadata.screenWidth", "number", metadata.screenWidth)
    end

    if type(metadata.screenHeight) ~= "number" then
        return MakeError("root.metadata.screenHeight", "number", metadata.screenHeight)
    end

    local data = contents.data
    if type(data) ~= "table" then
        return MakeError("root.data", "table", data)
    end

    if type(data.type) ~= "string" then
        return MakeError("root.data.type", "string", data.type)
    end

    if data.type ~= "Layout" then
        return string.format("'%s.type': expected 'Layout', got '%s'", "root.data", data.type)
    end

    if type(data.version) ~= "string" then
        return MakeError("root.data.version", "string", data.version)
    end

    if type(data.children) ~= "table" then
        return MakeError("root.data.children", "table", data.children)
    end

    for index, child in ipairs(data.children) do
        local success, message = VerifyNode(child, string.format("root.data.children[%d]", index))

        if not success then
            return false, message
        end
    end

    return true
end

function GUIInterface.new(path)
    ErrorHandler:AssertArgument(path, 2, "string")
    ErrorHandler:AssertValue(path, 2, sm.json.fileExists, "File not found")

    ---@type boolean, Internal.ReGui.Meta.RelayoutFile
    local success, result = pcall(sm.json.open, path)
    ErrorHandler:AssertCondition(success, 2, "Failed to load layout file. ")

    local success, message = VerifyLayoutFile(result)
    ErrorHandler:AssertCondition(success, 2, message)

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
    ErrorHandler:AssertSelf(self, GUIInterface.__type, true)
    ErrorHandler:AssertArgumentMulti(prettify, 2, { "boolean", "nil" })

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
    ErrorHandler:AssertSelf(self, GUIInterface.__type)
end

sm.regui.guiinterface = GUIInterface

print("Loaded GUIInterface.lua")
