local scaleFactor = 2

sm.regui.fullscreen = {}

function sm.regui.fullscreen.createFullscreenGuiFromInterface(guiInterface, hasFixedAspectRatio, alignment)
    assert(type(guiInterface) == "table", "guiInterface is expected to be a ReGuiInterface")
    assert(type(hasFixedAspectRatio) == "boolean", "hasFixedAspectRatio is expected to be a boolean")
    assert(type(alignment) == "string", "alignment is expected to be a string")

    local alignment = alignment:lower()

    ---@class ReGui.FullscreenGUI : ReGui.GUI
    local gui = sm.regui.newBlank()
    local backPanel = gui:createWidget("BackPanel", "Widget", "PanelEmpty")
    backPanel:setSizePercentage({scaleFactor, scaleFactor})
    
    local fullscreenWidget = backPanel:createWidget("FullscreenWidget", "Widget", "PanelEmpty")
    local outputWidget = fullscreenWidget:createWidget("OutputWidget", "Widget", "PanelEmpty")
    outputWidget:setTemplateContents(true)

    local outputGui = sm.regui.template.createTemplateFromInterface(gui):applyTemplate(guiInterface)

    return {
        getGui = function (self)
            assert(type(self) == "table", "No self provided!")

            return outputGui
        end,

        getAlignment = function (self)
            assert(type(self) == "table", "No self provided!")

            return alignment:lower()
        end,

        setAlignment = function (self, newAlignment)
            assert(type(self) == "table", "No self provided!")
            assert(type(newAlignment) == "string", "newAlignment is expected to be a string")

            alignment = newAlignment:lower()
        end,

        hasFixedAspectRatio = function (self)
            assert(type(self) == "table", "No self provided!")

            return hasFixedAspectRatio
        end,

        setFixedAspectRatio = function (self, state)
            assert(type(self) == "table", "No self provided!")
            assert(type(state) == "boolean", "state is expected to be a string")

            hasFixedAspectRatio = state
        end,

        update = function (self)
            assert(type(self) == "table", "No self provided!")
            
            -- Update FullscreenWidget --

            local screenWidth, screenHeight = sm.gui.getScreenSize()

            local fsWidgetWidth  = screenWidth
            local fsWidgetHeight = screenHeight

            local myGuiScreenWidth, myGuiScreenHeight = getMyGuiScreenSize()

            -- 1440p = 86
            -- 1080p = 64
            -- 720p  = 42
            local yOffset = math.floor(0.0611 * myGuiScreenHeight + -1.984)

            if myGuiScreenHeight == 720 then
                yOffset = yOffset + 1
            elseif myGuiScreenHeight == 1080 then
                fsWidgetWidth  = fsWidgetWidth + 2
                fsWidgetHeight = fsWidgetHeight + 2
            end

            -- TODO: Add more resolutions to account for certain screens
        
            local backPanelWidth  = myGuiScreenWidth * scaleFactor
            local backPanelHeight = myGuiScreenHeight * scaleFactor

            local centerX = (backPanelWidth  / 2) - (fsWidgetWidth  / 2)
            local centerY = (backPanelHeight / 2) - (fsWidgetHeight / 2)
        
            fullscreenWidget:setPosition({centerX, centerY + yOffset})
            fullscreenWidget:setSize({fsWidgetWidth, fsWidgetHeight})

            -- Output Widget --

            local outputWidgetWidth  = screenWidth
            local outputWidgetHeight = screenHeight

            if hasFixedAspectRatio and alignment ~= "stretch" then
                local ratio = 16 / 9
                local screenRatio = screenWidth / screenHeight

                if screenRatio > ratio then
                    outputWidgetHeight = screenHeight
                    outputWidgetWidth = screenHeight * ratio
                else
                    outputWidgetWidth = screenWidth
                    outputWidgetHeight = screenWidth / ratio
                end
            end

            outputWidget:setSize({outputWidgetWidth, outputWidgetHeight})
            
            local outputX = 0
            local outputY = 0

            if alignment == "stretch" then
                outputWidget:setSize({screenWidth, screenHeight})
            elseif alignment == "topleft" then
                -- Do nothing
            elseif alignment == "topright" then
                outputX = screenWidth - outputWidgetWidth
            elseif alignment == "top" then
                outputX = (screenWidth - outputWidgetWidth) / 2
            elseif alignment == "bottomleft" then
                outputY = screenHeight - outputWidgetHeight
            elseif alignment == "bottomright" then
                outputX = screenWidth - outputWidgetWidth
                outputY = screenHeight - outputWidgetHeight
            elseif alignment == "bottom" then
                outputX = (screenWidth - outputWidgetWidth) / 2
                outputY = screenHeight - outputWidgetHeight
            elseif alignment == "right" then
                outputX = screenWidth - outputWidgetWidth
                outputY = (screenHeight - outputWidgetHeight) / 2
            elseif alignment == "left" then
                outputX = 0
                outputY = (screenHeight - outputWidgetHeight) / 2
            else -- Center
                outputX = (screenWidth - outputWidgetWidth) / 2
                outputY = (screenHeight - outputWidgetHeight) / 2
            end

            outputWidget:setPosition({outputX, outputY})
        end
    }
end

---@param self ReGui.FullscreenGUI
function sm.regui.fullscreen:rescaleFullscreenGui()
    assert(type(self) == "table", "Invalid ReGuiInstance!")
    assert(self.isFullscreenGui == true, "Not a fullscreen gui!")
    
    local screenWidth, screenHeight = sm.gui.getScreenSize()

    local widgetWidth  = screenWidth
    local widgetHeight = screenHeight    

    local myGuiScreenWidth, myGuiScreenHeight = getMyGuiScreenSize()

    -- 1440p = 86
    -- 1080p = 64
    -- 720p  = 42
    local yOffset = math.floor(0.0611 * myGuiScreenHeight + -1.984)

    if myGuiScreenHeight == 720 then
        yOffset = yOffset + 1
    elseif myGuiScreenHeight == 1080 then
        widgetWidth  = widgetWidth + 2
        widgetHeight = widgetHeight + 2
    end

    local backPanelWidth  = myGuiScreenWidth * scaleFactor
    local backPanelHeight = myGuiScreenHeight * scaleFactor
    
    local centerX = (backPanelWidth  / 2) - (widgetWidth  / 2)
    local centerY = (backPanelHeight / 2) - (widgetHeight / 2)

    self.fullscreenWidget:setPosition({centerX, centerY + yOffset})
    self.fullscreenWidget:setSize({widgetWidth, widgetHeight})
end

print("Loaded fullscreen gui!")