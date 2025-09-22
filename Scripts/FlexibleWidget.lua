---@class sm.regui.flex
sm.regui.flex = {}

-- Util: Clone methods into the instance
local function applyFlexMethods(self)
    for key, fn in pairs(sm.regui.flex) do
        if type(fn) == "function" then
            self[key] = fn
        end
    end
end

-- Factory function
function sm.regui.flex.createFlexWidget(widget, justifyContent, flexDirection)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})
    AssertArgument(justifyContent, 2, {"string"})
    AssertArgument(flexDirection, 3, {"string"})

    ---@class ReGui.FlexibleWidget : sm.regui.flex
    local self = {
        __type = "ReGuiUserdata",
        justifyContent = justifyContent,
        flexDirection = flexDirection,
        widgets = {}, ---@type ReGui.Widget[]
        widgetAddrToIndex = {},

        mainWidget = widget:createWidget(widget:getName() .. "_REGUI_FLEXWIDGET", "Widget", "Widget"),
        properties = {
            gap = {
                inPixels = true,
                value = 0
           }
       }
   }

    self.mainWidget:setPositionRealUnits({0, 0})
    self.mainWidget:setSizeRealUnits({1, 1})

    applyFlexMethods(self)

    return self
end

-- Getters & Setters
function sm.regui.flex:getJustifyContent()
    SelfAssert(self)
    return self.justifyContent
end

function sm.regui.flex:setJustifyContent(justifyContent)
    SelfAssert(self)
    AssertArgument(justifyContent, 1, {"string"})
    self.justifyContent = justifyContent
end

function sm.regui.flex:getFlexDirection()
    SelfAssert(self)
    return self.flexDirection
end

function sm.regui.flex:setFlexDirection(flexDirection)
    SelfAssert(self)
    AssertArgument(flexDirection, 1, {"string"})
    self.flexDirection = flexDirection
end

---@param widget ReGui.Widget
function sm.regui.flex:pushWidget(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})

    local key = tostring(widget)
    ValueAssert(self.widgetAddrToIndex[key] == nil, 1, "Widget already pushed!")

    widget:setParent(self.mainWidget)
    table.insert(self.widgets, widget)
    self.widgetAddrToIndex[key] = #self.widgets
end

---@param widget ReGui.Widget
function sm.regui.flex:popWidget(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})

    local key = tostring(widget)
    local idx = self.widgetAddrToIndex[key]
    ValueAssert(idx, 1, "Widget not found!")

    table.remove(self.widgets, idx)

    self.widgetAddrToIndex = {}
    for i, w in ipairs(self.widgets) do
        self.widgetAddrToIndex[tostring(w)] = i
    end
end

function sm.regui.flex:update()
    SelfAssert(self)

    local isVertical = (self.flexDirection == "Vertical")
    local justifyContent = self.justifyContent or "Start"
    local gap = self.properties.gap.value or 0

    local mainSize = self.mainWidget:getSize()
    local mainAxisSize = isVertical and mainSize.y or mainSize.x
    local crossAxisSize = isVertical and mainSize.x or mainSize.y

    local totalFixedSize = 0
    for _, widget in ipairs(self.widgets) do
        local size = widget:getSize()
        totalFixedSize = totalFixedSize + (isVertical and size.y or size.x)
    end

    local widgetCount = #self.widgets
    local totalGapSize = gap * math.max(widgetCount - 1, 0)
    local startMain = 0
    local spacing = gap

    local function getMainSize(widget)
        local size = widget:getSize()
        return isVertical and size.y or size.x
    end

    local function setMainSize(widget, newMainSize)
        local size = widget:getSize()
        if isVertical then
            size.y = newMainSize
        else
            size.x = newMainSize
        end
        widget:setSize(size)
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
        local freeSpace = math.max(mainAxisSize - totalFixedSize - totalGapSize, 0)
        local stretchPerWidget = (widgetCount > 0) and (freeSpace / widgetCount) or 0

        for _, widget in ipairs(self.widgets) do
            local originalSize = getMainSize(widget)
            setMainSize(widget, originalSize + stretchPerWidget)
        end
        startMain = 0
        spacing = gap
    end

    for _, widget in ipairs(self.widgets) do
        local size = widget:getSize()
        local pos = {x = 0, y = 0}

        if isVertical then
            pos.y = startMain
            pos.x = (crossAxisSize - size.x) / 2
            startMain = startMain + size.y + spacing
        else
            pos.x = startMain
            pos.y = (crossAxisSize - size.y) / 2
            startMain = startMain + size.x + spacing
        end

        widget:setPosition(pos)
    end
end

function sm.regui.flex:getGapPixels()
    SelfAssert(self)

    local gap = self.properties.gap
    if gap.inPixels then
        return gap.value
    end

    local sizePixels = self.mainWidget:getSize()
    local sizeRealUnits = self.mainWidget:getSizeRealUnits()
    local scaleX = sizePixels.x / sizeRealUnits.x
    local scaleY = sizePixels.y / sizeRealUnits.y
    local scale = (scaleX + scaleY) / 2

    return gap.value * scale
end

function sm.regui.flex:getGapRealUnits()
    SelfAssert(self)

    local gap = self.properties.gap
    if not gap.inPixels then
        return gap.value
    end

    local sizePixels = self.mainWidget:getSize()
    local sizeRealUnits = self.mainWidget:getSizeRealUnits()
    local scaleX = sizeRealUnits.x / sizePixels.x
    local scaleY = sizeRealUnits.y / sizePixels.y
    local scale = (scaleX + scaleY) / 2

    return gap.value * scale
end

function sm.regui.flex:setGapPixels(value)
    SelfAssert(self)
    AssertArgument(value, 1, {"integer"})

    self.properties.gap.value = value
    self.properties.gap.inPixels = true
end

function sm.regui.flex:setGapRealUnits(value)
    SelfAssert(self)
    AssertArgument(value, 1, {"number"})

    self.properties.gap.value = value
    self.properties.gap.inPixels = false
end

print("Loaded FlexibleWidget.lua")
