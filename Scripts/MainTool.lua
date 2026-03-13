print("-- sm.regui Initalization --")

dofile("Scripts/Helper/CustomTostring.lua")
dofile("Helper/FunctionForwarder.lua")
dofile("Helper/Metatable.lua")

sm.regui = {}
sm.regui.createGuiFromLayout = CreateFunctionForwarder("sm.regui.guiinterface.new")
sm.regui.createEmptyGui = CreateFunctionForwarder("sm.regui.guiinterface.newBlank")

dofile("Renderer.lua")

---@class MainToolClass : ToolClass
MainToolClass = class()