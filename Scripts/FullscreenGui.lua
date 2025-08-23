function sm.regui.newFullscreenGui()
    ---@class ReGui.FullscreenGUI : ReGui.GUI
    local gui = sm.regui.newBlank()
    gui.isFullscreenGui = true
    gui.fullscreenWidget = gui:createWidget("BackPanel")
    gui.fullscreenWidget:setInstanceProperty("skin", "BackgroundPopup")
    gui:rescaleFullscreenGui()
    return gui
end

---@param self ReGui.FullscreenGUI
function sm.regui:rescaleFullscreenGui()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(self.isFullscreenGui == true, "Not a fullscreen gui!")

    local screenWidth, screenHeight = sm.gui.getScreenSize()
    
    local myGuiScreenWidth, myGuiScreenHeight = getMyGuiScreenSize()
    local heightDiff = (screenHeight - myGuiScreenHeight)

    if heightDiff == 0 then
        self.fullscreenWidget:setInstanceProperty("name", "FullscreenWidget")
        self.fullscreenWidget:setPosition({0, 0})
    else
        self.fullscreenWidget:setInstanceProperty("name", "BackPanel")
        self.fullscreenWidget:setPosition({0, 10})
    end

    print(myGuiScreenWidth, screenWidth)
    
    self.fullscreenWidget:setSize({screenWidth, myGuiScreenHeight - 10})
end

print("Loaded fullscreen gui!")