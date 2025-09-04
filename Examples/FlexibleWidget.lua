local gui = sm.regui.newBlank()
 
local backPanel = gui:createWidget("BackPanel", "Widget", "BackgroundPopup")
backPanel:setPosition({ 0, 0 })
backPanel:setSize({ 1280 + 200, 720 + 200 })

local flexWidget = sm.regui.flex.createFlexWidget(backPanel, "Center", "Vertical")
for i = 1, 5, 1 do
    local widget = gui:createWidget("Widget" .. i, "Button", "Button")
    widget:setSize({512, 128})
    widget:setProperty("FontName", "SM_Button")
    widget:setProperty("Caption", i)
    widget:setProperty("TextAlign", "Center")

    flexWidget:pushWidget(widget)
end

flexWidget:update()
gui:open()