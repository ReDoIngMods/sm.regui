local gui = sm.regui.newBlank()
    
local backPanel = gui:createWidget("BackPanel", "Widget", "BackgroundPopup")
backPanel:setPosition({ 0, 0 })
backPanel:setSize({ 1000, 125 })

local titleTextBox = backPanel:createWidget("TitleTextBox", "TextBox", "TextBox")
titleTextBox:setPosition({ 0, 0 })
titleTextBox:setSize({ 1000, 125 })
titleTextBox:setProperty("Caption", {"Hello %s", "world!"})
titleTextBox:setProperty("FontName", "SM_HeaderLarge_Narrow")
titleTextBox:setProperty("TextAlign", "Center")
titleTextBox:setProperty("TextShadow", true)

local function translator(...)
    return string.format(...)
end

gui:setTextTranslation(translator) -- Can be placed anywhere
gui:open()