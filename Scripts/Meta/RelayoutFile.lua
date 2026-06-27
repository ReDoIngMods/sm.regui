---@alias PropertyTable table<string, string|integer|number|boolean>

---@class Internal.ReGui.Meta.RelayoutFile
---@field version 2
---@field metadata Internal.ReGui.Meta.RelayoutFile.Metadata
---@field data Internal.ReGui.Meta.RelayoutFile.Root

---@class Internal.ReGui.Meta.RelayoutFile.Metadata
---@field screenWidth integer
---@field screenHeight integer

---@class Internal.ReGui.Meta.RelayoutFile.Root
---@field type "Layout"
---@field version string
---@field children Internal.ReGui.Meta.RelayoutFile.Child[]

---@class Internal.ReGui.Meta.RelayoutFile.Child
---@field nodeProperties PropertyTable
---@field coordinate Internal.ReGui.Meta.RelayoutFile.Child.Coordinate
---@field properties PropertyTable
---@field userStrings PropertyTable
---@field controllers Internal.ReGui.Meta.RelayoutFile.Controller[]
---@field children Internal.ReGui.Meta.RelayoutFile.Child[]

---@class Internal.ReGui.Meta.RelayoutFile.Child.Coordinate
---@field x number
---@field y number
---@field width number
---@field height number
---@field mode ReGui.CoordinateMode

---@class Internal.ReGui.Meta.RelayoutFile.Controller
---@field type "ControllerPosition"|"ControllerFadeAlpha"|"ControllerEdgeHide"
---@field Coord Internal.ReGui.Meta.RelayoutFile.Child.Coordinate?
---@field Function string?
---@field Position {x: number, y: number}?
---@field Size {x: number, y: number}?
---@field Time number?
---@field Alpha number?
---@field Coef number?
---@field Enabled boolean?
---@field RemainPixels integer?
---@field ShadowSize integer?