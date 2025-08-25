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



--
-- HELPERS
--

function predictablePairs(tbl)
    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end

    table.sort(keys, function(a, b)
        return tostring(a) < tostring(b)
    end)

    local i = 0
    return function()
        i = i + 1
        local key = keys[i]
        if key ~= nil then
            return key, tbl[key]
        end
    end
end


local function parseLayoutToValidJsonXML(xmlString)
    xmlString = xmlString:gsub("'", "&apos;") --Escape ' with &apos;, as we have to replace " with ' to make the Json serializer not escape them
    xmlString = xmlString:gsub('"', "'") --Replace remaining " with ', to make the Json serializer not escape them, keeping it valid XML
    xmlString = "\""..xmlString --Deal with the first ", making it valid but ignored
    xmlString = xmlString.."<!--" --Deal with the last ", commenting it out
    return xmlString
end

---@param instance ReGui.GUI
---@return string
local function createHashFromGuiInstance(instance)
    local function serialize(tbl)
        local keys, str = {}, "{"
        for k in pairs(tbl) do
            table.insert(keys, k)
        end

        table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

        for _, k in ipairs(keys) do
            local v = tbl[k]
            local function valToStr(val)
                if type(val) == "table" then
                    return serialize(val)
                elseif type(val) == "string" then
                    return string.format("%q", val)
                else
                    return tostring(val)
                end
            end

            str = str .. "[" .. valToStr(k) .. "]=" .. valToStr(v) .. ","
        end
        return str .. "}"
    end

    local function fnv1a64(str)
        local hash = { 0x84222325, 0xcbf29ce4 }
        for i = 1, #str do
            local byte = string.byte(str, i)
            hash = { bit.bxor(hash[1], byte), hash[2] }

            local a_lo, a_hi = hash[1], hash[2]
            local b_lo, b_hi = 0x1b3, 0x100
            local lo_lo = bit.band(a_lo * b_lo, 0xFFFFFFFF)
            local hi_lo = bit.band(a_hi * b_lo + a_lo * b_hi, 0xFFFFFFFF)
            local hi_hi = bit.band(a_hi * b_hi, 0xFFFFFFFF)
            local mid = bit.rshift(a_lo * b_lo, 32) + bit.band(hi_lo, 0xFFFFFFFF)

            hash = {
                bit.band(lo_lo, 0xFFFFFFFF),
                bit.band(mid + hi_hi, 0xFFFFFFFF)
            }
        end

        return hash
    end

    local function toHex64(v)
        return string.format("%08x%08x", v[2], v[1])
    end

    local h1 = fnv1a64(serialize(instance.data))
    local h2 = fnv1a64(serialize(instance.modifiers))

    local lo = (h1[1] + h2[1]) % 2^32
    local carry = math.floor((h1[1] + h2[1]) / 2^32)
    local hi = (h1[2] + h2[2] + carry) % 2^32

    return toHex64({ lo, hi })
end

function getMyGuiScreenSize()
    local screenWidth, screenHeight = sm.gui.getScreenSize()

    -- 720p, 1080p, 1440p, 4k

    if screenWidth >= 3840 and screenHeight >= 2160 then
        return 3840, 2160 -- 4K
    elseif screenWidth >= 2560 and screenHeight >= 1440 then
        return 2560, 1440 -- 1440p
    elseif screenWidth >= 1920 and screenHeight >= 1080 then
        return 1920, 1080 -- 1080p
    else
        return 1280, 720 -- 720p
    end
end

local function tablePack(...)
    return {
        __n = select("#", ...),
        ...
    }
end

local function tableMove(src, first, last, offset, dst)
    for i = 0, last - first do
        dst[offset + i] = src[first + i]
    end
end


local function tableRepack(...)
    local packed = tablePack(...)
    local result = {}
    tableMove(packed, 1, packed.__n, 1, result)
    return result
end

--
-- MAIN LIBRARY
--

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
        local name = widget.instanceProperties.name
        if not name then
            warn("Widget without name found, skipping: " .. (widget.instanceProperties.id or "Unnamed"))
            return
        end

        for key, value in pairs(widget.properties) do
            if key == "Caption" then
                -- Dont need to repack using tableRepack
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

    local hash = createHashFromGuiInstance(self)
    self.renderedPath = loadSettings().cacheDirectory .. "Layout_" .. hash .. ".layout"

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
        local instanceProperties = widget.instanceProperties and unpack({widget.instanceProperties}) or {}
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
            for key, value in predictablePairs(instanceProperties) do
                table.insert(instanceProperties2, key .. "=\"" .. escapeXMLString(tostring(value)) .. "\"")
            end

            if #instanceProperties2 > 0 then
                output = output .. " " .. table.concat(instanceProperties2, " ")
            end
        end

        output = output .. ">"

        -- Property handling
        do
            for key, value in predictablePairs(widget.properties or {}) do
                local outputValue = tostring(value)

                if type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
                    outputValue = tostring(value[1] or value.x) .. " " .. tostring(value[2] or value.y)
                end

                output = output .. "<Property key=\"" .. key .. "\" value=\"" .. escapeXMLString(outputValue) .. "\"/>"
            end
        end

        -- Children handling
        do
            for _, child in pairs(widget.children or {}) do
                output = output .. renderWidget(child)
            end
        end

        -- Controller handling
        do
            for _, controller in pairs(widget.controllers or {}) do
                output = output .. "<Controller type=\"" .. controller.type .. "\">"

                for key, value in predictablePairs(controller.properties or {}) do
                    local outputValue = tostring(value)

                    if type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
                        outputValue = tostring(value[1] or value.x) .. " " .. tostring(value[2] or value.y)
                    end

                    output = output .. "<Property key=\"" .. key .. "\" value=\"" .. escapeXMLString(outputValue) .. "\"/>"
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

    local renderedData = parseLayoutToValidJsonXML('<MyGUI type="Layout" version="3.2.0">' .. output .. '</MyGUI>')
    sm.json.save(renderedData, self.renderedPath)
end

---@param self ReGui.GUI
function sm.regui:open()
    SelfAssert(self)

    self:close()
    self:render()

    self.gui = sm.gui.createGuiFromLayout(self.renderedPath, true, self.settings)

    self:refreshTranslations()

    for _, command in pairs(self.commands or {}) do
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

---@param self ReGui.GUI
local function runPreviousCommand(self)
    local latestCommand = self.commands[#self.commands]
    local guiInterface = self.gui

    if guiInterface and sm.exists(guiInterface) and guiInterface:isActive() then
        guiInterface[latestCommand[1]](guiInterface, unpack(latestCommand[2]))
    end
end

---@param gui ReGui.GUI
---@return ReGui.LayoutFile.Widget?
---@return ReGui.LayoutFile.Widget?
local function findWidgetRecursiveRaw(gui, widgetName)
    ---@param widget ReGui.LayoutFile.Widget
    local function iterator(widget)
        if widget.instanceProperties.name and widget.instanceProperties.name == widgetName then
            return widget
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

function sm.regui:setWidgetPosition(widgetName, position)
    SelfAssert(self)

    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(position  , 2, {"table"})

    local x = position.x ~= nil and position.x or position[1]
    local y = position.y ~= nil and position.y or position[2]
    ValueAssert(type(x) == "number", 2, "Expected x or [1] to be a number!")
    ValueAssert(type(y) == "number", 2, "Expected y or [2] to be a number!")

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    local current = widget.positionSize

    local width = current.width
    local height = current.height

    if not current.usePixels then
        width  = 1920 / width
        height = 1080 / height
    end

    widget.positionSize = {
        usePixels = true,
        x         = math.floor(x),
        y         = math.floor(y),
        width     = math.floor(width ),
        height    = math.floor(height)
    }
end

function sm.regui:setWidgetPositionRealUnits(widgetName, position)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(position  , 2, {"table"})

    local x = position.x ~= nil and position.x or position[1]
    local y = position.y ~= nil and position.y or position[2]
    ValueAssert(type(x) == "number", 2, "Expected x or [1] to be a number!")
    ValueAssert(type(y) == "number", 2, "Expected y or [2] to be a number!")

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    local current = widget.positionSize

    local width = current.width
    local height = current.height

    -- Convert pixel dimensions to RealUnitss if needed
    if current.usePixels then
        width  = width  / 1920
        height = height / 1080
    end

    widget.positionSize = {
        usePixels = false,
        x         = x,
        y         = y,
        width     = width,
        height    = height
    }
end

function sm.regui:setWidgetSize(widgetName, size)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(size, 2, {"table"})

    local width = size.x ~= nil and size.x or size[1]
    local height = size.y ~= nil and size.y or size[2]
    ValueAssert(type(width ) == "number", 2, "Expected x or [1] to be a number!")
    ValueAssert(type(height) == "number", 2, "Expected y or [2] to be a number!")

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    local current = widget.positionSize

    local x = current.x
    local y = current.y

    if not current.usePixels then
        x = 1920 * x
        y = 1080 * y
    end

    widget.positionSize = {
        usePixels = true,
        x         = math.floor(x),
        y         = math.floor(y),
        width     = math.floor(width ),
        height    = math.floor(height)
    }
end

function sm.regui:setWidgetSizeRealUnits(widgetName, size)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(size, 2, {"table"})

    local width = size.x ~= nil and size.x or size[1]
    local height = size.y ~= nil and size.y or size[2]
    ValueAssert(type(width ) == "number", 2, "Expected x or [1] to be a number!")
    ValueAssert(type(height) == "number", 2, "Expected y or [2] to be a number!")

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    ValueAssert(widget, 1, "Widget not found!")

    local current = widget.positionSize

    local x = current.x
    local y = current.y

    if current.usePixels then
        x = x / 1920
        y = y / 1080
    end

    widget.positionSize = {
        usePixels = false,
        x         = x,
        y         = y,
        width     = width,
        height    = height
    }
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
        -- Dont need to repack using tableRepack
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

    return unpack({widget.properties})
end

function sm.regui:widgetExists(widgetName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})

    local widget, _ = findWidgetRecursiveRaw(self, widgetName)
    return widget ~= nil
end

local function createControllerWrapper(controller)
    return {
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
            return unpack({controller.properties})
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

            for i, ctrl in ipairs(gui.controllers or {}) do
                if ctrl == controller then
                    table.remove(gui.controllers, i)
                    break
                end
            end
        end
    }
end

---@param gui ReGui.GUI
---@param parentWidget ReGui.LayoutFile.Widget?
---@param widget ReGui.LayoutFile.Widget
---@return ReGui.Widget
local function createWidgetWrapper(gui, parentWidget, widget)
    ---@class ReGui.Widget
    local output = {
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
            return widget.instanceProperties.name or ""
        end,

        getType = function (self)
            SelfAssert(self)
            return widget.instanceProperties.type or ""
        end,

        getSkin = function(self)
            SelfAssert(self)
            return widget.instanceProperties.skin or ""
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

            if not parentWidget then
                return nil
            end

            local parentWidgetName = parentWidget.instanceProperties.name
            if not parentWidgetName then
                return createWidgetWrapper(gui, nil, parentWidget)
            end

            local _, parentWidgetWidget = findWidgetRecursiveRaw(gui, parentWidgetName)

            return createWidgetWrapper(gui, parentWidgetWidget, parentWidget)
        end,

        getChildren = function(self)
            SelfAssert(self)

            local children = {}
            for _, child in pairs(widget.children) do
                table.insert(children, createWidgetWrapper(gui, widget, child))
            end
            return children
        end,

        getPosition = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                return { x = widget.positionSize.x, y = widget.positionSize.y }
            else
                local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
                return {
                    x = widget.positionSize.x * myguiScreenWidth,
                    y = widget.positionSize.y * myguiScreenHeight
                }
            end
        end,

        getPositionRealUnits = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
                return {
                    x = widget.positionSize.x / myguiScreenWidth,
                    y = widget.positionSize.y / myguiScreenHeight
                }
            else
                return { x = widget.positionSize.x, y = widget.positionSize.y }
            end
        end,

        getSize = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                return { x = widget.positionSize.width, y = widget.positionSize.height }
            else
                local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
                return {
                    x = widget.positionSize.width * myguiScreenWidth,
                    y = widget.positionSize.height * myguiScreenHeight
                }
            end
        end,

        getSizeRealUnits = function (self)
            SelfAssert(self)

            if widget.positionSize.usePixels then
                local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
                return {
                    x = widget.positionSize.width / myguiScreenWidth,
                    y = widget.positionSize.height / myguiScreenHeight
                }
            else
                return { x = widget.positionSize.width, y = widget.positionSize.height }
            end
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

            return unpack({widget.properties})
        end,

        setProperty = function(self, index, value)
            SelfAssert(self)
            AssertArgument(index, 1, {"string"})
            AssertArgument(value, 3, {"string", "number", "boolean", "table", "nil"})

            if index == "Caption" then
                -- Dont need to repack using tableRepack
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
                width  = 1080 / width
                height = 1920 / height
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
                width  = width  / 1920
                height = height / 1080
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
                x = 1080 * x
                y = 1920 * y
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
                x = x / 1920
                y = y / 1080
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

            table.insert(widget.children, newWidget)

            return createWidgetWrapper(gui, widget, newWidget)
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

            for _, controller in ipairs(widget.controllers or {}) do
                if controller.type == controllerType then
                    return createControllerWrapper(controller)
                end
            end

            return nil
        end,

        destroyController = function (self, controllerType)
            SelfAssert(self)
            AssertArgument(controllerType, 1, {"string"})

            for i, controller in ipairs(widget.controllers or {}) do
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

            gui:setText(widget.instanceProperties.name, ...)
        end,

        getText = function (self)
            SelfAssert(self)

            return (gui.modifiers[widget.instanceProperties.name] and gui.modifiers[widget.instanceProperties.name].text) and gui.modifiers[widget.instanceProperties.name].text.output or nil
        end,

        exists = function (self)
            SelfAssert(self)

            local widget, _ = findWidgetRecursiveRaw(gui, self:getName())
            return widget ~= nil
        end,

        hasChildren = function (self)
            SelfAssert(self)

            return #widget.children ~= 0
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

    return createWidgetWrapper(gui, parentChild, widget)
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
    return unpack({self.settings})
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
    return self.gui and self.gui:isActive()
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
    
    local repackedValue = tableRepack(...)

    self.modifiers[widgetName] = self.modifiers[widgetName] or {}
    self.modifiers[widgetName].text = {
        input = repackedValue,
        output = self.translatorFunction(unpack(repackedValue))
    }
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
                self.gui:setText(widgetName, data.text.output)
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

    return unpack({widget.properties})
end

print("Loaded custom functions! Now adding all GuiInterface functions...")

-- GuiInterface wrapping --

---@param self ReGui.GUI
function sm.regui:addGridItem(widgetName, item)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(item, 2, "table")

    table.insert(self.commands, {"addGridItem", {widgetName, item}})
    runPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:addGridItemsFromFile(gridName, jsonPath, additionalData)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(jsonPath, 2, {"string"})
    AssertArgument(additionalData, 3, {"table"})

    table.insert(self.commands, {"addGridItemsFromFile", {gridName, jsonPath, additionalData}})
    runPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:addListItem(listName, itemName, data)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})
    AssertArgument(itemName, 2, {"string"})
    AssertArgument(data, 3, {"table"})

    table.insert(self.commands, {"addListItem", {listName, itemName, data}})
    runPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:clearGrid(gridName)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})

    table.insert(self.commands, {"clearGrid", {gridName}})
    runPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:clearList(listName)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})

    table.insert(self.commands, {"clearList", {listName}})
    runPreviousCommand(self)
end

function sm.regui:createDropDown(widgetName, functionName, options)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(functionName, 2, {"string"})
    AssertArgument(options, 3, {"table"})

    table.insert(self.commands, {"createDropDown", {widgetName, functionName, options}})
    runPreviousCommand(self)
end

function sm.regui:createGridFromJson(gridName, data)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(data, 2, {"table"})

    ValueAssert(type(data.type      ) == "string", 2, "data.type is expected to be a string")
    ValueAssert(type(data.layout    ) == "string", 2, "data.layout is expected to be a string")
    ValueAssert(type(data.itemWidth ) == "number", 2, "data.itemWidth is expected to be a number")
    ValueAssert(type(data.itemHeight) == "number", 2, "data.itemHeight is expected to be a number")
    ValueAssert(type(data.itemCount ) == "number", 2, "data.itemCount is expected to be a number")

    table.insert(self.commands, {"createGridFromJson", {gridName, data}})
    runPreviousCommand(self)
end


function sm.regui:createHorizontalSlider(widgetName, range, value, callback, enableNumbers)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(range, 2, {"table"})
    AssertArgument(value, 3, {"number"})
    AssertArgument(callback, 4, {"string"})
    AssertArgument(enableNumbers, 5, {"boolean", "nil"})

    if enableNumbers == nil then
        enableNumbers = false
    end

    table.insert(self.commands, {"createHorizontalSlider", {widgetName, range, value, callback, enableNumbers}})
    runPreviousCommand(self)
end

function sm.regui:createVerticalSlider(widgetName, range, value, callback)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(range, 2, {"table"})
    AssertArgument(value, 3, {"number"})
    AssertArgument(callback, 4, {"string"})

    table.insert(self.commands, {"createVerticalSlider", {widgetName, range, value, callback}})
    runPreviousCommand(self)
end

function sm.regui:destroy()
    SelfAssert(self)
    warn("UNIMPLEMENTED destroy")
end

function sm.regui:playEffect(widget, effect, restart)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(effect, 2, {"string"})
    AssertArgument(restart, 3, {"boolean"})

    table.insert(self.commands, {"playEffect", {widget, effect, restart}})
    runPreviousCommand(self)
end

function sm.regui:playGridEffect(gridName, index, effectName, restart)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(index, 2, {"number"})
    AssertArgument(effectName, 3, {"string"})
    AssertArgument(restart, 4, {"boolean"})

    table.insert(self.commands, {"playGridEffect", {gridName, index, effectName, restart}})
    runPreviousCommand(self)
end

function sm.regui:setButtonCallback(button, callback)
    SelfAssert(self)
    AssertArgument(button, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setButtonCallback", {button, callback}})
    runPreviousCommand(self)
end

function sm.regui:setButtonState(button, state)
    SelfAssert(self)
    AssertArgument(button, 1, {"string"})
    AssertArgument(state, 2, {"boolean"})

    table.insert(self.commands, {"setButtonState", {button, state}})
    runPreviousCommand(self)
end

function sm.regui:setColor(widget, color)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(color, 2, {"Color"})

    table.insert(self.commands, {"setColor", {widget, color}})
    runPreviousCommand(self)
end

function sm.regui:setContainer(gridName, container)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(container, 2, {"Container"})

    table.insert(self.commands, {"setContainer", {gridName, container}})
    runPreviousCommand(self)
end

function sm.regui:setContainers(gridName, containers)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(containers, 2, {"table"})

    for i, container in ipairs(containers) do
        ValueAssert(type(container) == "Container", 2, "container is expected to be a Container")
    end

    table.insert(self.commands, {"setContainers", {gridName, containers}})
    runPreviousCommand(self)
end

function sm.regui:setFadeRange(range)
    SelfAssert(self)
    AssertArgument(range, 1, {"number"})

    table.insert(self.commands, {"setFadeRange", {range}})
    runPreviousCommand(self)
end

function sm.regui:setFocus(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})

    table.insert(self.commands, {"setFocus", {widget}})
    runPreviousCommand(self)
end

function sm.regui:setGridButtonCallback(buttonName, callback)
    SelfAssert(self)
    AssertArgument(buttonName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setGridButtonCallback", {buttonName, callback}})
    runPreviousCommand(self)
end

function sm.regui:setGridItem(gridName, index, item)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(index, 2, {"number"})
    AssertArgument(item, 3, {"table"})

    table.insert(self.commands, {"setGridItem", {gridName, index, item}})
    runPreviousCommand(self)
end

function sm.regui:setGridItemChangedCallback(gridName, callback)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setGridItemChangedCallback", {gridName, callback}})
    runPreviousCommand(self)
end

function sm.regui:setGridMouseFocusCallback(widgetName, callbackName, gridName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(callbackName, 2, {"string"})
    AssertArgument(gridName, 3, {"string"})

    table.insert(self.commands, {"setGridMouseFocusCallback", {widgetName, callbackName, gridName}})
    runPreviousCommand(self)
end

function sm.regui:setGridSize(gridName, size)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(size, 2, {"number"})

    table.insert(self.commands, {"setGridSize", {gridName, size}})
    runPreviousCommand(self)
end

function sm.regui:setHost(widget, host, joint)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(host, 2, {"Shape", "Character"})
    AssertArgument(joint, 3, {"string", "nil"})  -- optional

    table.insert(self.commands, {"setHost", {widget, host, joint}})
    runPreviousCommand(self)
end

function sm.regui:setIconImage(itemBox, uuid)
    SelfAssert(self)
    AssertArgument(itemBox, 1, {"string"})
    AssertArgument(uuid, 2, {"Uuid"})

    table.insert(self.commands, {"setIconImage", {itemBox, uuid}})
    runPreviousCommand(self)
end

function sm.regui:setImage(imageBox, image)
    SelfAssert(self)
    AssertArgument(imageBox, 1, {"string"})
    AssertArgument(image, 2, {"string"})

    table.insert(self.commands, {"setImage", {imageBox, image}})
    runPreviousCommand(self)
end

function sm.regui:setItemIcon(imageBox, itemResource, itemGroup, itemName)
    SelfAssert(self)
    AssertArgument(imageBox, 1, {"string"})
    AssertArgument(itemResource, 2, {"string"})
    AssertArgument(itemGroup, 3, {"string"})
    AssertArgument(itemName, 4, {"string"})

    table.insert(self.commands, {"setItemIcon", {imageBox, itemResource, itemGroup, itemName}})
    runPreviousCommand(self)
end

function sm.regui:setListSelectionCallback(listName, callback)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setListSelectionCallback", {listName, callback}})
    runPreviousCommand(self)
end

function sm.regui:setMaxRenderDistance(distance)
    SelfAssert(self)
    AssertArgument(distance, 1, {"number"})

    table.insert(self.commands, {"setMaxRenderDistance", {distance}})
    runPreviousCommand(self)
end

function sm.regui:setMeshPreview(widgetName, uuid)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(uuid, 2, {"Uuid"})

    table.insert(self.commands, {"setMeshPreview", {widgetName, uuid}})
    runPreviousCommand(self)
end

function sm.regui:setOnCloseCallback(callback)
    SelfAssert(self)
    AssertArgument(callback, 1, {"string"})

    table.insert(self.commands, {"setOnCloseCallback", {callback}})
    runPreviousCommand(self)
end

function sm.regui:setRequireLineOfSight(state)
    SelfAssert(self)
    AssertArgument(state, 1, {"boolean"})

    table.insert(self.commands, {"setRequireLineOfSight", {state}})
    runPreviousCommand(self)
end

function sm.regui:setSelectedDropDownItem(dropDownName, itemName)
    SelfAssert(self)
    AssertArgument(dropDownName, 1, {"string"})
    AssertArgument(itemName, 2, {"string"})

    table.insert(self.commands, {"setSelectedDropDownItem", {dropDownName, itemName}})
    runPreviousCommand(self)
end

function sm.regui:setSelectedListItem(listName, itemName)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})
    AssertArgument(itemName, 2, {"string"})

    table.insert(self.commands, {"setSelectedListItem", {listName, itemName}})
    runPreviousCommand(self)
end

function sm.regui:setSliderCallback(sliderName, callback)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setSliderCallback", {sliderName, callback}})
    runPreviousCommand(self)
end

function sm.regui:setSliderData(sliderName, range, position)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(range, 2, {"number"})
    AssertArgument(position, 3, {"number"})

    table.insert(self.commands, {"setSliderData", {sliderName, range, position}})
    runPreviousCommand(self)
end

function sm.regui:setSliderPosition(sliderName, position)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(position, 2, {"number"})

    table.insert(self.commands, {"setSliderPosition", {sliderName, position}})
    runPreviousCommand(self)
end

function sm.regui:setSliderRange(sliderName, range)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(range, 2, {"number"})

    table.insert(self.commands, {"setSliderRange", {sliderName, range}})
    runPreviousCommand(self)
end

function sm.regui:setSliderRangeLimit(sliderName, limit)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(limit, 2, {"number"})

    table.insert(self.commands, {"setSliderRangeLimit", {sliderName, limit}})
    runPreviousCommand(self)
end

function sm.regui:setTextAcceptedCallback(editboxName, callback)
    SelfAssert(self)
    AssertArgument(editboxName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setTextAcceptedCallback", {editboxName, callback}})
    runPreviousCommand(self)
end

function sm.regui:setTextChangedCallback(editboxName, callback)
    SelfAssert(self)
    AssertArgument(editboxName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setTextChangedCallback", {editboxName, callback}})
    runPreviousCommand(self)
end

function sm.regui:setVisible(widget, state)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(state, 2, {"boolean"})

    table.insert(self.commands, {"setVisible", {widget, state}})
    runPreviousCommand(self)
end

function sm.regui:setWorldPosition(pos, world)
    SelfAssert(self)
    AssertArgument(pos, 1, {"Vec3"})
    AssertArgument(world, 2, {"World"})

    table.insert(self.commands, {"setWorldPosition", {pos, world}})
    runPreviousCommand(self)
end

function sm.regui:stopEffect(widget, effect, immediate)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(effect, 2, {"string"})
    AssertArgument(immediate, 3, {"boolean"})

    table.insert(self.commands, {"stopEffect", {widget, effect, immediate}})
    runPreviousCommand(self)
end

function sm.regui:stopGridEffect(gridName, index, effectName)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(index, 2, {"number"})
    AssertArgument(effectName, 3, {"string"})

    table.insert(self.commands, {"stopGridEffect", {gridName, index, effectName}})
    runPreviousCommand(self)
end

function sm.regui:trackQuest(name, title, mainQuest, questTasks)
    SelfAssert(self)
    AssertArgument(name, 1, {"string"})
    AssertArgument(title, 2, {"string"})
    AssertArgument(mainQuest, 3, {"boolean"})
    AssertArgument(questTasks, 4, {"table"})

    -- QuestTasks structure
    --    {
    --      name = string,
    --      text = string,
    --      count = number,
    --      target = number,
    --      complete = bool
    --    }
    AssertArgument(questTasks.name, 4, {"string"})
    AssertArgument(questTasks.text, 4, {"string"})
    AssertArgument(questTasks.count, 4, {"number"})
    AssertArgument(questTasks.target, 4, {"number"})
    AssertArgument(questTasks.complete, 4, {"boolean"})

    table.insert(self.commands, {"trackQuest", {name, title, mainQuest, questTasks}})
    runPreviousCommand(self)
end

function sm.regui:untrackQuest(name)
    SelfAssert(self)
    AssertArgument(name, 1, {"string"})

    table.insert(self.commands, {"untrackQuest", {name}})
    runPreviousCommand(self)
end

-- Load additional libaries

dofile("./TemplateManager.lua")
dofile("./FullscreenGui.lua")
dofile("./FontManager.lua")

print("Library fully loaded!")

---@class MainToolClass : ToolClass
MainToolClass = class()