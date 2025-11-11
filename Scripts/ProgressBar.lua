---@class sm.regui.progressbar
sm.regui.progressbar = {}

---@param widget ReGui.Widget
---@param skin string?
function sm.regui.progressbar.createProgressBar(widget, skin)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})
    AssertArgument(skin, 2, {"string", "nil"})

    skin = skin or "ProgressBar"
    
    ---@class Regui.ProgressBar : sm.regui.progressbar
    local self = {}
    self.__type = "ReGuiUserdata"
    self.skin = skin
    self.widget = widget

    self.maxValue = 1
    self.value = 0
    
    for key, value in pairs(sm.regui.progressbar) do
        if type(value) == "function" and key ~= "createProgressBar" then
            self[key] = value
        end
    end
    
    self:recreateRoot()
    self:recreateBar()
    return self
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:recreateRoot()
    SelfAssert(self)

    self.widget:setType("ItemBox")
    self.widget:setSkin("ItemBoxEmpty")

    local progressGui = sm.regui.new("$CONTENT_3f08fc72-fef1-4bd4-9809-a04612d2e847/Gui/Relayouts/Progressbar.relayout")
    progressGui:setWidgetProperty("Progress", "skin", self.skin)
    progressGui:render()

    local widgetName = self.widget:getName()
    local widgetGui = self.widget:getGui()
    local widgetSize = self.widget:getSize()

    local progressGridInfo = {
        type = "processGrid",
        layout = progressGui:getRenderedPath(),

        -- I dont know if this is a fault for sm.regui or the game but you need to divide them by 2
        itemWidth = widgetSize.x / 2,
        itemHeight = widgetSize.y / 2,
        itemCount = 1
    }

    widgetGui:createGridFromJson(widgetName, progressGridInfo)
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:recreateBar()
    SelfAssert(self)
    
    local maxValue = math.max(1, self.maxValue)
    local value = sm.util.clamp(self.value, 0, self.maxValue)

    local gridItem = {
        itemId = "a4f45ac4-99e4-4d01-b787-f8897dc442db",
        craftTime = self.maxValue,

        -- If value is maxValue, we need to set it to math.huge because fuck you SM devs!
        remainingTicks = (math.ceil(value) >= maxValue) and math.huge or (maxValue - value),

        locked = false,
        repeating = false
    }

    local widgetName = self.widget:getName()
    local widgetGui = self.widget:getGui()
    
    widgetGui:setGridItem(widgetName, 0, gridItem)
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:setValue(value)
    SelfAssert(self)
    AssertArgument(value, 1, {"number"})

    if self.value == value then
        return
    end

    self.value = value
    self:recreateBar()
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:getValue()
    SelfAssert(self)

    return self.value
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:setMaxValue(value)
    SelfAssert(self)
    AssertArgument(value, 1, {"number"})

    if self.maxValue == value then
        return
    end

    self.maxValue = value
    self:recreateBar()
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:getMaxValue()
    SelfAssert(self)

    return self.maxValue
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:setSkin(skin)
    SelfAssert(self)
    AssertArgument(skin, 1, {"string"})

    if self.skin == skin then
        return
    end

    self.skin = skin
    self:recreateRoot()
    self:recreateBar()
end

---@param self Regui.ProgressBar
function sm.regui.progressbar:getSkin()
    SelfAssert(self)

    return self.skin
end

print("Loaded ProgressBar!")