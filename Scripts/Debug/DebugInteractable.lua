---@class DebugInteractableClass : ShapeClass
DebugInteractableClass = class()

-- CLIENT --

function DebugInteractableClass:client_onCreate()
end

function DebugInteractableClass:client_onRefresh()
    self:client_onCreate()
end