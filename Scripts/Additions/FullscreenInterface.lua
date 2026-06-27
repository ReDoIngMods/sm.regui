---@class Internal.ReGui.FullscreenInterface.Class
local FullscreenInterface = {}
FullscreenInterface.__type = "ReGui.FullscreenInterface"
FullscreenInterface.__index = FullscreenInterface
FullscreenInterface.__tostring = CreateCustomTostringFunction(FullscreenInterface.__type)

---@type table<ReGui.WidgetAlignmentType, true>
local VALID_WIDGET_ALIGNMENT_TYPES = {
    ["[DEFAULT]"] = true,
    ["Default"] = true,
    ["Stretch"] = true,
    ["HStretch VStretch"] = true,
    ["Center"] = true,
    ["HCenter VCenter"] = true,
    ["Left Top"] = true,
    ["Left Bottom"] = true,
    ["Left VStretch"] = true,
    ["Left VCenter"] = true,
    ["Right Top"] = true,
    ["Right Bottom"] = true,
    ["Right VStretch"] = true,
    ["Right VCenter"] = true,
    ["HStretch Top"] = true,
    ["HStretch Bottom"] = true,
    ["HCenter Top"] = true,
    ["HCenter Bottom"] = true,
    ["HStretch VCenter"] = true,
    ["HCenter VStretch"] = true
}

function FullscreenInterface.newBlank()
    ---@class Internal.Regui.FullscreenInterface.Object : Internal.ReGui.FullscreenInterface.Class
    local self = setmetatable({}, FullscreenInterface)
    self.guiInterface = sm.regui.createGui()

    self.backPanel = self.guiInterface:createWidget("BackPanel", "Widget", "PanelEmpty")
    self.backPanel:setSizeReal(2, 2)
    
    self.innerWidget = self.backPanel:createWidget("REGUI_FULLSCREENINTERFACE_InnerWidget", "Widget", "PanelEmpty")
    self.outputWidget = self.innerWidget:createWidget("REGUI_FULLSCREENINTERFACE_OutputWidget", "Widget", "PanelEmpty")

    self.aspectRatio = {
        enabled = false,
        width = 16,
        height = 9
    }

    self.alignment = "Center"

    self.sizeConstraints = {
        maxWidth  = nil, ---@type integer?
        maxHeight = nil, ---@type integer?
        minWidth  = nil, ---@type integer?
        minHeight = nil, ---@type integer?
    }

    return self
end

---@param path string
function FullscreenInterface.new(path)
    ErrorHandler.AssertArgument(path, 1, "string")
    ErrorHandler.AssertValue(path, 1, sm.json.fileExists, "File not found")

    local fullScreenInterface = FullscreenInterface.newBlank()

    local inputInterface = sm.regui.createGuiFromLayout(path)
    local rootWidgets = inputInterface:getRootWidgets()
    for _, widget in ipairs(rootWidgets) do
        widget:setParent(fullScreenInterface.outputWidget)
    end

    return fullScreenInterface
end

---@param self Internal.Regui.FullscreenInterface.Object
function FullscreenInterface:getGuiInterface()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    return self.guiInterface
end

---@param self Internal.Regui.FullscreenInterface.Object
---@param alignment ReGui.WidgetAlignmentType
function FullscreenInterface:setAlignment(alignment)
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    ErrorHandler.AssertArgument(alignment, 1, "string")
    ErrorHandler.AssertCondition(VALID_WIDGET_ALIGNMENT_TYPES[alignment], 1, "Invalid alignment type")

    self.alignment = alignment
end

---@param self Internal.Regui.FullscreenInterface.Object
function FullscreenInterface:getAlignment()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    return self.alignment
end

---@param self Internal.Regui.FullscreenInterface.Object
---@param enabled boolean
function FullscreenInterface:setAspectRatioEnabled(enabled)
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)
    ErrorHandler.AssertArgument(enabled, 1, "boolean")

    self.aspectRatio.enabled = enabled
end

---@param self Internal.Regui.FullscreenInterface.Object
function FullscreenInterface:isAspectRatioEnabled()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    return self.aspectRatio.enabled
end

---@param self Internal.Regui.FullscreenInterface.Object
---@param width number
---@param height number
function FullscreenInterface:setAspectRatioValues(width, height)
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)
    ErrorHandler.AssertArgument(width, 1, "number")
    ErrorHandler.AssertArgument(height, 2, "number")

    self.aspectRatio.width = width
    self.aspectRatio.height = height
end

---@param self Internal.Regui.FullscreenInterface.Object
---@return number, number
function FullscreenInterface:getAspectRatioValues()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    return self.aspectRatio.width, self.aspectRatio.height
end

---@param self Internal.Regui.FullscreenInterface.Object
---@param minWidth integer?
---@param minHeight integer?
---@param maxWidth integer?
---@param maxHeight integer?
function FullscreenInterface:setSizeConstraints(minWidth, minHeight, maxWidth, maxHeight)
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)
    ErrorHandler.AssertArgument(minWidth, 1, {"integer", "nil"})
    ErrorHandler.AssertArgument(minHeight, 2, {"integer", "nil"})
    ErrorHandler.AssertArgument(maxWidth, 3, {"integer", "nil"})
    ErrorHandler.AssertArgument(maxHeight, 4, {"integer", "nil"})

    self.sizeConstraints.minWidth = minWidth
    self.sizeConstraints.minHeight = minHeight
    self.sizeConstraints.maxWidth = maxWidth
    self.sizeConstraints.maxHeight = maxHeight
end

---@param self Internal.Regui.FullscreenInterface.Object
---@return integer?, integer?, integer?, integer?
function FullscreenInterface:getSizeConstraints()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    return self.sizeConstraints.minWidth, self.sizeConstraints.minHeight, self.sizeConstraints.maxWidth, self.sizeConstraints.maxHeight
end

---@param self Internal.Regui.FullscreenInterface.Object
---@return Internal.ReGui.Widget.Object
function FullscreenInterface:getRootWidget()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    ---@diagnostic disable-next-line: return-type-mismatch
    return self.outputWidget
end

---@param self Internal.Regui.FullscreenInterface.Object
function FullscreenInterface:update()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    local screenWidth, screenHeight = sm.gui.getScreenSize()
    self.backPanel:setSize(screenWidth * 2, screenHeight * 2)

    local myGuiScreenWidth, myGuiScreenHeight = GetMyGuiScreenSize()
    local yOffset = 0.0611111111111 * myGuiScreenHeight - 2

    self.innerWidget:setPosition(screenWidth / 2, (screenHeight / 2) + yOffset)
    self.innerWidget:setSize(screenWidth, screenHeight)

    local outputWidth, outputHeight = screenWidth, screenHeight

    local ALIGNMENT_CONVERSION = {
        ["[DEFAULT]"] = "Left Top",
        ["Default"] = "Left Top",
        ["Stretch"] = "HStretch VStretch",
        ["Center"] = "HCenter VCenter",
    }

    local alignment = self.alignment
    while ALIGNMENT_CONVERSION[alignment] do
        alignment = ALIGNMENT_CONVERSION[alignment]
    end

    local outputAnchorX, outputAnchorY = 0, 0
    local ALIGNMENT_FUNCTIONS = {
        ["HStretch"] = function ()
            outputWidth = screenWidth
        end,
        ["VStretch"] = function ()
            outputHeight = screenHeight
        end,

        ["Left"] = function ()
            outputAnchorX = 0
        end,
        ["HCenter"] = function ()
            outputAnchorX = 0.5
        end,
        ["Right"] = function ()
            outputAnchorX = 1
        end,

        ["Top"] = function ()
            outputAnchorY = 0
        end,
        ["VCenter"] = function ()
            outputAnchorY = 0.5
        end,
        ["Bottom"] = function ()
            outputAnchorY = 1
        end
    }

    for alignmentPart in string.gmatch(alignment, "%S+") do
        local func = ALIGNMENT_FUNCTIONS[alignmentPart]
        if func then
            func()
        end
    end

    if self.sizeConstraints.minWidth then outputWidth = math.max(outputWidth, self.sizeConstraints.minWidth) end
    if self.sizeConstraints.minHeight then outputHeight = math.max(outputHeight, self.sizeConstraints.minHeight) end
    if self.sizeConstraints.maxWidth then outputWidth = math.min(outputWidth, self.sizeConstraints.maxWidth) end
    if self.sizeConstraints.maxHeight then outputHeight = math.min(outputHeight, self.sizeConstraints.maxHeight) end

    self.outputWidget:setSize(outputWidth, outputHeight)
    self.outputWidget:setPositionReal(outputAnchorX, outputAnchorY)
    self.outputWidget:setAnchorPoint(outputAnchorX, outputAnchorY)
end

function FullscreenInterface:open()
    ErrorHandler.AssertSelf(self, FullscreenInterface.__type)

    self:update()
    self.guiInterface:open()
end

sm.regui.fullscreenInterface = FullscreenInterface