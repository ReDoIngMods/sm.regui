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

    local myGuiScreenWidth, myGuiScreenHeight = sm.regui.getMyGuiScreenSize()
    local fullscreenGui = sm.regui.createFullscreenInterfaceFromLayout("$CONTENT_DATA/DevTools/LayoutToRelayout/output.relayout")
    fullscreenGui:setAspectRatioEnabled(true)
    fullscreenGui:setAspectRatioValues(16, 9)
    fullscreenGui:setAlignment("Right Bottom")
    fullscreenGui:setSizeConstraints(nil, nil, myGuiScreenWidth, myGuiScreenHeight)
    
    fullscreenGui:open()
end

function DebugInteractableClass:client_onFixedUpdate()

end

function DebugInteractableClass:client_onRefresh()
    self:client_onCreate()
end