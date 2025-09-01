---@class sm.regui.flex
sm.regui.flex = {}

function sm.regui.flex.createFlexWidget(widegt, alignment)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})
    AssertArgument(alignment, 2, {"string"})

    ---@class ReGui.FlexableWidget : sm.regui.flex
    local self = {
        __type = "ReGuiUserdata",
        alignment = alignment,
        widgets = {},
    }

    for key, value in pairs(sm.regui.flex) do
        if type(value) == "function" then
            self[key] = value
        end
    end
end

function sm.regui.flex:getAlignment()
    SelfAssert(self)

    return self.alignment
end

function sm.regui.flex:setAlignment(alignment)
    SelfAssert(self)
    AssertArgument(alignment, 1, {"string"})
    
    self.alignment = alignment
end

---@param self ReGui.FlexableWidget
function sm.regui.flex:pushWidget(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})
    ValueAssert(type(self.widgetAddrToIndex[tostring(widget)]) == "nil", 1, "Widget already pushed in a flexable widget!")

    self.widgets[tostring(widget)] = widget
end

---@param self ReGui.FlexableWidget
function sm.regui.flex:popWidget(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, {"table"}, {"ReGuiWidget"})
    ValueAssert(type(self.widgetAddrToIndex[tostring(widget)]) ~= "nil", 1, "Widget doesn't seem to exist in the flexable widget")

    self.widgets[tostring(widget)] = nil
end

---@param self ReGui.FlexableWidget
function sm.regui.flex:update()
    
end