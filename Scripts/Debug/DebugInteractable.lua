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

    local gui = sm.regui.createGui()
    local backPanel = gui:createWidget("MainPanel", "Widget", "WhiteSkin")
    backPanel:setSize(1920, 1080)
    backPanel:setProperty("Colour", sm.color.new(16 / 255, 16 / 255, 32 / 255))
    

































    local subWidget = backPanel:createWidget("SubWidget", "Widget", "WhiteSkin")
    subWidget:setSize(250, 250)
    subWidget:setPositionReal(0.5, 0.5)
    subWidget:setAnchorPoint(0.5, 0.5)
    subWidget:setProperty("Colour", sm.color.new(1, 0, 0))








































    local lineA = backPanel:createWidget("LineA", "Widget", "WhiteSkin")
    lineA:setSize(1920, 2)
    lineA:setPositionReal(0, 0.5)
    lineA:setAnchorPoint(0, 0.5)
    lineA:setProperty("Colour", sm.color.new(.75, .75, .75))

    local lineB = backPanel:createWidget("LineB", "Widget", "WhiteSkin")
    lineB:setSize(2, 1080)
    lineB:setPositionReal(0.5, 0)
    lineB:setAnchorPoint(0.5, 0)
    lineB:setProperty("Colour", sm.color.new(.75, .75, .75))

    gui:open()
end

function DebugInteractableClass:client_onFixedUpdate()

end

function DebugInteractableClass:client_onRefresh()
    self:client_onCreate()
end