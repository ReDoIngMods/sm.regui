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
end

function DebugInteractableClass:client_onInteract(character, state)
    if not state then return end
    
    local gui = sm.regui.createGuiFromLayout("$CONTENT_DATA/Gui/Layouts/Test.relayout")
    local widget = gui:findWidget("MainPanel", true)
    gui:open()
end

function DebugInteractableClass:client_onRefresh()
    self:client_onCreate()
end