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

    if screenWidth <= 1280 and screenHeight <= 720 then
        return 1280, 720
    elseif screenWidth <= 1920 and screenHeight <= 1080 then
        return 1920, 1080
    elseif screenWidth < 3840 and screenHeight < 2160 then
        return 2560, 1440
    else
        return 3840, 2160
    end
end

--
-- MAIN LIBRARY
--

sm.log.info("[SM ReGui] ----- Scrap Mechanic ReGui - The new way of making advanced user interfaces -----")

---@class sm.regui
sm.regui = {}
sm.regui.version = sm.json.open("$CONTENT_DATA/version.json") ---@type number

dofile("./Logger.lua")

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
    assert(type(path) == "string", "path is expected to be a string!")
    assert(sm.json.fileExists(path), "File not found!")

    print("Creating new gui interface...")

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

    assert(self.data.identifier == "ReGui", "Not a ReGui Layout File!")
    assert(self.data.version == sm.regui.version, "ReGui version mismatch!")

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
                self.modifiers[name] = self.modifiers[name] or {}
                self.modifiers[name].text = {
                    input = type(value) == "table" and value or { value },
                    output = self.translatorFunction(value)
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
    print("Creating new blank gui...")

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
    assert(type(self) == "table", "Invalid ReGuiInstance!")
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
                output = output .. "<Property key=\"" .. key .. "\" value=\"" .. escapeXMLString(tostring(value)) .. "\"/>"
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
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    self:close()
    self:render()

    self.gui = sm.gui.createGuiFromLayout(self.renderedPath, true, self.settings)

    self:rerunTranslations()

    for _, command in pairs(self.commands or {}) do
        self.gui[command[1]](self.gui, unpack(command[2]))
    end

    self.gui:open()
end

function sm.regui:close()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    if sm.exists(self.gui) then
        self.gui:close()
    end
end

---@param gui ReGui.GUI
local function runPreviousCommand(gui)
    local latestCommand = gui.commands[#gui.commands]
    local guiInterface = gui.gui
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
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(position) == "table", "position is expected to be a table with 'x' and 'y' keys or indices")

    local xVal = position.x ~= nil and position.x or position[1]
    local yVal = position.y ~= nil and position.y or position[2]
    assert(type(xVal) == "number", "'x' (or index 1) not found or was not a number")
    assert(type(yVal) == "number", "'y' (or index 2) not found or was not a number")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    local current = widget.positionSize
    local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
    local screenWidth, screenHeight = sm.gui.getScreenSize()
    
    local x = sm.util.clamp(math.floor(xVal), 0, screenWidth)
    local y = sm.util.clamp(math.floor(yVal), 0, screenHeight)

    local width = current.width
    local height = current.height

    if not current.usePixels then
        width  = math.floor(myguiScreenWidth  / width)
        height = math.floor(myguiScreenHeight / height)
    end

    widget.positionSize = {
        usePixels = true,
        x         = x,
        y         = y,
        width     = width,
        height    = height
    }
end

function sm.regui:setWidgetPositionPercentage(widgetName, position)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(position) == "table", "position is expected to be a table with 'x' and 'y' keys or indices")

    local xVal = position.x ~= nil and position.x or position[1]
    local yVal = position.y ~= nil and position.y or position[2]
    assert(type(xVal) == "number", "'x' (or index 1) not found or was not a number")
    assert(type(yVal) == "number", "'y' (or index 2) not found or was not a number")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    local current = widget.positionSize
    local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()

    local x = sm.util.clamp(xVal, 0, 1)
    local y = sm.util.clamp(yVal, 0, 1)

    local width = current.width
    local height = current.height

    -- Convert pixel dimensions to percentages if needed
    if current.usePixels then
        width  = width  / myguiScreenWidth
        height = height / myguiScreenHeight
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
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(size) == "table", "size is expected to be a table with 'width' and 'height' keys or indices")

    local widthVal = size.x ~= nil and size.x or size[1]
    local heightVal = size.y ~= nil and size.y or size[2]
    assert(type(widthVal) == "number", "'width' (or index 1) not found or was not a number")
    assert(type(heightVal) == "number", "'height' (or index 2) not found or was not a number")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    local current = widget.positionSize
    local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
    local screenWidth, screenHeight = sm.gui.getScreenSize()

    local width = sm.util.clamp(math.floor(widthVal), 0, screenWidth)
    local height = sm.util.clamp(math.floor(heightVal), 0, screenHeight)

    local x = current.x
    local y = current.y

    if not current.usePixels then
        x = math.floor(myguiScreenWidth  * x)
        y = math.floor(myguiScreenHeight * y)
    end

    widget.positionSize = {
        usePixels = true,
        x         = x,
        y         = y,
        width     = width,
        height    = height
    }
end

function sm.regui:setWidgetSizePercentage(widgetName, size)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(size) == "table", "size is expected to be a table with 'width' and 'height' keys or indices")

    local widthVal = size.x ~= nil and size.x or size[1]
    local heightVal = size.y ~= nil and size.y or size[2]
    assert(type(widthVal) == "number", "'width' (or index 1) not found or was not a number")
    assert(type(heightVal) == "number", "'height' (or index 2) not found or was not a number")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    local current = widget.positionSize
    local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()

    local width = sm.util.clamp(widthVal, 0, 1)
    local height = sm.util.clamp(heightVal, 0, 1)

    local x = current.x
    local y = current.y

    if current.usePixels then
        x = x / myguiScreenWidth
        y = y / myguiScreenHeight
    end

    widget.positionSize = {
        usePixels = false,
        x         = x,
        y         = y,
        width     = width,
        height    = height
    }
end

function sm.regui:setProperty(widgetName, index, value)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(index) == "string", "index is expected to be a string")
    assert(value ~= nil, "value cannot be nil")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    widget.properties[index] = tostring(value)
end

function sm.regui:getProperty(widgetName, index)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(index) == "string", "index is expected to be a string")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    return widget.properties[index]
end

function sm.regui:widgetExists(widgetName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")

    local widget, _ = FindWidgetRecursiveRaw(self, widgetName)
    return widget ~= nil
end

local function createControllerWrapper(controller, widget)
    return {
        getType = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            return controller.type
        end,

        setType = function(self, newType)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(newType) == "string", "newType is expected to be a string")
            
            controller.type = newType
        end,

        getProperties = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            return unpack({controller.properties})
        end,

        setProperty = function(self, key, value)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(key) == "string", "key is expected to be a string")
            assert(value ~= nil, "value cannot be nil")

            if type(value) == "table" and (value[1] or value.x) and (value[2] or value.y) then
                controller.properties[key] = value
            else
                controller.properties[key] = tostring(value)
            end
        end,

        getProperty = function(self, key)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(key) == "string", "key is expected to be a string")

            return controller.properties[key]
        end,

        getRawContents = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            return controller
        end,

        destroy = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

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
        getName = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            return widget.instanceProperties.name or ""
        end,

        getType = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            return widget.instanceProperties.type
        end,

        getSkin = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            return widget.instanceProperties.skin
        end,

        getParent = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            return parentWidget and CreateWidgetWrapper(gui, nil, parentWidget) or nil
        end,

        getChildren = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            local children = {}
            for _, child in pairs(widget.children) do
                table.insert(children, CreateWidgetWrapper(gui, widget, child))
            end
            return children
        end,

        getPosition = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

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

        getPositionPercentage = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

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
            assert(type(self) == "table", "Invalid ReGuiInstance!")

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

        getSizePercentage = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

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

        getProperties = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            return unpack({widget.properties})
        end,

        setProperty = function(self, index, value)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(index) == "string", "index is expected to be a string")
            assert(value ~= nil, "value cannot be nil")

            if index == "Caption" then
                local translatedText = gui.translatorFunction(value)

                gui.modifiers[widget.instanceProperties.name] = gui.modifiers[widget.instanceProperties.name] or {}
                gui.modifiers[widget.instanceProperties.name].text = {
                    input = {value},
                    output = tostring(translatedText)
                }
            end
            
            widget.properties[index] = tostring(value)
        end,

        getProperty = function(self, index)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(index) == "string", "index is expected to be a string")

            return widget.properties[index]
        end,

        setInstanceProperty = function(self, key, value)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(key) == "string", "key is expected to be a string")
            assert(value ~= nil, "value cannot be nil")

            widget.instanceProperties[key] = tostring(value)
        end,

        getInstanceProperty = function(self, key)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(key) == "string", "key is expected to be a string")

            return widget.instanceProperties[key]
        end,

        setPosition = function(self, position)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(position) == "table", "position is expected to be a table with 'x' and 'y' keys or indices")

            local xVal = position.x ~= nil and position.x or position[1]
            local yVal = position.y ~= nil and position.y or position[2]
            assert(type(xVal) == "number", "'x' (or index 1) not found or was not a number")
            assert(type(yVal) == "number", "'y' (or index 2) not found or was not a number")

            local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
            local screenWidth, screenHeight = sm.gui.getScreenSize()
            local x = sm.util.clamp(math.floor(xVal), 0, screenWidth)
            local y = sm.util.clamp(math.floor(yVal), 0, screenHeight)

            local width = widget.positionSize.width
            local height = widget.positionSize.height

            if not widget.positionSize.usePixels then
                width  = math.floor(myguiScreenWidth  / width)
                height = math.floor(myguiScreenHeight / height)
            end

            widget.positionSize = {
                usePixels = true,
                x         = x,
                y         = y,
                width     = width,
                height    = height
            }
        end,

        setPositionPercentage = function(self, position)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(position) == "table", "position is expected to be a table with 'x' and 'y' keys or indices")

            local xVal = position.x ~= nil and position.x or position[1]
            local yVal = position.y ~= nil and position.y or position[2]
            assert(type(xVal) == "number", "'x' (or index 1) not found or was not a number")
            assert(type(yVal) == "number", "'y' (or index 2) not found or was not a number")

            local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()            
            local x = sm.util.clamp(xVal, 0, 1)
            local y = sm.util.clamp(yVal, 0, 1)

            local width = widget.positionSize.width
            local height = widget.positionSize.height

            if widget.positionSize.usePixels then
                width  = width / myguiScreenWidth
                height = height / myguiScreenHeight
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
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(size) == "table", "size is expected to be a table with 'width' and 'height' keys or indices")

            local widthVal = size.x ~= nil and size.x or size[1]
            local heightVal = size.y ~= nil and size.y or size[2]
            assert(type(widthVal) == "number", "'width' (or index 1) not found or was not a number")
            assert(type(heightVal) == "number", "'height' (or index 2) not found or was not a number")

            local myguiScreenWidth, myguiScreenHeight = getMyGuiScreenSize()
            local screenWidth, screenHeight = sm.gui.getScreenSize()
            local width = sm.util.clamp(math.floor(widthVal), 0, screenWidth)
            local height = sm.util.clamp(math.floor(heightVal), 0, screenHeight)

            local x = widget.positionSize.x
            local y = widget.positionSize.y

            if not widget.positionSize.usePixels then
                x = math.floor(myguiScreenWidth * x)
                y = math.floor(myguiScreenHeight * y)
            end

            widget.positionSize = {
                usePixels = true,
                x         = x,
                y         = y,
                width     = width,
                height    = height
            }
        end,

        setSizePercentage = function(self, size)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(size) == "table", "size is expected to be a table with 'width' and 'height' keys or indices")

            local widthVal = size.x ~= nil and size.x or size[1]
            local heightVal = size.y ~= nil and size.y or size[2]
            assert(type(widthVal) == "number", "'width' (or index 1) not found or was not a number")
            assert(type(heightVal) == "number", "'height' (or index 2) not found or was not a number")

            local screenWidth, screenHeight = getMyGuiScreenSize()
            local width  = sm.util.clamp(widthVal , 0, 1)
            local height = sm.util.clamp(heightVal, 0, 1)

            local x = widget.positionSize.x
            local y = widget.positionSize.y

            if widget.positionSize.usePixels then
                x = x / screenWidth
                y = y / screenHeight
            end

            widget.positionSize = {
                usePixels = false,
                x         = x,
                y         = y,
                width     = width,
                height    = height
            }
        end,

        exists = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            if parentWidget then
                for _, child in ipairs(parentWidget.children) do
                    if child.instanceProperties.name == widget.instanceProperties.name then
                        return true
                    end
                end
            else
                for _, child in ipairs(gui.data.data) do
                    if child.instanceProperties.name == widget.instanceProperties.name then
                        return true
                    end
                end
            end

            return false
        end,

        destroy = function(self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            if parentWidget then
                for i, child in ipairs(parentWidget.children) do
                    if child.instanceProperties.name == widget.instanceProperties.name then
                        table.remove(parentWidget.children, i)
                        return true
                    end
                end
            else
                for i, child in ipairs(gui.data.data) do
                    if child.instanceProperties.name == widget.instanceProperties.name then
                        table.remove(gui.data.data, i)
                        return true
                    end
                end
            end

            return false
        end,

        createWidget = function(self, widgetName)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            assert(type(widgetName) == "string", "widgetName is expected to be a string")

            print("Creating widget \"" .. widgetName .. "\" inside \"" .. (self:getName() ~= "" and self:getName() or "(unnamed)") .. "\"")

            local newWidget = {
                instanceProperties = { name = widgetName, type = "Widget", skin = "PanelEmpty" },
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

            return CreateWidgetWrapper(gui, widget, newWidget)
        end,

        getRawWidgetContents = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            return widget
        end,

        createController = function (self, controllerType)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(controllerType) == "string", "controllerType is expected to be a string")

            print("Creating controller for widget \"" .. (self:getName() ~= "" and self:getName() or "(unnamed)") .. "\": " .. controllerType)

            local controller = {
                type = controllerType,
                properties = {},
            }

            widget.controllers = widget.controllers or {}
            table.insert(widget.controllers, controller)

            return CreateControllerWrapper(controller, widget)
        end,

        findController = function (self, controllerType)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(controllerType) == "string", "controllerType is expected to be a string")

            for _, controller in ipairs(widget.controllers or {}) do
                if controller.type == controllerType then
                    return CreateControllerWrapper(controller, widget)
                end
            end

            return nil
        end,

        destroyController = function (self, controllerType)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(controllerType) == "string", "controllerType is expected to be a string")

            for i, controller in ipairs(widget.controllers or {}) do
                if controller.type == controllerType then
                    table.remove(widget.controllers, i)
                    return true
                end
            end

            return false
        end,

        setVisible = function (self, visible)
            assert(type(self) == "table", "Invalid ReGuiInstance!")
            assert(type(visible) == "boolean", "visible is expected to be a boolean")

            gui:setVisible(widget.instanceProperties.name, visible)
        end,

        setText = function (self, ...)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            local translatedText = gui.translatorFunction(...)

            gui.modifiers[widget.instanceProperties.name] = gui.modifiers[widget.instanceProperties.name] or {}
            gui.modifiers[widget.instanceProperties.name].text = {
                input = {...},
                output = tostring(translatedText)
            }
        end,

        getText = function (self)
            assert(type(self) == "table", "Invalid ReGuiInstance!")

            return (gui.modifiers[widget.instanceProperties.name] and gui.modifiers[widget.instanceProperties.name].text) and gui.modifiers[widget.instanceProperties.name].text.output or nil
        end
    }

    return output
end

---@param self ReGui.GUI
function sm.regui:findWidgetRecursive(widgetName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")

    local widget, parentChild = FindWidgetRecursiveRaw(self, widgetName)
    if not widget then
        return nil
    end

    return CreateWidgetWrapper(gui, parentChild, widget)
end

---@param self ReGui.GUI
function sm.regui:findWidget(widgetName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")

    for _, child in pairs(self.data.data) do
        if child.instanceProperties.name and child.instanceProperties.name == widgetName then
            return CreateWidgetWrapper(self, nil, child)
        end
    end
end

---@param self ReGui.GUI
function sm.regui:getChildren()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    local children = {}

    for _, child in pairs(self.data.data) do
        table.insert(children, CreateWidgetWrapper(self, nil, child))
    end

    return children
end

---@param self ReGui.GUI
function sm.regui:createWidget(widgetName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")    

    print("Creating widget \"" .. widgetName .. "\"...")

    ---@type ReGui.LayoutFile.Widget
    local widget = {
        instanceProperties = { name = widgetName, type = "Widget", skin = "PanelEmpty" },
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
    
    return CreateWidgetWrapper(self, nil, widget)
end

---@param self ReGui.GUI
function sm.regui:getSettings()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    return unpack({self.settings})
end

---@param self ReGui.GUI
function sm.regui:setSettings(settings)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(settings) == "table", "settings is expected to be a table")

    self.settings = settings
end

---@param self ReGui.GUI
function sm.regui:isActive()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    return self.gui and self.gui:isActive()
end

---@param self ReGui.GUI
function sm.regui:getRawContents()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    return self.data
end

---@param self ReGui.GUI
function sm.regui:setTextTranslation(translatorFunction)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(translatorFunction) == "function", "translatorFunction is expected to be a function")

    self.translatorFunction = translatorFunction
end

---@param self ReGui.GUI
function sm.regui:setText(widgetName, ...)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    local translatedText = self.translatorFunction(...)

    self.modifiers[widgetName] = self.modifiers[widgetName] or {}
    self.modifiers[widgetName].text = {
        input = {...},
        output = tostring(translatedText)
    }
end

---@param self ReGui.GUI
function sm.regui:getText(widgetName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")

    return (self.modifiers[widgetName] and self.modifiers[widgetName].text) and self.modifiers[widgetName].text.output or nil
end

function sm.regui:rerunTranslations()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    for widgetName, data in pairs(self.modifiers) do
        if data.text then
            local translatedText = self.translatorFunction(unpack(data.text.input))
            data.text.output = tostring(translatedText)
            
            if self.gui and sm.exists(self.gui) then
                self.gui:setText(widgetName, data.text.output)
            end
        end
    end
end

function sm.regui:setData(widgetName, data)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    
    local widget = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    for key, value in pairs(data) do
        widget.properties[key] = value
        if key == "Caption" then
            self:setText(widgetName, value)
        end
    end
end

function sm.regui:getData(widgetName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")

    local widget = FindWidgetRecursiveRaw(self, widgetName)
    assert(widget, "Widget not found!")

    return unpack({widget.properties})
end

print("Loaded custom functions! Now adding all GuiInterface functions...")

-- GuiInterface wrapping --

---@param self ReGui.GUI
function sm.regui:addGridItem(widgetName, item)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(item) == "table", "item is expected to be a table")

    table.insert(self.commands, {"addGridItem", {widgetName, item}})
    RunPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:addGridItemsFromFile(gridName, jsonPath, additionalData)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(jsonPath) == "string", "jsonPath is expected to be a string")
    assert(type(additionalData) == "table", "additionalData is expected to be a table")

    table.insert(self.commands, {"addGridItemsFromFile", {gridName, jsonPath, additionalData}})
    RunPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:addListItem(listName, itemName, data)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(listName) == "string", "listName is expected to be a string")
    assert(type(itemName) == "string", "itemName is expected to be a string")
    assert(type(data) == "table", "data is expected to be a table")

    table.insert(self.commands, {"addListItem", {listName, itemName, data}})
    RunPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:clearGrid(gridName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")

    table.insert(self.commands, {"clearGrid", {gridName}})
    RunPreviousCommand(self)
end

---@param self ReGui.GUI
function sm.regui:clearList(listName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(listName) == "string", "listName is expected to be a string")

    table.insert(self.commands, {"clearList", {listName}})
    RunPreviousCommand(self)
end

function sm.regui:createDropDown(widgetName, functionName, options)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(functionName) == "string", "functionName is expected to be a string")
    assert(type(options) == "table", "options is expected to be a table")

    table.insert(self.commands, {"createDropDown", {widgetName, functionName, options}})
    RunPreviousCommand(self)
end

function sm.regui:createGridFromJson(gridName, data)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(data) == "table", "data is expected to be a table")

    -- Data structure
    -- {
    -- 	type = string,
    -- 	layout = string,
    -- 	itemWidth = int,
    -- 	itemHeight = int,
    -- 	itemCount = int
    -- }

    assert(type(data.type) == "string", "data.type is expected to be a string")
    assert(type(data.layout) == "string", "data.layout is expected to be a string")
    assert(type(data.itemWidth) == "number", "data.itemWidth is expected to be a number")
    assert(type(data.itemHeight) == "number", "data.itemHeight is expected to be a number")
    assert(type(data.itemCount) == "number", "data.itemCount is expected to be a number")

    table.insert(self.commands, {"createGridFromJson", {gridName, data}})
    RunPreviousCommand(self)
end

function sm.regui:createHorizontalSlider(widgetName, range, value, callback, enableNumbers)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(range) == "table", "range is expected to be a table")
    assert(type(value) == "number", "value is expected to be a number")
    assert(type(callback) == "string", "callback is expected to be a string")
    
    if enableNumbers ~= nil then
        assert(type(enableNumbers) == "boolean", "enableNumbers is expected to be a boolean")
    else
        enableNumbers = false
    end

    table.insert(self.commands, {"createHorizontalSlider", {widgetName, range, value, callback, enableNumbers}})
    RunPreviousCommand(self)
end

function sm.regui:createVerticalSlider(widgetName, range, value, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(range) == "table", "range is expected to be a table")
    assert(type(value) == "number", "value is expected to be a number")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"createVerticalSlider", {widgetName, range, value, callback}})
    RunPreviousCommand(self)
end

function sm.regui:destroy()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    warn("UNIMPLEMENTED destroy")
end

function sm.regui:playEffect(widget, effect, restart)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widget) == "string", "widget is expected to be a string")
    assert(type(effect) == "string", "effect is expected to be a string")
    assert(type(restart) == "boolean", "restart is expected to be a boolean")

    table.insert(self.commands, {"playEffect", {widget, effect, restart}})
    RunPreviousCommand(self)
end

function sm.regui:playGridEffect(gridName, index, effectName, restart)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(index) == "number", "index is expected to be a number")
    assert(type(effectName) == "string", "effectName is expected to be a string")
    assert(type(restart) == "boolean", "restart is expected to be a boolean")

    table.insert(self.commands, {"playGridEffect", {gridName, index, effectName, restart}})
    RunPreviousCommand(self)
end

function sm.regui:setButtonCallback(button, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(button) == "string", "button is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setButtonCallback", {button, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setButtonState(button, state)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(button) == "string", "button is expected to be a string")
    assert(type(state) == "boolean", "state is expected to be a boolean")

    table.insert(self.commands, {"setButtonState", {button, state}})
    RunPreviousCommand(self)
end

function sm.regui:setColor(widget, color)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widget) == "string", "widget is expected to be a string")
    assert(type(color) == "Color", "color is expected to be a Color")

    table.insert(self.commands, {"setColor", {widget, color}})
    RunPreviousCommand(self)
end

function sm.regui:setContainer(gridName, container)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(container) == "Container", "container is expected to be a Container")

    table.insert(self.commands, {"setContainer", {gridName, container}})
    RunPreviousCommand(self)
end

function sm.regui:setContainers(gridName, containers)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(containers) == "table", "containers is expected to be a table")

    for i, container in ipairs(containers) do
        assert(type(container) == "Container", "container is expected to be a Container")
    end

    table.insert(self.commands, {"setContainers", {gridName, containers}})
    RunPreviousCommand(self)
end

function sm.regui:setFadeRange(range)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(range) == "number", "range is expected to be a number")
    
    table.insert(self.commands, {"setFadeRange", {range}})
    RunPreviousCommand(self)
end

function sm.regui:setFocus(widget)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widget) == "string", "widget is expected to be a string")

    table.insert(self.commands, {"setFocus", {widget}})
    RunPreviousCommand(self)
end

function sm.regui:setGridButtonCallback(buttonName, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(buttonName) == "string", "buttonName is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setGridButtonCallback", {buttonName, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setGridItem(gridName, index, item)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(index) == "number", "index is expected to be a number")
    assert(type(item) == "table", "item is expected to be a table")

    table.insert(self.commands, {"setGridItem", {gridName, index, item}})
    RunPreviousCommand(self)
end

function sm.regui:setGridItemChangedCallback(gridName, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setGridItemChangedCallback", {gridName, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setGridMouseFocusCallback(widgetName, callbackName, gridName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(callbackName) == "string", "callbackName is expected to be a string")
    assert(type(gridName) == "string", "gridName is expected to be a string")

    table.insert(self.commands, {"setGridMouseFocusCallback", {widgetName, callbackName, gridName}})
    RunPreviousCommand(self)
end

function sm.regui:setGridSize(gridName, size)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(size) == "number", "size is expected to be a number")

    table.insert(self.commands, {"setGridSize", {gridName, size}})
    RunPreviousCommand(self)
end

function sm.regui:setHost(widget, host, joint)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widget) == "string", "widget is expected to be a string")
    assert(type(host) == "Shape" or type(host) == "Character", "host is expected to be a Shape or a Character")
    
    if joint ~= nil then
        assert(type(joint) == "string", "joint is expected to be a string")
    end

    table.insert(self.commands, {"setHost", {widget, host, joint}})
    RunPreviousCommand(self)
end

function sm.regui:setIconImage(itemBox, uuid)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(itemBox) == "string", "itemBox is expected to be a string")
    assert(type(uuid) == "Uuid", "uuid is expected to be a string")

    table.insert(self.commands, {"setIconImage", {itemBox, uuid}})
    RunPreviousCommand(self)
end

function sm.regui:setImage(imageBox, image)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(imageBox) == "string", "imageBox is expected to be a string")
    assert(type(image) == "string", "image is expected to be a string")

    table.insert(self.commands, {"setImage", {imageBox, image}})
    RunPreviousCommand(self)
end

function sm.regui:setItemIcon(imageBox, itemResource, itemGroup, itemName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(imageBox) == "string", "imageBox is expected to be a string")
    assert(type(itemResource) == "string", "itemResource is expected to be a string")
    assert(type(itemGroup) == "string", "itemGroup is expected to be a string")
    assert(type(itemName) == "string", "itemName is expected to be a string")

    table.insert(self.commands, {"setItemIcon", {imageBox, itemResource, itemGroup, itemName}})
    RunPreviousCommand(self)
end

function sm.regui:setListSelectionCallback(listName, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(listName) == "string", "listName is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setListSelectionCallback", {listName, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setMaxRenderDistance(distance)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(distance) == "number", "distance is expected to be a number")

    table.insert(self.commands, {"setMaxRenderDistance", {distance}})
    RunPreviousCommand(self)
end

function sm.regui:setMeshPreview(widgetName, uuid)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widgetName) == "string", "widgetName is expected to be a string")
    assert(type(uuid) == "Uuid", "uuid is expected to be a Uuid")

    table.insert(self.commands, {"setMeshPreview", {widgetName, uuid}})
    RunPreviousCommand(self)
end

function sm.regui:setOnCloseCallback(callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setOnCloseCallback", {callback}})
    RunPreviousCommand(self)
end

function sm.regui:setRequireLineOfSight(state)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(state) == "boolean", "state is expected to be a boolean")

    table.insert(self.commands, {"setRequireLineOfSight", {state}})
    RunPreviousCommand(self)
end

function sm.regui:setSelectedDropDownItem(dropDownName, itemName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(dropDownName) == "string", "dropDownName is expected to be a string")
    assert(type(itemName) == "string", "itemName is expected to be a string")

    table.insert(self.commands, {"setSelectedDropDownItem", {dropDownName, itemName}})
    RunPreviousCommand(self)
end

function sm.regui:setSelectedListItem(listName, itemName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(listName) == "string", "listName is expected to be a string")
    assert(type(itemName) == "string", "itemName is expected to be a string")

    table.insert(self.commands, {"setSelectedListItem", {listName, itemName}})
    RunPreviousCommand(self)
end

function sm.regui:setSliderCallback(sliderName, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(sliderName) == "string", "sliderName is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setSliderCallback", {sliderName, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setSliderData(sliderName, range, position)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(sliderName) == "string", "sliderName is expected to be a string")
    assert(type(range) == "number", "range is expected to be a number")
    assert(type(position) == "number", "position is expected to be a number")

    table.insert(self.commands, {"setSliderData", {sliderName, range, position}})
    RunPreviousCommand(self)
end

function sm.regui:setSliderPosition(sliderName, position)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(sliderName) == "string", "sliderName is expected to be a string")
    assert(type(position) == "number", "position is expected to be a number")

    table.insert(self.commands, {"setSliderPosition", {sliderName, position}})
    RunPreviousCommand(self)
end

function sm.regui:setSliderRange(sliderName, range)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(sliderName) == "string", "sliderName is expected to be a string")
    assert(type(range) == "number", "range is expected to be a number")

    table.insert(self.commands, {"setSliderRange", {sliderName, range}})
    RunPreviousCommand(self)
end

function sm.regui:setSliderRangeLimit(sliderName, limit)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(sliderName) == "string", "sliderName is expected to be a string")
    assert(type(limit) == "number", "limit is expected to be a number")

    table.insert(self.commands, {"setSliderRangeLimit", {sliderName, limit}})
    RunPreviousCommand(self)
end

function sm.regui:setTextAcceptedCallback(editboxName, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(editboxName) == "string", "editboxName is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setTextAcceptedCallback", {editboxName, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setTextChangedCallback(editboxName, callback)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(editboxName) == "string", "editboxName is expected to be a string")
    assert(type(callback) == "string", "callback is expected to be a string")

    table.insert(self.commands, {"setTextChangedCallback", {editboxName, callback}})
    RunPreviousCommand(self)
end

function sm.regui:setVisible(widget, state)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widget) == "string", "widget is expected to be a string")
    assert(type(state) == "boolean", "state is expected to be a boolean")

    table.insert(self.commands, {"setVisible", {widget, state}})
    RunPreviousCommand(self)
end

function sm.regui:setWorldPosition(pos, world)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(pos) == "Vec3", "pos is expected to be a Vector3")
    assert(type(world) == "World", "world is expected to be a World")

    table.insert(self.commands, {"setWorldPosition", {pos, world}})
    RunPreviousCommand(self)
end

function sm.regui:stopEffect(widget, effect, immediate)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(widget) == "string", "widget is expected to be a string")
    assert(type(effect) == "string", "effect is expected to be a string")
    assert(type(immediate) == "boolean", "immediate is expected to be a boolean")

    table.insert(self.commands, {"stopEffect", {widget, effect, immediate}})
    RunPreviousCommand(self)
end

function sm.regui:stopGridEffect(gridName, index, effectName)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(gridName) == "string", "gridName is expected to be a string")
    assert(type(index) == "number", "index is expected to be a number")
    assert(type(effectName) == "string", "effectName is expected to be a string")

    table.insert(self.commands, {"stopGridEffect", {gridName, index, effectName}})
    RunPreviousCommand(self)
end

function sm.regui:trackQuest(name, title, mainQuest, questTasks)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(name) == "string", "name is expected to be a string")
    assert(type(title) == "string", "title is expected to be a string")
    assert(type(mainQuest) == "boolean", "mainQuest is expected to be a boolean")
    assert(type(questTasks) == "table", "questTasks is expected to be a table")

    -- QuestTasks structure
    --    {
    --      name = string,
    --      text = string,
    --      count = number,
    --      target = number,
    --      complete = bool
    --    }
    assert(type(questTasks.name) == "string", "questTasks.name is expected to be a string")
    assert(type(questTasks.text) == "string", "questTasks.text is expected to be a string")
    assert(type(questTasks.count) == "number", "questTasks.count is expected to be a number")
    assert(type(questTasks.target) == "number", "questTasks.target is expected to be a number")
    assert(type(questTasks.complete) == "boolean", "questTasks.complete is expected to be a boolean")

    table.insert(self.commands, {"trackQuest", {name, title, mainQuest, questTasks}})
    RunPreviousCommand(self)
end

function sm.regui:untrackQuest(name)
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(type(name) == "string", "name is expected to be a string")

    table.insert(self.commands, {"untrackQuest", {name}})
    RunPreviousCommand(self)
end

-- Load additional libaries

dofile("./TemplateManager.lua")
dofile("./FullscreenGui.lua")

print("Library fully loaded!")

---@class MainToolClass : ToolClass
MainToolClass = class()