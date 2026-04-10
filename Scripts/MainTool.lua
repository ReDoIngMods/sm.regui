print([[    __          __   ___  __           ]])
print([[   /__`  |\/|  |__) |__  / _` |  | |   ]])
print([[   .__/  |  | .|  \ |___ \__> \__/ |   ]])
print([[   ReDoing Graphical User Interfaces   ]])
print([[                                       ]])

dofile("PrintHook.lua")

dofile("Helper/ErrorHandler.lua")
dofile("Helper/Metatable.lua")
dofile("Helper/CustomTostring.lua")
dofile("Helper/ContentPath.lua")
dofile("Helper/FunctionForwarder.lua")
dofile("Helper/Binding.lua")
dofile("Helper/TableClone.lua")

sm.regui = {}
sm.regui.internal = {}

dofile("XMLColorful.lua")

function sm.regui.internal.executeCode(functionPath, ...)
    ErrorHandler:AssertEnviroment(true, false)
    ErrorHandler:AssertArgument(functionPath, 1, "string")

    assert(type(sm.regui.internal.tool) == "Tool", "Cannot execute executeCode before MainTool has been initialized!")

    local packetData = {}
    packetData.functionPath = functionPath
    packetData.arguments = { ... }
    packetData.totalArguments = select("#", ...)

    sm.event.sendToTool(sm.regui.internal.tool, "sv_executeCode", packetData)
end

sm.regui.createGuiFromLayout = CreateFunctionForwarder("sm.regui.guiinterface.new")
sm.regui.createGui = CreateFunctionForwarder("sm.regui.guiinterface.newBlank")

dofile("GUIInterface.lua")
dofile("Widget.lua")

---@class MainToolClass : ToolClass
MainToolClass = class()

function MainToolClass:server_onCreate()
    sm.regui.internal.tool = MainToolClass
end

---@param data {functionPath: string, arguments: any[], totalArguments: integer}
---@param player Player?
function MainToolClass:sv_executeCode(data, player)
    ErrorHandler:AssertEnviroment(true, true)
    ErrorHandler:AssertArgument(data, 1, "table")
    ErrorHandler:AssertArgument(player, 2, "Player")
end
