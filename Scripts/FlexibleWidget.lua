---@class sm.regui.flex
sm.regui.flex = {}

function sm.regui.flex.createFlexWidget(widget, justifyContent, flexDirection)
    AssertArgument(widget, 1, { "table" }, { "ReGuiWidget" })
    AssertArgument(justifyContent, 2, { "string" })
    AssertArgument(flexDirection, 3, { "string" })

    ---@class ReGui.FlexibleWidget : sm.regui.flex
    local self = {
        __type = "ReGuiUserdata",
        justifyContent = justifyContent,
        flexDirection = flexDirection,
        widgets = {}, ---@type ReGui.Widget[]
        mainWidget = widget:createWidget(widget:getName() .. "_REGUI_FLEXWIDGET", "Widget", "Widget"),
        widgetAddrToIndex = {},

        properties = {
            gap = {
                inPixels = true,
                value = 25
            }
        }
    }

    self.mainWidget:setPositionRealUnits({ 0, 0 })
    self.mainWidget:setSizeRealUnits({ 1, 1 })

    for key, value in pairs(sm.regui.flex) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    return self
end

function sm.regui.flex:getJustifyContent()
    SelfAssert(self)
    return self.justifyContent
end

function sm.regui.flex:setJustifyContent(justifyContent)
    SelfAssert(self)
    AssertArgument(justifyContent, 1, { "string" })
    self.justifyContent = justifyContent
end

function sm.regui.flex:getFlexDirection()
    SelfAssert(self)
    return self.flexDirection
end

function sm.regui.flex:setFlexDirection(flexDirection)
    SelfAssert(self)
    AssertArgument(flexDirection, 1, { "string" })
    self.flexDirection = flexDirection
end

---@param self ReGui.FlexibleWidget
---@param widget ReGui.Widget
function sm.regui.flex:pushWidget(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, { "table" }, { "ReGuiWidget" })
    ValueAssert(self.widgetAddrToIndex[tostring(widget)] == nil, 1, "Widget already pushed!")

    widget:setParent(self.mainWidget)
    table.insert(self.widgets, widget)
    self.widgetAddrToIndex[tostring(widget)] = #self.widgets
end

---@param self ReGui.FlexibleWidget
---@param widget ReGui.Widget
function sm.regui.flex:popWidget(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, { "table" }, { "ReGuiWidget" })

    local idx = self.widgetAddrToIndex[tostring(widget)]
    ValueAssert(idx ~= nil, 1, "Widget not found!")

    table.remove(self.widgets, idx)

    self.widgetAddrToIndex = {}
    for i, w in ipairs(self.widgets) do
        self.widgetAddrToIndex[tostring(w)] = i
    end
end

---@param self ReGui.FlexibleWidget
function sm.regui.flex:update()
    SelfAssert(self)

    local mainSize = self.mainWidget:getSize()
    local gap = self.properties.gap.value or 0
    local justifyContent = self.justifyContent or "Start"
    local flexDirection = self.flexDirection or "Horizontal"

    local isVertical = (flexDirection == "Vertical")

    local totalFixedSize = 0
    for _, widget in pairs(self.widgets) do
        local size = widget:getSize()
        totalFixedSize = totalFixedSize + (isVertical and size.y or size.x)
    end

    local widgetCount = #self.widgets
    local totalGapSize = gap * (widgetCount > 1 and widgetCount - 1 or 0)
    local mainAxisSize = isVertical and mainSize.y or mainSize.x
    local crossAxisSize = isVertical and mainSize.x or mainSize.y

    local startMain = 0
    local spacing = gap

    local function setWidgetMainSize(widget, sizeOnMain)
        local size = widget:getSize()
        if isVertical then
            size.y = sizeOnMain
        else
            size.x = sizeOnMain
        end
        widget:setSize(size)
    end

    local function getWidgetMainSize(widget)
        local size = widget:getSize()
        return isVertical and size.y or size.x
    end

    if justifyContent == "Start" or justifyContent == "Left" or justifyContent == "FlexStart" then
        startMain = 0
    elseif justifyContent == "End" or justifyContent == "Right" or justifyContent == "FlexEnd" then
        startMain = mainAxisSize - totalFixedSize - totalGapSize
    elseif justifyContent == "Center" then
        startMain = (mainAxisSize - totalFixedSize - totalGapSize) / 2
    elseif justifyContent == "SpaceBetween" then
        spacing = (widgetCount > 1) and ((mainAxisSize - totalFixedSize) / (widgetCount - 1)) or 0
        startMain = 0
    elseif justifyContent == "SpaceAround" then
        spacing = (widgetCount > 0) and ((mainAxisSize - totalFixedSize) / widgetCount) or 0
        startMain = spacing / 2
    elseif justifyContent == "SpaceEvenly" then
        spacing = (widgetCount > 0) and ((mainAxisSize - totalFixedSize) / (widgetCount + 1)) or 0
        startMain = spacing
    elseif justifyContent == "Stretch" then
        local freeSpace = mainAxisSize - totalFixedSize - totalGapSize
        if freeSpace < 0 then freeSpace = 0 end

        spacing = gap
        startMain = 0

        local stretchPerWidget = 0
        if widgetCount > 0 then
            stretchPerWidget = freeSpace / widgetCount
        end

        for _, widget in ipairs(self.widgets) do
            local originalSize = getWidgetMainSize(widget)
            setWidgetMainSize(widget, originalSize + stretchPerWidget)
        end
    end

    for _, widget in ipairs(self.widgets) do
        local size = widget:getSize()
        local pos = { x = 0, y = 0 }

        if isVertical then
            pos.y = startMain
            pos.x = (crossAxisSize - size.x) / 2

            widget:setPosition(pos)
            startMain = startMain + size.y + spacing
        else
            pos.x = startMain
            pos.y = (crossAxisSize - size.y) / 2

            widget:setPosition(pos)
            startMain = startMain + size.x + spacing
        end
    end
end

print("Loaded FlexibleWidget.lua")
