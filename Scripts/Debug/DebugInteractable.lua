---@class DebugInteractableClass : ShapeClass
DebugInteractableClassX = class()
DebugInteractableClass = DebugInteractableClassX
-- DebugInteractableClass = setmetatable({}, {
--     __index = DebugInteractableClassX,
--     __call = function (...)
--         return setmetatable({}, {
--             __index = function (t, k)
--                 if DebugInteractableClassX[k] then
--                     return DebugInteractableClassX[k]
--                 end

--                 local blacklist = {
--                     "client_onUpdate",
--                     "server_onFixedUpdate",
--                     "client_onFixedUpdate",
--                     "server_onReceiveUpdate",
--                     "client_onRefresh",
--                     "server_onRefresh",
--                     "client_onDestroy",
--                     "server_onDestroy",
--                 }

--                 for _, v in ipairs(blacklist) do
--                     if k == v then
--                         return nil
--                     end
--                 end

--                 return function (...)
--                     debugPrint("[DebugInteractableClass] " .. k .. " | " .. select("#", ...) - 1 .. " |   ", unpack({...}, 2, select("#", ...)))
--                 end
--             end
--         })
--     end
-- })

-- CLIENT --

function DebugInteractableClassX:client_onCreate()
    if self.gui then
        self.gui:close()
        self.gui = nil
    end
    self.gui = sm.jsonGui.createGui({isHud = true, isInteractive = true, isOverlapped = true, needsCursor = true, layer = "Overlapped"})
end

function DebugInteractableClassX:client_onInteract(character, state)
    if not state then return end
end

function DebugInteractableClassX:client_onFixedUpdate()
    self.lastTime = self.lastTime or 0
    self.lastTime = self.lastTime + 1

    if self.lastTime >= 10 then
        self.lastTime = 0
        
        --     self.gui:render(sm.json.open("$CONTENT_DATA/test.gui"))

        local success, data = pcall(sm.json.open, "$CONTENT_DATA/test.gui", true)
        if success then
            self.gui:render(data)
        end
    end
end

function DebugInteractableClassX:client_onRefresh()
    self:client_onCreate()
end