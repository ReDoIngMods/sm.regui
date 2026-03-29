---@diagnostic disable: missing-return

---sm.regui, ReDoing Graphical User Interfaces
sm.regui = {}

---Creates a GUI from a layout file
---@param path string The path to the layout file
---@return ReGui.GuiInterface The created GUI object
function sm.regui.createGuiFromLayout(path) end

---Creates an empty GUI
---@return ReGui.GuiInterface The created GUI object
function sm.regui.createGui() end

--- CLASSES ---

---A interface for creating and managing GUIs with sm.regui
---@class ReGui.GuiInterface
local GuiInterface = {}