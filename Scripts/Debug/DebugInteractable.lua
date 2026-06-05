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

    self.gui = sm.regui.createGuiFromLayout("$CONTENT_DATA/Gui/Layouts/Test.relayout")
    
    local textManager = self.gui:getTextManager()
    textManager:setTranslationFunction(function(key)
        if key == "test.text" then
            return "This is a translated text!"
        end

        return key
    end)
end

function DebugInteractableClass:client_onInteract(character, state)
    if not state then return end
    
    self.gui:open()
end

function DebugInteractableClass:client_onFixedUpdate()
    self.gui:setText("MainText", "Server Ticks: " .. sm.game.getServerTick())
end

function DebugInteractableClass:client_onRefresh()
    self:client_onCreate()
end