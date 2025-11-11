---@class ReGui.LayoutFile
---@field identifier "ReGui"
---@field version integer
---@field data ReGui.LayoutFile.Widget[]

---@class ReGui.LayoutFile.Widget
---@field instanceProperties table<string, string>
---@field positionSize ReGui.LayoutFile.PositionSize
---@field properties table<string, string>
---@field children ReGui.LayoutFile.Widget[]
---@field controllers ReGui.LayoutFile.Controller[]
---@field isTemplateContents boolean?

---@class ReGui.LayoutFile.PositionSize
---@field usePixels boolean
---@field x string
---@field y string
---@field width string
---@field height string

---@class ReGui.LayoutFile.Controller
---@field type string
---@field properties table<string, string>

sm.log.info("[SM ReGui] ----- Scrap Mechanic ReGui - The new way of making advanced user interfaces -----")

---@class sm.regui
sm.regui = sm.regui or {}
sm.regui.version = sm.json.open("$CONTENT_DATA/version.json") ---@type number

dofile("./Logger.lua")
dofile("./ErrorHandler.lua")

print("Loaded base libraries!")

local function loadSettings()
    local defualtSettings = {
        cacheDirectory = "$CONTENT_DATA/ReGui/Cache/"
    }

    if not sm.json.fileExists("$CONTENT_DATA/ReGui/Settings.json") then
        return defualtSettings
    end

    return sm.json.open("$CONTENT_DATA/ReGui/Settings.json")
end

function sm.regui.new(path)
    AssertArgument(path, 1, {"string"})
    ValueAssert(sm.json.fileExists(path), 1, "File not found!")

    ---@class ReGui.GUI : sm.regui
    local self = {
        __type = "ReGuiUserdata",

        gui = nil, ---@type GuiInterface?
        renderedPath = "",

        settings = {}, ---@type GuiSettings

        data = sm.json.open(path), ---@type ReGui.LayoutFile
        modifiers = {},
        commands = {},

        translatorFunction = function (...)
            return ...
        end
    }

    ValueAssert(self.data.identifier == "ReGui"         , 1, "Not a ReGui Layout File!")
    ValueAssert(self.data.version    == sm.regui.version, 1, "ReGui version mismatch!")

    for key, value in pairs(sm.regui) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    ---@param widget ReGui.LayoutFile.Widget
    local function iterator(widget)
        local name = widget.instanceProperties and widget.instanceProperties.name or nil
        if not name then
            warn("Widget without name found, skipping: " .. (widget.instanceProperties.id or "Unnamed"))
            return
        end

        if not widget.properties then
            return
        end

        for key, value in pairs(widget.properties) do
            if key == "Caption" then
                -- Dont need to repack using TableRepack
                local repackedValue = type(value) == "table" and value or {value}

                self.modifiers[name] = self.modifiers[name] or {}
                self.modifiers[name].text = {
                    input = repackedValue,
                    output = self.translatorFunction(unpack(repackedValue))
                }
            end
        end
    end

    for _, widget in pairs(self.data.data) do
        iterator(widget)
    end

    return self
end

function sm.regui.newBlank()
    ---@class ReGui.GUI : sm.regui
    local self = {
        __type = "ReGuiUserdata",

        gui = nil, ---@type GuiInterface?
        renderedPath = "",

        settings = {}, ---@type GuiSettings

        data = { identifier = "ReGui", version = sm.regui.version, data = {} }, ---@type ReGui.LayoutFile

        modifiers = {},
        commands = {},

        translatorFunction = function (...)
            return ...
        end
    }

    for key, value in pairs(sm.regui) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    return self
end

---@param self ReGui.GUI
function sm.regui:clone()
    SelfAssert(self)

    local gui = sm.regui.newBlank()
    gui.data = CloneTable(self.data)
    gui.settings = CloneTable(self.settings)
    gui.modifiers = CloneTable(self.modifiers)
    gui.commands = CloneTable(self.commands)
    gui.translatorFunction = self.translatorFunction

    return gui
end

---@param self ReGui.GUI
function sm.regui:render()
    SelfAssert(self)

    local function escapeXMLString(xmlString)
        xmlString = xmlString:gsub("&", "&amp;" ) -- Escape & with &amp; to prevent xml issues
        xmlString = xmlString:gsub("<", "&lt;"  ) -- Escape < with &lt; to prevent xml issues
        xmlString = xmlString:gsub(">", "&gt;"  ) -- Escape > with &gt; to prevent xml issues
        xmlString = xmlString:gsub('"', "&quot;") -- Escape " with &quot; to prevent xml issues
        xmlString = xmlString:gsub("'", "&apos;") -- Escape ' with &apos; to prevent xml issues
        return xmlString
    end

    local hash = CreateHashFromGuiInstance(self)
    self.renderedPath = loadSettings().cacheDirectory .. "Layout_" .. hash .. ".layout"

    if #self.data.data == 2 then
        local message = [[Warning on the following file: %s
    You have multiple widgets inside the root of the GUI. Normally no one does this because you usually put BackPanel here and that's it.
    If you didn't intend on creating multiple widgets, make sure you didn't do one of these so you don't get a brain tumor.
        - Tried creating a widget by doing this, because it will just create it on the root: FullscreenGUI:getGui():createWidget
]]

        warn(string.format(message, self.renderedPath))
    end


    if sm.json.fileExists(self.renderedPath) then
        return -- Already rendered, no need to re-render it
    end

    ---@param widget ReGui.LayoutFile.Widget
    local function renderWidget(widget)
        if not widget.instanceProperties.type then
            -- We should skip this widget or else MyGui will throw a critcial error and crash

            warn("Widget without type found, skipping: " .. (instanceProperties.name or "Unnamed"))
            return ""
        end

        local output = "<Widget"
        local instanceProperties = widget.instanceProperties and CloneTable(widget.instanceProperties) or {}
        if widget.positionSize then
            local posSize = widget.positionSize
            instanceProperties[posSize.usePixels and "position" or "position_real"] = tostring(posSize.x     ) .. " " ..
                                                                                      tostring(posSize.y     ) .. " " ..
                                                                                      tostring(posSize.width ) .. " " ..
                                                                                      tostring(posSize.height)
        end

        -- Instance Properties handling
        do
            local instanceProperties2 = {}
            for key, value in PredictablePairs(instanceProperties) do
                table.insert(instanceProperties2, key .. "=\"" .. escapeXMLString(tostring(value)) .. "\"")
            end

            if #instanceProperties2 > 0 then
                output = output .. " " .. table.concat(instanceProperties2, " ")
            end
        end

        output = output .. ">"

        -- Property handling
        if widget.properties then
            for key, value in PredictablePairs(widget.properties) do
                local outputValue = tostring(value)

                if type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
                    outputValue = tostring(value[1] or value.x) .. " " .. tostring(value[2] or value.y)
                end

                output = output .. "<Property key=\"" .. key .. "\" value=\"" .. escapeXMLString(outputValue) .. "\"/>"
            end
        end

        -- Children handling
        if widget.children then
            for _, child in pairs(widget.children) do
                output = output .. renderWidget(child)
            end
        end

        -- Controller handling
        if widget.controllers then
            for _, controller in pairs(widget.controllers) do
                output = output .. "<Controller type=\"" .. controller.type .. "\">"

                if controller.properties then
                    for key, value in PredictablePairs(controller.properties) do
                        local outputValue = tostring(value)

                        if type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
                            outputValue = tostring(value[1] or value.x) .. " " .. tostring(value[2] or value.y)
                        end

                        output = output .. "<Property key=\"" .. key .. "\" value=\"" .. escapeXMLString(outputValue) .. "\"/>"
                    end
                end

                output = output .. "</Controller>"
            end
        end

        return output .. "</Widget>"
    end

    local output = ""
    for _, value in pairs(self.data.data) do
        output = output .. renderWidget(value)
    end

    local renderedData = ParseLayoutToValidJsonXML('<MyGUI type="Layout" version="3.2.0">' .. output .. '</MyGUI>')
    sm.json.save(renderedData, self.renderedPath)
end

---@param self ReGui.GUI
function sm.regui:open()
    SelfAssert(self)

    self:close()
    self:render()

    self.gui = sm.gui.createGuiFromLayout(self.renderedPath, true, self.settings)

    self:refreshTranslations()

    for _, command in pairs(self.commands) do
        self.gui[command[1]](self.gui, unpack(command[2]))
    end

    self.gui:open()
end

function sm.regui:close()
    SelfAssert(self)

    if sm.exists(self.gui) then
        self.gui:close()
    end
end

---@param gui ReGui.GUI
---@return ReGui.LayoutFile.Widget?
---@return ReGui.LayoutFile.Widget?
local function findWidgetRecursiveRaw(gui, widgetName)
    if not gui then return end

    ---@param widget ReGui.LayoutFile.Widget
    local function iterator(widget)
        if widget.instanceProperties.name and widget.instanceProperties.name == widgetName then
            return widget
        end

        if not widget.children then
            return nil, nil
        end

        for _, child in pairs(widget.children) do
            local widget = iterator(child)
            if widget then
                return widget, child
            end
        end
    end

    for _, child in pairs(gui.data.data) do
        local widget = iterator(child)
        if widget then
            return widget, nil
        end
    end
end

---@param self ReGui.GUI
function sm.regui:setWidgetProperty(widgetName, index, value)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(index     , 2, {"string"})
    AssertArgument(value     , 3, {"string", "number", "boolean", "table", "nil"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    if index == "Caption" then
        -- Dont need to repack using TableRepack
        local repackedValue = type(value) == "table" and value or {value}

        self.modifiers[widget.instanceProperties.name] = self.modifiers[widget.instanceProperties.name] or {}
        self.modifiers[widget.instanceProperties.name].text = {
            input = repackedValue,
            output = self.translatorFunction(unpack(repackedValue))
        }

        widget.properties[index] = tostring(value)
    elseif type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
        widget.properties[index] = value
    else
        widget.properties[index] = tostring(value)
    end
end

function sm.regui:getWidgetProperty(widgetName, index)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(index     , 2, {"string"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    return widget.properties[index]
end

function sm.regui:setWidgetProperties(widgetName, data)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(data      , 2, {"table"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    for key, value in pairs(data) do
        widget.properties[key] = tostring(value)

        if key == "Caption" then
            self:setText(widget, value)
        end
    end
end

function sm.regui:getWidgetProperties(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    return CloneTable(widget.properties)
end

function sm.regui:widgetExists(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    return widget ~= nil
end

local function createControllerWrapper(controller)
    return {
        __type = "ReGuiUserdata",

        getType = function(self)
            SelfAssert(self)
            return controller.type
        end,

        setType = function(self, newType)
            SelfAssert(self)
            AssertArgument(newType, 1, {"string"})

            controller.type = newType
        end,

        getProperties = function(self)
            SelfAssert(self)
            return CloneTable(controller.properties)
        end,

        setProperties = function (self, data)
            SelfAssert(self)
            AssertArgument(data, 1, {"table"})

            for key, value in pairs(data) do
                self:setProperty(key, value)
            end
        end,

        setProperty = function(self, key, value)
            SelfAssert(self)
            AssertArgument(index, 2, {"string"})
            AssertArgument(value, 3, {"string", "number", "boolean", "table", "nil"})

            if type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
                controller.properties[key] = value
            else
                controller.properties[key] = tostring(value)
            end
        end,

        getProperty = function(self, key)
            SelfAssert(self)
            AssertArgument(index, 2, {"string"})

            return controller.properties[key]
        end,

        destroy = function (self)
            SelfAssert(self)

            if not gui.controllers then
                return false
            end

            for i, ctrl in ipairs(gui.controllers) do
                if ctrl == controller then
                    table.remove(gui.controllers, i)
                    return true
                end
            end

            return false
        end
    }
end

---@param gui ReGui.GUI
---@param parentWidget ReGui.LayoutFile.Widget?
---@param widget ReGui.LayoutFile.Widget
---@return ReGui.Widget
local function createWidgetWrapper(gui, parentWidget, widget, parentWidgetWrapper)
    local function getEffectiveParentSize(self)
        local parent = self:getParent()
        if parent and parent:exists() then
            return parent:getSize()
        else
            local sw, sh = GetMyGuiScreenSize()
            return { x = sw, y = sh }
        end
    end


    ---@class ReGui.Widget
    local output = {
        __type = "ReGuiUserdata",
        __getRawWidget = function (self)
            SelfAssert(self)
            return widget
        end,

        getGui = function (self)
            SelfAssert(self)

            local a, _ = findWidgetRecursiveRaw(gui, self:getName())
            if not a then
                return nil -- Widget is nowhere used
            end

            return gui
        end,

        setImage = function (self, path)
            SelfAssert(self)
            AssertArgument(path, 1, {"string"})
            ValueAssert(widget.instanceProperties.name, nil, "Widget has no name property, cannot set image!")

            gui.modifiers[widget.instanceProperties.name] = gui.modifiers[widget.instanceProperties.name] or {}
            gui.modifiers[widget.instanceProperties.name].image = path

            gui:setImage(widget.instanceProperties.name, path)
        end,

        setLocationForTemplateContents = function (self, state)
            SelfAssert(self)
            AssertArgument(state, 1, {"boolean"})

            widget.isTemplateContents = state
        end,

        isLocationForTemplateContents = function (self)
            SelfAssert(self)

            return widget.isTemplateContents
        end,

        getName = function(self)
            SelfAssert(self)
            return widget.instanceProperties.name
        end,

        getType = function (self)
            SelfAssert(self)
            return widget.instanceProperties.type
        end,

        getSkin = function(self)
            SelfAssert(self)
            return widget.instanceProperties.skin
        end,

        setName = function(self, name)
            SelfAssert(self)
            AssertArgument(name, 1, {"string"})

            widget.instanceProperties.name = name
        end,

        setType = function (self, widgetType)
            SelfAssert(self)
            AssertArgument(widgetType, 1, {"string"})

            widget.instanceProperties.type = widgetType
        end,

        setSkin = function(self, skin)
            SelfAssert(self)
            AssertArgument(skin, 1, {"string"})

            widget.instanceProperties.skin = skin
        end,

        getParent = function(self)
            SelfAssert(self)

            return parentWidgetWrapper
        end,

        ---@param newParent ReGui.Widget
        setParent = function(self, newParent)
            SelfAssert(self)

            if newParent ~= nil then
                AssertArgument(newParent, 1, {"table"})
            end

            local childrenList = parentWidget and parentWidget.children or gui.data.data

            for i, child in pairs(childrenList) do
                if child == widget then
                    table.remove(childrenList, i)
                    break
                end
            end

            if newParent then
                local modifiers = CloneTable(gui.modifiers[widget.instanceProperties.name])
                gui = newParent:getGui()

                if modifiers then
                    if modifiers.image then
                        gui:setImage(widget.instanceProperties.name, modifiers.image)
                    end

                    gui.modifiers[widget.instanceProperties.name] = modifiers
                end

                local newParentWidget = newParent:__getRawWidget()
                table.insert(newParentWidget.children, widget)
            else
                table.insert(gui.data.data, widget)
            end

            parentWidget = newParent
        end,

        ---@return ReGui.Widget[]
        getChildren = function(self)
            SelfAssert(self)

            if not widget.children then
                return {}
            end
            
            local children = {}
            for _, child in pairs(widget.children) do
                table.insert(children, createWidgetWrapper(gui, widget, child, self))
            end

            return children
        end,

        getPosition = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                return { x = widget.positionSize.x, y = widget.positionSize.y }
            else
                local parentSize = getEffectiveParentSize(self)
                return {
                    x = widget.positionSize.x * parentSize.x,
                    y = widget.positionSize.y * parentSize.y
                }
            end
        end,

        getPositionRealUnits = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                return { x = widget.positionSize.width, y = widget.positionSize.height }
            else
                local parentSize = self:getSizeRealUnits()
                return {
                    x = widget.positionSize.width * parentSize.x,
                    y = widget.positionSize.height * parentSize.y
                }
            end
        end,

        getSize = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                return { x = widget.positionSize.width, y = widget.positionSize.height }
            else
                local parentSize = getEffectiveParentSize(self)
                return {
                    x = widget.positionSize.width * parentSize.x,
                    y = widget.positionSize.height * parentSize.y
                }
            end
        end,

        getSizeRealUnits = function (self)
            if widget.positionSize.usePixels then
                local parentSize = getEffectiveParentSize(self)
                return {
                    x = widget.positionSize.width / parentSize.x,
                    y = widget.positionSize.height / parentSize.y
                }
            else
                return { x = widget.positionSize.width, y = widget.positionSize.height }
            end
        end,

        getSizeRealUnitsExpectedRendering = function(self)
            SelfAssert(self)
            assert(not widget.positionSize.usePixels, "getSizeRealUnitsExpectedRendering can only be used on real-units sized widgets!")

            local function computeAbsoluteSize(widget)
                local parent = widget:getParent()
                local relSize = widget:getSizeRealUnits() -- always returns relative size if not using pixels

                if parent and parent:exists() then
                    local parentAbsSize = parent:getSizeRealUnitsExpectedRendering()
                    return {
                        x = relSize.x * parentAbsSize.x,
                        y = relSize.y * parentAbsSize.y
                    }
                else
                    -- Top-level widget: assume it provides real-unit size
                    return relSize
                end
            end

            return computeAbsoluteSize(self)
        end,

        getPositionRealUnitsExpectedRendering = function(self)
            SelfAssert(self)
            assert(not widget.positionSize.usePixels, "getPositionRealUnitsExpectedRendering can only be used on real-units sized widgets!")

            local function computeAbsolutePosition(widget)
                local parent = widget:getParent()
                local relPos = widget:getPositionRealUnits()

                if parent and parent:exists() then
                    local parentAbsSize = parent:getSizeRealUnitsExpectedRendering()
                    local parentAbsPos = parent:getPositionRealUnitsExpectedRendering()

                    return {
                        x = parentAbsPos.x + (relPos.x * parentAbsSize.x),
                        y = parentAbsPos.y + (relPos.y * parentAbsSize.y)
                    }
                else
                    -- Top-level widget
                    return relPos
                end
            end

            return computeAbsolutePosition(self)
        end,

        setProperties = function (self, data)
            SelfAssert(self)
            AssertArgument(data, 1, {"table"})

            for key, value in pairs(data) do
                self:setProperty(key, value)
            end
        end,

        getProperties = function(self)
            SelfAssert(self)

            return CloneTable(widget.properties)
        end,

        setProperty = function(self, index, value)
            SelfAssert(self)
            AssertArgument(index, 1, {"string"})
            AssertArgument(value, 3, {"string", "number", "boolean", "table", "nil"})

            if index == "Caption" then
                -- Dont need to repack using TableRepack
                local repackedValue = type(value) == "table" and value or {value}

                gui.modifiers[widget.instanceProperties.name] = gui.modifiers[widget.instanceProperties.name] or {}
                gui.modifiers[widget.instanceProperties.name].text = {
                    input = repackedValue,
                    output = gui.translatorFunction(unpack(repackedValue))
                }
            end

            widget.properties[index] = tostring(value)
        end,

        getProperty = function(self, index)
            SelfAssert(self)
            AssertArgument(index, 1, {"string"})

            return widget.properties[index]
        end,

        setInstanceProperty = function(self, key, value)
            SelfAssert(self)
            AssertArgument(key, 1, {"string"})
            AssertArgument(value, 2, {"string", "number", "boolean", "nil"})

            widget.instanceProperties[key] = tostring(value)
        end,

        getInstanceProperty = function(self, key)
            SelfAssert(self)
            AssertArgument(key, 1, {"string"})

            return widget.instanceProperties[key]
        end,

        setPosition = function(self, position)
            SelfAssert(self)
            AssertArgument(position, 2, {"table"})

            local x = position.x ~= nil and position.x or position[1]
            local y = position.y ~= nil and position.y or position[2]
            ValueAssert(type(x) == "number", 2, "Expected x or [1] to be a number!")
            ValueAssert(type(y) == "number", 2, "Expected y or [2] to be a number!")

            local width  = widget.positionSize.width
            local height = widget.positionSize.height

            if not widget.positionSize.usePixels then
                local pixelSize = self:getSize()
                width  = pixelSize.x
                height = pixelSize.y
            end

            widget.positionSize = {
                usePixels = true,
                x         = math.floor(x),
                y         = math.floor(y),
                width     = math.floor(width ),
                height    = math.floor(height)
            }
        end,

        setPositionRealUnits = function(self, position)
            SelfAssert(self)
            AssertArgument(position  , 2, {"table"})

            local x = position.x ~= nil and position.x or position[1]
            local y = position.y ~= nil and position.y or position[2]
            ValueAssert(type(x) == "number", 2, "Expected x or [1] to be a number!")
            ValueAssert(type(y) == "number", 2, "Expected y or [2] to be a number!")

            local width  = widget.positionSize.width
            local height = widget.positionSize.height

            if widget.positionSize.usePixels then
                local realSize = self:getSizeRealUnits()
                width  = realSize.x
                height = realSize.y
            end

            widget.positionSize = {
                usePixels = false,
                x         = x,
                y         = y,
                width     = width,
                height    = height
            }
        end,

        setSize = function(self, size)
            SelfAssert(self)
            AssertArgument(size, 2, {"table"})

            local width  = size.x ~= nil and size.x or size[1]
            local height = size.y ~= nil and size.y or size[2]
            ValueAssert(type(width ) == "number", 2, "Expected x or [1] to be a number!")
            ValueAssert(type(height) == "number", 2, "Expected y or [2] to be a number!")

            local x = widget.positionSize.x
            local y = widget.positionSize.y

            if not widget.positionSize.usePixels then
                local pixelPos = self:getPosition()
                x = pixelPos.x
                y = pixelPos.y
            end

            widget.positionSize = {
                usePixels = true,
                x         = math.floor(x),
                y         = math.floor(y),
                width     = math.floor(width ),
                height    = math.floor(height)
            }
        end,

        setSizeRealUnits = function(self, size)
            SelfAssert(self)

            AssertArgument(size, 2, {"table"})

            local width  = size.x ~= nil and size.x or size[1]
            local height = size.y ~= nil and size.y or size[2]
            ValueAssert(type(width ) == "number", 2, "Expected x or [1] to be a number!")
            ValueAssert(type(height) == "number", 2, "Expected y or [2] to be a number!")

            local x = widget.positionSize.x
            local y = widget.positionSize.y

            if widget.positionSize.usePixels then
                local realPos = self:getPositionRealUnits()
                x = realPos.x
                y = realPos.y
            end

            widget.positionSize = {
                usePixels = false,
                x         = x,
                y         = y,
                width     = width,
                height    = height
            }
        end,

        destroy = function(self)
            SelfAssert(self)

            local tbl = parentWidget and parentWidget.children or gui.data.data
            for i, child in ipairs(tbl) do
                if child.instanceProperties.name == widget.instanceProperties.name then
                    table.remove(tbl, i)
                    return true
                end
            end

            return false
        end,

        createWidget = function(self, widgetName, widgetType, skin)
            SelfAssert(self)
            AssertArgument(widgetName, 1, {"string"})
            AssertArgument(widgetType, 2, {"string", "nil"})
            AssertArgument(skin      , 3, {"string", "nil"})

            local newWidget = {
                instanceProperties = { name = widgetName, type = widgetType or "Widget", skin = skin or "PanelEmpty" },
                positionSize = {
                    usePixels = true,
                    x = 0,
                    y = 0,
                    width  = 0,
                    height = 0
                },
                properties = {},
                children = {}
            }

            widget.children = widget.children or {}
            table.insert(widget.children, newWidget)

            return createWidgetWrapper(gui, widget, newWidget, self)
        end,

        createController = function (self, controllerType)
            SelfAssert(self)
            AssertArgument(controllerType, 1, {"string"})

            local controller = {
                type = controllerType,
                properties = {},
            }

            widget.controllers = widget.controllers or {}
            table.insert(widget.controllers, controller)

            return createControllerWrapper(controller)
        end,

        findController = function (self, controllerType)
            SelfAssert(self)
            AssertArgument(controllerType, 1, {"string"})

            if not widget.controllers then
                return
            end

            for _, controller in ipairs(widget.controllers) do
                if controller.type == controllerType then
                    return createControllerWrapper(controller)
                end
            end
        end,

        destroyController = function (self, controllerType)
            SelfAssert(self)
            AssertArgument(controllerType, 1, {"string"})

            if not widget.controllers then
                return false
            end

            for i, controller in ipairs(widget.controllers) do
                if controller.type == controllerType then
                    table.remove(widget.controllers, i)
                    return true
                end
            end

            return false
        end,

        setVisible = function (self, visible)
            SelfAssert(self)
            AssertArgument(visible, 1, {"boolean"})

            gui:setVisible(widget.instanceProperties.name, visible)
        end,

        setText = function (self, ...)
            SelfAssert(self)
            ValueAssert(widget.instanceProperties.name, nil, "Widget has no name property, cannot set text!")

            gui.modifiers[widget.instanceProperties.name] = gui.modifiers[widget.instanceProperties.name] or {}
            gui.modifiers[widget.instanceProperties.name].text = {
                input = TableRepack(...),
                output = gui.translatorFunction(...)
            }

            gui:setText(widget.instanceProperties.name, ...)
        end,

        getText = function (self)
            SelfAssert(self)

            ValueAssert(widget.instanceProperties.name, nil, "Widget has no name property, cannot get text!")
            if not gui.modifiers[widget.instanceProperties.name] or not gui.modifiers[widget.instanceProperties.name].text then
                return widget.properties and widget.properties.Caption or nil
            end

            return gui.modifiers[widget.instanceProperties.name].text.output
        end,

        exists = function (self)
            SelfAssert(self)

            local foundWidget, _ = findWidgetRecursiveRaw(gui, self:getName())
            if not foundWidget then
                return false
            end

            return tostring(widget) == tostring(foundWidget)
        end,

        hasChildren = function (self)
            SelfAssert(self)

            return #widget.children ~= 0
        end,

        findWidget = function (self, widgetName)
            SelfAssert(self)
            AssertArgument(widgetName, 1, {"string"})

            for _, child in pairs(self:getChildren()) do
                if child:getName() == widgetName then
                    return child
                end
            end
        end,

        findWidgetRecursive = function (self, widgetName)
            SelfAssert(self)
            AssertArgument(widgetName, 1, {"string"})

            ---@param widget ReGui.Widget
            local function iterator(widget)
                for _, child in pairs(widget:getChildren()) do
                    if child:getName() == widgetName then
                        return child
                    end

                    local found = iterator(child)
                    if found then
                        return found
                    end
                end
            end

            return iterator(self)
        end
    }

    return output
end

---@param self ReGui.GUI
function sm.regui:findWidgetRecursive(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    local widget, parentChild = findWidgetRecursiveRaw(self, widgetName)
    if not widget then
        return nil
    end

    return createWidgetWrapper(self, parentChild, widget)
end

---@param self ReGui.GUI
function sm.regui:findWidget(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    for _, child in pairs(self.data.data) do
        if child.instanceProperties.name and child.instanceProperties.name == widgetName then
            return createWidgetWrapper(self, nil, child)
        end
    end
end

---@param self ReGui.GUI
function sm.regui:getRootChildren()
    SelfAssert(self)
    local children = {}

    for _, child in pairs(self.data.data) do
        table.insert(children, createWidgetWrapper(self, nil, child))
    end

    return children
end

---@param self ReGui.GUI
function sm.regui:createWidget(widgetName, widgetType, skin)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(widgetType, 2, {"string", "nil"})
    AssertArgument(skin      , 3, {"string", "nil"})

    ---@type ReGui.LayoutFile.Widget
    local widget = {
        instanceProperties = { name = widgetName, type = widgetType or "Widget", skin = skin or "PanelEmpty" },
        positionSize = {
            usePixels = true,
            x         = 0,
            y         = 0,
            width     = 0,
            height    = 0,
        },
        properties = {},
        children = {},
        controllers = {},
        isTemplateContents = false
    }

    table.insert(self.data.data, widget)

    return createWidgetWrapper(self, nil, widget)
end

---@param self ReGui.GUI
function sm.regui:getSettings()
    SelfAssert(self)
    return CloneTable(self.settings)
end

---@param self ReGui.GUI
function sm.regui:setSettings(settings)
    SelfAssert(self)
    ValueAssert(settings, 1, {"table"}, {"GuiSettings"})

    self.settings = settings
end

---@param self ReGui.GUI
function sm.regui:isActive()
    SelfAssert(self)
    return self.gui and sm.exists(self.gui) and self.gui:isActive()
end

---@param self ReGui.GUI
function sm.regui:setTextTranslation(translatorFunction)
    SelfAssert(self)
    AssertArgument(translatorFunction, 1, {"function", "nil"})

    if not translatorFunction then
        self.translatorFunction = function(...) return ... end
    else
        self.translatorFunction = translatorFunction
    end
end

---@param self ReGui.GUI
function sm.regui:setText(widgetName, ...)
    SelfAssert(self)

    local repackedValue = TableRepack(...)

    self.modifiers[widgetName] = self.modifiers[widgetName] or {}
    self.modifiers[widgetName].text = {
        input = repackedValue,
        output = self.translatorFunction(unpack(repackedValue))
    }

    if self:isActive() then
        self.gui:setText(widgetName, self.modifiers[widgetName].text.output)
    end
end

---@param self ReGui.GUI
function sm.regui:getText(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    local modiferText = (self.modifiers[widgetName] and self.modifiers[widgetName].text) and self.modifiers[widgetName].text.output or nil
    local caption = widget.properties and widget.properties.Caption or nil

    return modiferText or caption
end

function sm.regui:refreshTranslations()
    SelfAssert(self)

    for widgetName, data in pairs(self.modifiers) do
        if data.text then
            data.text.output = self.translatorFunction(unpack(data.text.input))

            if self.gui and sm.exists(self.gui) then
                self.gui:setText(widgetName, tostring(data.text.output))
            end
        end
    end
end

function sm.regui:setData(widgetName, data)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(data, 2, {"table"})

    local widget = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    for key, value in pairs(data) do
        widget.properties[key] = value

        if key == "Caption" then
            self:setText(widgetName, value)
        end
    end
end

function sm.regui:getData(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    local widget = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    return CloneTable(widget.properties)
end

function sm.regui:getRenderedPath()
    SelfAssert(self)
    
    return self.renderedPath
end

function sm.regui:hasRendered()
    SelfAssert(self)
    
    return self.renderedPath ~= ""
end

-- Load additional libaries

dofile("./GuiInterfaceWrap.lua")
dofile("./Helpers.lua")
dofile("./TableHash.lua")
dofile("./TemplateManager.lua")
dofile("./FullscreenGui.lua")
dofile("./FontManager.lua")
dofile("./VideoPlayer.lua")
dofile("./FlexibleWidget.lua")
dofile("./ProgressBar.lua")

print("Library fully loaded!")

---@class MainToolClass : ToolClass
MainToolClass = class()