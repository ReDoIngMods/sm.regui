print([[    __          __   ___  __           ]])
print([[   /__`  |\/|  |__) |__  / _` |  | |   ]])
print([[   .__/  |  | .|  \ |___ \__> \__/ |   ]])
print([[   ReDoing Graphical User Interfaces   ]])
print([[                                       ]])

dofile("PrintHook.lua")

dofile("Helper/ContentPath.lua")
dofile("Helper/CurrentExecution.lua")
dofile("Helper/CustomTostring.lua")
dofile("Helper/ErrorHandler.lua")
dofile("Helper/FunctionForwarder.lua")
dofile("Helper/Metatable.lua")
dofile("Helper/MyGuiScreenSize.lua")
dofile("Helper/PredictablePairs.lua")
dofile("Helper/StringHash.lua")
dofile("Helper/TableClone.lua")
dofile("Helper/TablePrint.lua")
dofile("Helper/TableUtils.lua")
dofile("Helper/XMLEscape.lua")

dofile("Helper/Binding.lua")

dofile("Managers/TextManager.lua")

sm.regui = sm.regui or {}
sm.regui.internal = sm.regui.internal or {}

dofile("XMLColorful.lua")
dofile("Utils.lua")

dofile("Additions/FullscreenInterface.lua")

function sm.regui.internal.executeCode(functionPath, ...)
    ErrorHandler.AssertArgument(functionPath, 1, "string")

    assert(type(sm.regui.internal.tool) == "Tool", "Cannot execute executeCode before MainTool has been initialized!")

    local packetData = {}
    packetData.functionPath = functionPath
    packetData.arguments = {...}
    packetData.totalArguments = select("#", ...)

    sm.event.sendToTool(sm.regui.internal.tool, "svcl_executeCode", packetData)
end

ExecuteCodeAsReGui = CreateFunctionForwarder("sm.regui.internal.executeCode")

sm.regui.createGuiFromLayout = CreateFunctionForwarder("sm.regui.guiinterface.new")
sm.regui.createGui = CreateFunctionForwarder("sm.regui.guiinterface.newBlank")

sm.regui.createFullscreenInterfaceFromLayout = CreateFunctionForwarder("sm.regui.fullscreenInterface.new")
sm.regui.createFullscreenInterface = CreateFunctionForwarder("sm.regui.fullscreenInterface.newBlank")

sm.regui.createController = CreateFunctionForwarder("sm.regui.controller.newBlank")

dofile("GUIInterface.lua")
dofile("GUIInterfaceWrap.lua")

dofile("Widget.lua")
dofile("Controller.lua")

dofile("Cache/CacheManager.lua")

---@class MainToolClass : ToolClass
MainToolClass = class()

function MainToolClass:server_onCreate()
    sm.regui.internal.tool = self.tool
end

function MainToolClass:server_onRefresh()
    self:server_onCreate()
end

---@param data {functionPath: string, arguments: any[], totalArguments: integer}
function MainToolClass:svcl_executeCode(data, player)
    if player then
        return
    end

    if sm.isServerMode() then
        return
    end

    ErrorHandler.AssertArgument(data, 1, "table")

    -- Hack but works
    CreateFunctionForwarder(data.functionPath)(unpack(data.arguments, 1, data.totalArguments))
end