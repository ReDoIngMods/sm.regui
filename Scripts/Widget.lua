---@class Internal.ReGui.Widget.Class
local Widget = sm.regui.widgets or {}
Widget.__type = "ReGui.Widget"
Widget.__index = function (tbl, index)
    local isDeleted = rawget(tbl, "isDeleted")
    if isDeleted then
        error(string.format("Attempt to access %q on deleted widget", tostring(index)), 2)
    end

    return Widget[index]
end
Widget.__tostring = CreateCustomTostringFunction(Widget.__type)

---@type table<ReGui.WidgetType, true>
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

---@type table<ReGui.FontName, true>
local VALID_FONT_NAMES = {
    ["SM_HeaderXLarge_Wide"] = true,
    ["SM_HeaderLarge_Wide"] = true,
    ["SM_HeaderLarge_Medium"] = true,
    ["SM_HeaderLarge_Narrow"] = true,
    ["SM_HeaderMedium"] = true,
    ["SM_SubHeader"] = true,
    ["SM_Header"] = true,
    ["SM_HeaderSmall"] = true,
    ["SM_HeaderTiny"] = true,
    ["SM_Tab"] = true,
    ["SM_TabSmall"] = true,
    ["SM_TextLabel"] = true,
    ["SM_Label"] = true,
    ["SM_LabelSmall"] = true,
    ["SM_LabelTiny"] = true,
    ["SM_LabelMini"] = true,
    ["SM_SliderLabel"] = true,
    ["SM_SearchText"] = true,
    ["SM_ToolTipText"] = true,
    ["SM_TextLarge"] = true,
    ["SM_Text"] = true,
    ["SM_TextDesc"] = true,
    ["SM_TextSmall"] = true,
    ["SM_TextTiny"] = true,
    ["SM_ItemTitle"] = true,
    ["SM_GameName"] = true,
    ["SM_ButtonLarge"] = true,
    ["SM_Button"] = true,
    ["SM_ButtonSmall"] = true,
    ["SM_ButtonTiny"] = true,
    ["SM_ButtonSmallBold"] = true,
    ["SM_NumberHuge"] = true,
    ["SM_NumberSmall"] = true,
    ["SM_NumberTiny"] = true,
    ["SM_NumberMini"] = true,
    ["SM_UserName"] = true,
    ["SM_ListItem"] = true,
    ["SM_HotbarBinding"] = true,
    ["SM_IntlText"] = true,
    ["SM_Digital"] = true,
    ["X_Interactable_Timer_TimeUnit"] = true,
    ["X_Interactable_Timer_TickCount"] = true,
    ["X_Interactable_LogicGate_Category"] = true,
    ["X_MenuGamemodeMenu_GameMode"] = true,
    ["X_Hud_Alert"] = true,
    ["X_Hud_Interaction"] = true,
    ["X_Hud_PlayerName"] = true,
    ["X_Hud_ItemStack"] = true,
    ["HandbookTitle"] = true,
    ["HandbookSubTitle"] = true,
    ["HandbookSubTitleItalic"] = true,
    ["HandbookPageCount"] = true,
    ["HandbookDescriptionLarge"] = true,
    ["HandbookDescriptionSmall"] = true,
    ["HandbookInstructionLarge"] = true,
    ["HandbookInstructionMedium"] = true,
    ["HandbookInstructionSmall"] = true,
    ["HandbookLogicDescription"] = true,
    ["HandbookFAQQuestion"] = true,
    ["HandbookFAQAnswer"] = true,
    ["DeJaVuSans"] = true,
}

---@type table<ReGui.TextAlign, true>
local VALID_TEXT_ALIGNMENT_TYPES = {
    ["[DEFAULT]"] = true,
    ["Default"] = true,
    ["Center"] = true,
    ["Left Top"] = true,
    ["Left Bottom"] = true,
    ["Left VCenter"] = true,
    ["Right Top"] = true,
    ["Right Bottom"] = true,
    ["Right VCenter"] = true,
    ["HCenter Top"] = true,
    ["HCenter Bottom"] = true,
    ["HCenter VCenter"] = true,
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

-- Returns (screenWidth, screenHeight), falling back to 1 to avoid division by zero.
---@param widget Internal.ReGui.Widget.Object
---@return number, number
local function GetScreenSize(widget)
    local screenWidth = widget.guiInterface and widget.guiInterface.data.metadata.screenWidth  or 1
    local screenHeight = widget.guiInterface and widget.guiInterface.data.metadata.screenHeight or 1

    return (screenWidth ~= 0 and screenWidth) or 1, (screenHeight ~= 0 and screenHeight) or 1
end

-- Returns (parentWidth, parentHeight) if a parent exists, else screen size.
---@param widget Internal.ReGui.Widget.Object
---@return number, number
local function GetReferenceSize(widget)
    if widget.parent then
        local parentWidth, parentHeight = widget.parent:getSize()
        return (parentWidth ~= 0 and parentWidth) or 1, (parentHeight ~= 0 and parentHeight) or 1
    end

    return GetScreenSize(widget)
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
    self.coordinate = CloneTable(node.coordinate) ---@type Internal.ReGui.Meta.RelayoutFile.Child.Coordinate
    self.coordinate.mode = self.coordinate.mode or "Pixels" ---@type ReGui.CoordinateMode

    self.parent = parent
    self.guiInterface = guiInterface

    self.translatable = true
    self.pendingTextContent = nil ---@type string?

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

    ---@type Internal.ReGui.Controller.Object[]
    self.controllers = {}
    for _, controllerNode in pairs(node.controllers) do
        table.insert(self.controllers, sm.regui.controller.parseController(controllerNode, self))
    end

    return self
end

-- ADDING & CLONING & DELETION --

---@param self Internal.ReGui.Widget.Object
---@param widgetName string
---@param widgetType string?
---@param widgetSkin string?
---@return Internal.ReGui.Widget.Object newWidget
function Widget:addWidget(widgetName, widgetType, widgetSkin)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(widgetName, 2, "string")
    ErrorHandler.AssertArgument(widgetType, 3, {"string", "nil"})
    ErrorHandler.AssertArgument(widgetSkin, 4, {"string", "nil"})

    if widgetType and not VALID_WIDGET_TYPES[widgetType] then
        error(string.format("Invalid widget type: %s", widgetType), 2)
    end

    local newWidget = Widget.parseWidget({
        nodeProperties = {
            name = widgetName,
            type = widgetType or "Widget",
            skin = widgetSkin or "PanelEmpty"
        },
        properties = {},
        userStrings = {},
        controllers = {},
        coordinate = {
            x = 0,
            y = 0,
            width = 100,
            height = 100,
            mode = "Pixels"
        },
        children = {}
    }, self, self.guiInterface)

    table.insert(self.children, newWidget)
    return newWidget
end

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

    clone.translatable = self.translatable
    clone.pendingTextContent = self.pendingTextContent
    return clone
end

---@param self Internal.ReGui.Widget.Object
function Widget:destroy()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    self:setParent(nil)
    self:setGUIInterface(nil)
    
    for _, child in pairs(self.children) do
        child:destroy()
    end
    
    self.children = {}
    self.isDeleted = true
end

-- WIDGET CREATION --

function Widget:createWidget(name, type, skin)
    ErrorHandler.AssertArgument(name, 1, "string")
    ErrorHandler.AssertArgument(type, 2, {"string", "nil"})
    ErrorHandler.AssertArgument(skin, 3, {"string", "nil"})

    if type and not VALID_WIDGET_TYPES[type] then
        error(string.format("Invalid widget type: %s", type), 2)
    end

    local newWidget = Widget.parseWidget({
        nodeProperties = {
            name = name,
            type = type or "Widget",
            skin = skin or "PanelEmpty"
        },
        properties = {},
        userStrings = {},
        controllers = {},
        coordinate = {
            x = 0,
            y = 0,
            width = 100,
            height = 100,
            mode = "Pixels"
        },
        children = {}
    }, self, self.guiInterface)
    table.insert(self.children, newWidget)

    return newWidget
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

    ErrorHandler.AssertCondition(key ~= "name" and key ~= "type" and key ~= "skin" and key ~= "position" and key ~= "position_real", 2, "Cannot set reserved node property: " .. key)
    
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

    ErrorHandler.AssertCondition(key ~= "Caption" and key ~= "Image" and key ~= "Color" and key ~= "FontName" and key ~= "TextAlign", 2, "Cannot set reserved property: " .. key)
    
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
    ErrorHandler.AssertArgument(parent, 2, {"ReGui.Widget", "nil"})
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
    ErrorHandler.AssertArgument(guiInterface, 2, {"ReGui.GUIInterface", "nil"})

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
    ErrorHandler.AssertArgument(recursive, 3, {"boolean", "nil"})

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

---@param self Internal.ReGui.Widget.Object
---@return Internal.ReGui.Widget.Object[]
function Widget:getChildren()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    return self.children
end

-- COORDINATE MODE --

---@param self Internal.ReGui.Widget.Object
---@return ReGui.CoordinateMode
function Widget:getCoordinateMode()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    return self.coordinate.mode
end

---@param self Internal.ReGui.Widget.Object
---@param mode ReGui.CoordinateMode
function Widget:setCoordinateMode(mode)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(mode, 2, "string")
    ErrorHandler.AssertCondition(mode == "Pixels" or mode == "Real", 2, "Invalid coordinate mode: " .. tostring(mode))

    if self.coordinate.mode == mode then 
        return
    end

    if mode == "Real" then
        local realX, realY = self:getPositionReal()
        local realWidth, realHeight = self:getSizeReal()

        self.coordinate.x = realX
        self.coordinate.y = realY
        self.coordinate.width  = realWidth
        self.coordinate.height = realHeight
    else
        local x, y = self:getPosition()
        local w, h = self:getSize()

        self.coordinate.x = x
        self.coordinate.y = y
        self.coordinate.width = w
        self.coordinate.height = h
    end

    self.coordinate.mode = mode
end

-- PIXEL POSITION/SIZE --

---@param self Internal.ReGui.Widget.Object
---@return integer x
---@return integer y
function Widget:getPosition()
    ErrorHandler.AssertSelf(self, Widget.__type)

    if self.coordinate.mode == "Real" then
        local referenceWidth, referenceHeight = GetReferenceSize(self)
        return math.floor(self.coordinate.x * referenceWidth + 0.5), math.floor(self.coordinate.y * referenceHeight + 0.5)
    end

    return self.coordinate.x, self.coordinate.y
end

---@param self Internal.ReGui.Widget.Object
---@return integer width
---@return integer height
function Widget:getSize()
    ErrorHandler.AssertSelf(self, Widget.__type)

    if self.coordinate.mode == "Real" then
        local referenceWidth, referenceHeight = GetReferenceSize(self)
        return math.floor(self.coordinate.width  * referenceWidth + 0.5), math.floor(self.coordinate.height * referenceHeight + 0.5)
    end

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
    self.coordinate.mode = "Pixels"
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
    self.coordinate.mode = "Pixels"
end

-- REAL UNITS POSITION/SIZE --

---@param self Internal.ReGui.Widget.Object
---@return number rx
---@return number ry
function Widget:getPositionReal()
    ErrorHandler.AssertSelf(self, Widget.__type)

    if self.coordinate.mode == "Pixels" then
        local referenceWidth, referenceHeight = GetReferenceSize(self)
        return self.coordinate.x / referenceWidth, self.coordinate.y / referenceHeight
    end

    return self.coordinate.x, self.coordinate.y
end

---@param self Internal.ReGui.Widget.Object
---@return number rw
---@return number rh
function Widget:getSizeReal()
    ErrorHandler.AssertSelf(self, Widget.__type)

    if self.coordinate.mode == "Pixels" then
        local referenceWidth, referenceHeight = GetReferenceSize(self)
        return self.coordinate.width / referenceWidth, self.coordinate.height / referenceHeight
    end

    return self.coordinate.width, self.coordinate.height
end

---Stores position as real units and marks this widget as real-mode.
---@param self Internal.ReGui.Widget.Object
---@param x number
---@param y number
function Widget:setPositionReal(x, y)
    ErrorHandler.AssertSelf(self, Widget.__type)
    ErrorHandler.AssertArgument(x, 2, "number")
    ErrorHandler.AssertArgument(y, 3, "number")

    self.coordinate.x = x
    self.coordinate.y = y
    self.coordinate.mode = "Real"
end

---Stores size as real units and marks this widget as real-mode.
---@param self Internal.ReGui.Widget.Object
---@param width number
---@param height number
function Widget:setSizeReal(width, height)
    ErrorHandler.AssertSelf(self, Widget.__type)
    ErrorHandler.AssertArgument(width, 2, "number")
    ErrorHandler.AssertArgument(height, 3, "number")

    self.coordinate.width = width
    self.coordinate.height = height
    self.coordinate.mode = "Real"
end

-- FONT --

---@param self Internal.ReGui.Widget.Object
---@param fontName ReGui.FontName?
function Widget:setFontName(fontName)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(fontName, 2, {"string", "nil"})

    if fontName then
        ErrorHandler.AssertCondition(VALID_FONT_NAMES[fontName] == true, 2, "Invalid font name: " .. fontName)
    end

    self.properties.FontName = fontName
end

---@param self Internal.ReGui.Widget.Object
---@return ReGui.FontName fontName
function Widget:getFontName()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    local fontName = self.properties.FontName
    if type(fontName) == "string" then
        return fontName
    end

    return "DeJaVuSans"
end

-- TEXT ALIGN --

---@param self Internal.ReGui.Widget.Object
---@param textAlign ReGui.TextAlign
function Widget:setTextAlign(textAlign)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(textAlign, 2, {"string", "nil"})

    if textAlign then
        ErrorHandler.AssertCondition(VALID_TEXT_ALIGNMENT_TYPES[textAlign] == true, 2, "Invalid text alignment: " .. textAlign)
    end

    self.properties.TextAlign = textAlign
end

---@param self Internal.ReGui.Widget.Object
---@return ReGui.TextAlign? textAlign
function Widget:getTextAlign()
    ErrorHandler.AssertSelf(self, Widget.__type, true)

    local textAlign = self.properties.TextAlign
    if type(textAlign) == "string" then
        return textAlign
    end

    return "[DEFAULT]"
end

-- TEXT --

---@param self Internal.ReGui.Widget.Object
---@return string? text
function Widget:getText()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    
    local text = self.properties.Caption
    if type(text) == "string" then
        return text
    end

    return nil
end

---@param self Internal.ReGui.Widget.Object
---@param text string?
function Widget:setText(text)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(text, 2, {"string", "nil"})

    self.properties.Caption = text

    if self.guiInterface and self.guiInterface:isActive() then
        if not self.translatable then
            self.guiInterface.activeInternalGui:setText(self.nodeProperties.name, text)
            return
        end

        local translatedText = self.guiInterface.textManager:translateText(text)
        self.guiInterface.activeInternalGui:setText(self.nodeProperties.name, translatedText)
    end
end

---@param self Internal.ReGui.Widget.Object
---@return boolean isTranslationEnabled
function Widget:isTranslationEnabled()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    return self.translatable
end

---@param self Internal.ReGui.Widget.Object
---@param enabled boolean
function Widget:setTranslationEnabled(enabled)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(enabled, 2, "boolean")

    self.translatable = enabled
end


-- CONTROLLERS --

---@param self Internal.ReGui.Widget.Object
---@param controllerType ReGui.ControllerType
---@return Internal.ReGui.Controller.Object controller
function Widget:createController(controllerType)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(controllerType, 2, "string")

    local controller = sm.regui.controllers.parseController({
        type = controllerType
   }, self)

    table.insert(self.controllers, controller)
    
    ---@diagnostic disable-next-line: return-type-mismatch
    return controller
end

---@param self Internal.ReGui.Widget.Object
---@return Internal.ReGui.Controller.Object[] controllers
function Widget:getControllers()
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    return self.controllers
end

-- RENDERING --

---@param self Internal.ReGui.Widget.Object
---@param indentationLevel integer?
---@param prettify boolean?
function Widget:renderWidget(indentationLevel, prettify)
    ErrorHandler.AssertSelf(self, Widget.__type, true)
    ErrorHandler.AssertArgument(indentationLevel, 2, {"number", "nil"})
    ErrorHandler.AssertArgument(prettify, 3, {"boolean", "nil"})

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

    -- Decide whether to emit position_real or position.
    -- Per-widget mode takes precedence; the guiInterface flag is a fallback
    -- for widgets that were never explicitly assigned a mode.
    local function insertCoordinates()
        local useReal = self.coordinate.mode == "Real" or (self.coordinate.mode == "Pixels" and self.guiInterface and self.guiInterface:isAutoConversionToRealUnitsEnabled())
        if useReal then
            local realX, realY = self:getPositionReal()
            local realWidth, realHeight = self:getSizeReal()

            table.insert(buffer, string.format("position_real=\"%.6f %.6f %.6f %.6f\"", realX, realY, realWidth, realHeight))
        else
            local x, y = self:getPosition()
            local width, height = self:getSize()
            table.insert(buffer, string.format( "position=\"%d %d %d %d\"", x, y, width, height))
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
            if self.translatable and key == "Caption" then
                local translatedText = self.guiInterface and self.guiInterface.textManager:translateText(value) or value
                table.insert(buffer, string.format("<Property key=%q value=%q/>", key, translatedText))
            else
                table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
            end
        end

        for _, controller in PredictablePairs(self.controllers) do
            table.insert(buffer, controller:renderController(indentationLevel + 1, prettify))
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
            if self.translatable and key == "Caption" then
                local translatedText = self.guiInterface and self.guiInterface.textManager:translateText(value) or value
                table.insert(buffer, string.format("<Property key=%q value=%q/>", key, translatedText))
            else
                table.insert(buffer, string.format("<Property key=%q value=%q/>", key, value))
            end
        end

        for _, controller in PredictablePairs(self.controllers) do
            local renderedController = controller:renderController(indentationLevel + 1, prettify)
            table.insert(buffer, renderedController)
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