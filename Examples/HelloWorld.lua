local gui = sm.regui.newBlank()
    
local backPanel = gui:createWidget("BackPanel")
backPanel:setInstanceProperty("type", "Widget")
backPanel:setInstanceProperty("skin", "BackgroundPopup")
backPanel:setPosition({ 0, 0 })
backPanel:setSize({ 1000, 320 })

local titleTextBox = backPanel:createWidget("TitleTextBox")
titleTextBox:setInstanceProperty("type", "TextBox")
titleTextBox:setInstanceProperty("skin", "TextBox")
titleTextBox:setPosition({ 0, 0 })
titleTextBox:setSize({ 1000, 125 })
titleTextBox:setProperty("Caption", "Welcome to sm.regui!")
titleTextBox:setProperty("FontName", "SM_HeaderLarge_Narrow")
titleTextBox:setProperty("TextAlign", "Center")
titleTextBox:setProperty("TextShadow", true)
local text = "If you are able to see this ReGuiInterface, that means sm.regui should be working perfectly fine! You can now start using sm.regui's awesome features.\n" ..
             "\n" ..
             "All documentations are in the definition file"
    
local descriptionEditbox = backPanel:createWidget("DescriptionEditbox")
descriptionEditbox:setInstanceProperty("type", "EditBox")
descriptionEditbox:setInstanceProperty("skin", "EditBoxEmpty")
descriptionEditbox:setPosition({ 30, 120 })
descriptionEditbox:setSize({ 940, 160 })
descriptionEditbox:setProperty("FontName", "SM_Text")
descriptionEditbox:setProperty("Caption", text)
descriptionEditbox:setProperty("ReadOnly", true)
descriptionEditbox:setProperty("MultiLine", true)
descriptionEditbox:setProperty("WordWrap", true)
gui:open()