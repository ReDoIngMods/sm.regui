---@alias PropertyTable table<string, string|integer|number|boolean>

---@class Internal.ReGui.Meta.RelayoutFile
---@field version integer Expected to be 2
---@field metadata Internal.ReGui.Meta.RelayoutFile.Metadata
---@field data Internal.ReGui.Meta.RelayoutFile.Root

---@class Internal.ReGui.Meta.RelayoutFile.Metadata
---@field screenWidth integer
---@field screenHeight integer

---@class Internal.ReGui.Meta.RelayoutFile.Root
---@field type string Expected to be Layout
---@field version string
---@field children Internal.ReGui.Meta.RelayoutFile.Child[]

---@class Internal.ReGui.Meta.RelayoutFile.Child
---@field nodeProperties PropertyTable
---@field position Internal.ReGui.Meta.RelayoutFile.Child.Position
---@field properties PropertyTable
---@field userStrings PropertyTable
---@field controllers Internal.ReGui.Meta.RelayoutFile.Controller[]
---@field children Internal.ReGui.Meta.RelayoutFile.Child[]

---@class Internal.ReGui.Meta.RelayoutFile.Child.Position
---@field x number
---@field y number
---@field width number
---@field height number