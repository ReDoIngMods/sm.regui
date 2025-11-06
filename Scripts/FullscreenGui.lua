local scaleFactor = 2

sm.regui.fullscreen = {}

function sm.regui.fullscreen.createFullscreenGuiFromInterface(guiInterface, hasFixedAspectRatio, alignment)
    AssertArgument(guiInterface, 1, {"table"}, {"ReGuiInterface"})
    AssertArgument(hasFixedAspectRatio, 2, {"boolean"})
    AssertArgument(alignment, 3, {"string"})

    local gui = sm.regui.newBlank()
    local backPanel = gui:createWidget("BackPanel", "Widget", "PanelEmpty")
    backPanel:setSizeRealUnits({scaleFactor, scaleFactor})
    
    -- Yes ugly af, idc
    backPanel:createWidget("FullscreenWidget", "Widget", "PanelEmpty")
        :createWidget("OutputWidget", "Widget", "PanelEmpty")
            :setLocationForTemplateContents(true)

    local outputGui = sm.regui.template.createTemplateFromInterface(gui):applyTemplateFromInterface(guiInterface)
    local fullscreenWidget = outputGui:findWidgetRecursive("FullscreenWidget")
    local outputWidget     = fullscreenWidget:findWidget("OutputWidget")

    return {
        __type = "ReGuiUserdata",
        
        getGui = function (self)
            SelfAssert(self)

            return outputGui
        end,

        getAlignment = function (self)
            SelfAssert(self)

            return alignment
        end,

        setAlignment = function (self, newAlignment)
            SelfAssert(self)
            AssertArgument(newAlignment, 1, {"string"})

            alignment = newAlignment
        end,

        hasFixedAspectRatio = function (self)
            SelfAssert(self)

            return hasFixedAspectRatio
        end,

        setFixedAspectRatio = function (self, state)
            SelfAssert(self)
            ValueAssert(state, 1, {"boolean"})

            hasFixedAspectRatio = state
        end,

        update = function (self)
            SelfAssert(self)
            
            -- Update FullscreenWidget --

            local screenWidth, screenHeight = sm.gui.getScreenSize()

            local fsWidgetWidth  = screenWidth
            local fsWidgetHeight = screenHeight

            local myGuiScreenWidth, myGuiScreenHeight = GetMyGuiScreenSize()

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

            if hasFixedAspectRatio and alignment ~= "Stretch" then
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

            local alignmentTable = {
                ["Left"] = function ()
                    outputX = 0
                end,

                ["Right"] = function ()
                    outputX = screenWidth - outputWidgetWidth
                end,

                ["Top"] = function ()
                    outputY = 0
                end,

                ["Bottom"] = function ()
                    outputY = screenHeight - outputWidgetHeight
                end,

                ["HStretch"] = function ()
                    outputX = 0
                    
                    local size = outputWidget:getSize()
                    outputWidget:setSize({screenWidth, size.y or size[2]})
                end,

                ["VStretch"] = function ()
                    outputY = 0

                    local size = outputWidget:getSize()
                    outputWidget:setSize({size.x or size[1], screenHeight})
                end,

                ["HCenter"] = function ()
                    outputX = (screenWidth - outputWidgetWidth) / 2
                end,

                ["VCenter"] = function ()
                    outputY = (screenHeight - outputWidgetHeight) / 2
                end
            }

            local defaultAlignment = "HCenter VCenter"
            local conversionTbl = {
                ["Stretch"] = "HStretch VStretch",

                ["[DEFAULT]"] = defaultAlignment,
                ["Default"] = defaultAlignment,

                ["Center"] = "HCenter VCenter"
            }

            for selection in defaultAlignment:gmatch("%S+") do
                alignmentTable[selection]()
            end

            local align = conversionTbl[alignment] or alignment

            for selection in align:gmatch("%S+") do
                local func = alignmentTable[selection]
                if func then
                    func()
                end
            end

            outputWidget:setPosition({outputX, outputY})
        end
    }
end

print("Loaded fullscreen gui!")