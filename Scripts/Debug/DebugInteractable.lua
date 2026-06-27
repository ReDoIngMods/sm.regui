---@class DebugInteractableClass : ShapeClass
DebugInteractableClass = class()

-- SERVER --

function DebugInteractableClass:server_onCreate()
    print("DebugInteractableClass:server_onCreate")
end

function DebugInteractableClass:server_onRefresh()
    self:server_onCreate()
end

-- CLIENT --

function DebugInteractableClass:client_onCreate()
    print("DebugInteractableClass:client_onCreate")

    -- self.gui = sm.regui.createGuiFromLayout("$CONTENT_DATA/Gui/Layouts/Test.relayout")
    
    -- local textManager = self.gui:getTextManager()
    -- textManager:setTranslationFunction(function(key)
    --     if key == "test.text" then
    --         return "This is a translated text!"
    --     end

    --     return key
    -- end)

    -- self.fullscreenGui = sm.regui.createFullscreenInterface()
    -- self.gui = self.fullscreenGui:getGuiInterface()

    -- local rootWidget = self.fullscreenGui:getRootWidget()
    
    -- local textBox = rootWidget:createWidget("Text", "EditBox", "EditBox")
    -- textBox:setText("Hello, World!")
    -- textBox:setFontName("SM_Text")
    -- textBox:setTextAlign("Center")
    -- textBox:setSizeReal(1, 1)
end

function DebugInteractableClass:client_onInteract(character, state)
    if not state then return end
    
    local fullscreenGui = sm.regui.createFullscreenInterface()
    local gui = fullscreenGui:getGuiInterface()

    local rootWidget = fullscreenGui:getRootWidget()

    do
        local textBox = rootWidget:createWidget("Text", "TextBox", "TextBox")
        textBox:setText("#000000I EAT CRAYONS BTW")
        textBox:setFontName("HandbookTitle")
        textBox:setTextAlign("Center")
        textBox:setSizeReal(1, 1)

        ---@type ReGui.ControllerFadeAlpha
        local controller = rootWidget:createController("ControllerFadeAlpha")
        controller:setAlpha(0)
        controller:setCoefSeconds(4)
        controller:destroy()
    end

    do
        local whiteSkin = rootWidget:createWidget("Skin", "Widget", "WhiteSkin")
        whiteSkin:setSizeReal(1, 1)

        ---@type ReGui.ControllerFadeAlpha
        local controller = rootWidget:createController("ControllerFadeAlpha")
        controller:setAlpha(0)
        controller:setCoefSeconds(4)
        controller:destroy()
    end
    
    fullscreenGui:update()
    gui:open()
end

function DebugInteractableClass:client_onFixedUpdate()

end

function DebugInteractableClass:client_onRefresh()
    self:client_onCreate()
end