print("-- sm.regui Initalization --")

dofile("Helper/ErrorHandler.lua")
dofile("Helper/Metatable.lua")
dofile("Helper/CustomTostring.lua")
dofile("Helper/ContentPath.lua")
dofile("Helper/FunctionForwarder.lua")
dofile("Helper/Binding.lua")
dofile("Helper/TableClone.lua")

dofile("XMLColorful.lua")

GTempDataModInstalled = GTempDataModInstalled or sm.tempDataMod_installed

sm.regui = {}
sm.regui.createGuiFromLayout = CreateFunctionForwarder("sm.regui.guiinterface.new")
sm.regui.createGui = CreateFunctionForwarder("sm.regui.guiinterface.newBlank")

dofile("GUIInterface.lua")
dofile("Widget.lua")

---@class MainToolClass : ToolClass
MainToolClass = class()
