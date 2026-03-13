local GUIInterface = {}
GUIInterface.__index = GUIInterface
GUIInterface.__tostring = CreateCustomTostringFunction("ReGui.GUIInterface")

function GUIInterface.new(path)
    local self = {}
    
    return setmetatable(self, GUIInterface)
end

sm.regui.guiinterface = GUIInterface