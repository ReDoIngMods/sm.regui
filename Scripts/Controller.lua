-- Avaliable controller properties:

-- ControllerPosition: Coord, Function, Position, Size, Time
-- ControllerFadeAlpha: Alpha, Coef, Enabled
-- ControllerEdgeHide: RemainPixels, ShadowSize, Time

---@class Internal.ReGui.Controller.Class
local Controller = sm.regui.controllers or {}
Controller.__type = "Regui.Controller"
Controller.__index = function (tbl, index)
    local isDeleted = rawget(tbl, "isDeleted")
    if isDeleted then
        error(string.format("Attempt to access %q on deleted controller", tostring(index)), 2)
    end

    return Controller[index]
end
Controller.__tostring = CreateCustomTostringFunction(Controller.__type)

---@param node Internal.ReGui.Meta.RelayoutFile.Controller
---@param parent Internal.ReGui.Widget.Object?
function Controller.parseController(node, parent)
    ---@class Internal.ReGui.Controller.Object : Internal.ReGui.Controller.Class
    local self = {}
    self.type = node.type
    self.parent = parent

    if self.type == "ControllerPosition" then
        self.coord = node.Coord ---@type Internal.ReGui.Meta.RelayoutFile.Child.Coordinate?
        self.functionPath = node.Function ---@type string?
        self.position = node.Position ---@type {x: number, y: number}?
        self.size = node.Size ---@type {x: number, y: number}?
        self.time = node.Time ---@type number?
    elseif self.type == "ControllerFadeAlpha" then
        self.alpha = node.Alpha ---@type number?
        self.coef = node.Coef ---@type number?
        self.enabled = node.Enabled ---@type boolean?
    elseif self.type == "ControllerEdgeHide" then
        self.remainPixels = node.RemainPixels ---@type integer?
        self.shadowSize = node.ShadowSize ---@type integer?
        self.time = node.Time ---@type number?
    else
        error(string.format("Unknown controller type: %s", tostring(self.type)), 2)
    end

    return setmetatable(self, Controller)
end

function Controller.newBlank(type, parent)
    ErrorHandler.AssertArgument(type, 1, "string")
    ErrorHandler.AssertArgument(parent, 2, {"table", "nil"})

    ---@class Internal.ReGui.Controller.Object
    local self = {}
    self.type = type
    self.parent = parent

    return setmetatable(self, Controller)
end

---@param self Internal.ReGui.Controller.Object
---@return Internal.ReGui.Controller.Object
function Controller:clone()
    ErrorHandler.AssertSelf(self, Controller.__type)

    local copy = {}
    for key, value in pairs(self) do
        copy[key] = value
    end

    return setmetatable(copy, Controller)
end

---@param self Internal.ReGui.Controller.Object
function Controller:destroy()
    self:setParent(nil)
    self.isDeleted = true
end

---@param self Internal.ReGui.Controller.Object
function Controller:getParent()
    ErrorHandler.AssertSelf(self, Controller.__type)

    return self.parent
end

---@param self Internal.ReGui.Controller.Object
---@param widget Internal.ReGui.Widget.Object?
function Controller:setParent(widget)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertArgument(widget, 2, {"table", "nil"})

    if self.parent then
        for index, controller in ipairs(self.parent.controllers) do
            if controller == self then
                table.remove(self.parent.controllers, index)
                break
            end
        end
    end

    self.parent = widget

    if widget then
        table.insert(widget.controllers, self)
    end
end

---@param self Internal.ReGui.Controller.Object
function Controller:getType()
    ErrorHandler.AssertSelf(self, Controller.__type)

    return self.type
end

---@param self Internal.ReGui.Controller.Object
function Controller:getCoordinate()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", nil, "Cannot get coordinate from a controller that is not of type 'ControllerPosition'")

    return self.coord.x, self.coord.y, self.coord.width, self.coord.height
end

---@param self Internal.ReGui.Controller.Object
function Controller:getFunctionPath()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", nil, "Cannot get function path from a controller that is not of type 'ControllerPosition'")

    return self.functionPath
end

---@param self Internal.ReGui.Controller.Object
function Controller:getPosition()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", nil, "Cannot get position from a controller that is not of type 'ControllerPosition'")

    return self.position.x, self.position.y
end

---@param self Internal.ReGui.Controller.Object
function Controller:getSize()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", nil, "Cannot get size from a controller that is not of type 'ControllerPosition'")

    return self.size.x, self.size.y
end

---@param self Internal.ReGui.Controller.Object
function Controller:getTime()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition" or self.type == "ControllerEdgeHide", nil, "Cannot get time from a controller that is not of type 'ControllerPosition' or 'ControllerEdgeHide'")

    return self.time
end

---@param self Internal.ReGui.Controller.Object
function Controller:getAlpha()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", nil, "Cannot get alpha from a controller that is not of type 'ControllerFadeAlpha'")

    return self.alpha
end

---@param self Internal.ReGui.Controller.Object
function Controller:getCoef()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", nil, "Cannot get coef from a controller that is not of type 'ControllerFadeAlpha'")

    return self.coef
end

---@param self Internal.ReGui.Controller.Object
function Controller:getCoefSeconds()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", nil, "Cannot get coef seconds from a controller that is not of type 'ControllerFadeAlpha'")

    if self.coef then
        return 1 / self.coef
    else
        return nil
    end
end

---@param self Internal.ReGui.Controller.Object
function Controller:isEnabled()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", nil, "Cannot get enabled state from a controller that is not of type 'ControllerFadeAlpha'")

    return self.enabled
end

---@param self Internal.ReGui.Controller.Object
function Controller:getRemainPixels()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerEdgeHide", nil, "Cannot get remain pixels from a controller that is not of type 'ControllerEdgeHide'")

    return self.remainPixels
end

---@param self Internal.ReGui.Controller.Object
function Controller:getShadowSize()
    ErrorHandler.AssertSelf(self, Controller.__type)
    ErrorHandler.AssertCondition(self.type == "ControllerEdgeHide", nil, "Cannot get shadow size from a controller that is not of type 'ControllerEdgeHide'")

    return self.shadowSize
end

---@param self Internal.ReGui.Controller.Object
---@param x number
---@param y number
---@param width number
---@param height number
function Controller:setCoordinate(x, y, width, height)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", 1, "Cannot set coordinate on a controller that is not of type 'ControllerPosition'")
    ErrorHandler.AssertArgument(x, 2, {"number", "nil"})
    ErrorHandler.AssertArgument(y, 3, {"number", "nil"})
    ErrorHandler.AssertArgument(width, 4, {"number", "nil"})
    ErrorHandler.AssertArgument(height, 5, {"number", "nil"})

    self.coord.x = x or self.coord.x
    self.coord.y = y or self.coord.y
    self.coord.width = width or self.coord.width
    self.coord.height = height or self.coord.height
end

---@param self Internal.ReGui.Controller.Object
---@param functionPath string?
function Controller:setFunctionPath(functionPath)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", 1, "Cannot set function path on a controller that is not of type 'ControllerPosition'")
    ErrorHandler.AssertArgument(functionPath, 2, {"string", "nil"})

    self.functionPath = functionPath
end

---@param self Internal.ReGui.Controller.Object
---@param x number?
---@param y number?
function Controller:setPosition(x, y)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", 1, "Cannot set position on a controller that is not of type 'ControllerPosition'")
    ErrorHandler.AssertArgument(x, 2, {"number", "nil"})
    ErrorHandler.AssertArgument(y, 3, {"number", "nil"})

    self.position.x = x or self.position.x
    self.position.y = y or self.position.y
end

---@param self Internal.ReGui.Controller.Object
---@param width number?
---@param height number?
function Controller:setSize(width, height)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition", 1, "Cannot set size on a controller that is not of type 'ControllerPosition'")
    ErrorHandler.AssertArgument(width, 2, {"number", "nil"})
    ErrorHandler.AssertArgument(height, 3, {"number", "nil"})

    self.size.x = width or self.size.x
    self.size.y = height or self.size.y
end

---@param self Internal.ReGui.Controller.Object
---@param time number?
function Controller:setTime(time)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerPosition" or self.type == "ControllerEdgeHide", 1, "Cannot set time on a controller that is not of type 'ControllerPosition' or 'ControllerEdgeHide'")
    ErrorHandler.AssertArgument(time, 2, {"number", "nil"})

    self.time = time
end

---@param self Internal.ReGui.Controller.Object
---@param alpha number?
function Controller:setAlpha(alpha)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", 1, "Cannot set alpha on a controller that is not of type 'ControllerFadeAlpha'")
    ErrorHandler.AssertArgument(alpha, 2, {"number", "nil"})

    self.alpha = alpha
end

---@param self Internal.ReGui.Controller.Object
---@param coef number?
function Controller:setCoef(coef)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", 1, "Cannot set coef on a controller that is not of type 'ControllerFadeAlpha'")
    ErrorHandler.AssertArgument(coef, 2, {"number", "nil"})

    self.coef = coef
end

---@param self Internal.ReGui.Controller.Object
---@param seconds number?
function Controller:setCoefSeconds(seconds)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", 1, "Cannot set coef seconds on a controller that is not of type 'ControllerFadeAlpha'")
    ErrorHandler.AssertArgument(seconds, 2, {"number", "nil"})

    if seconds then
        self.coef = 1 / seconds
    else
        self.coef = nil
    end
end

---@param self Internal.ReGui.Controller.Object
---@param enabled boolean?
function Controller:setEnabled(enabled)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerFadeAlpha", 1, "Cannot set enabled state on a controller that is not of type 'ControllerFadeAlpha'")
    ErrorHandler.AssertArgument(enabled, 2, {"boolean", "nil"})

    self.enabled = enabled
end

---@param self Internal.ReGui.Controller.Object
---@param remainPixels integer?
function Controller:setRemainPixels(remainPixels)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerEdgeHide", 1, "Cannot set remain pixels on a controller that is not of type 'ControllerEdgeHide'")
    ErrorHandler.AssertArgument(remainPixels, 2, {"number", "nil"})

    self.remainPixels = remainPixels
end

---@param self Internal.ReGui.Controller.Object
---@param shadowSize integer?
function Controller:setShadowSize(shadowSize)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertCondition(self.type == "ControllerEdgeHide", 1, "Cannot set shadow size on a controller that is not of type 'ControllerEdgeHide'")
    ErrorHandler.AssertArgument(shadowSize, 2, {"number", "nil"})

    self.shadowSize = shadowSize
end

---@param self Internal.ReGui.Controller.Object
---@param indentationLevel integer?
---@param prettify boolean?
function Controller:renderController(indentationLevel, prettify)
    ErrorHandler.AssertSelf(self, Controller.__type, true)
    ErrorHandler.AssertArgument(indentationLevel, 2, {"number", "nil"})
    ErrorHandler.AssertArgument(prettify, 3, {"boolean", "nil"})

    indentationLevel = indentationLevel or 0
    prettify = type(prettify) == "boolean" and prettify or false

    local buffer = {}

    local function generateIndentation(level)
        return string.rep("    ", level)
    end

    local function insertProperty(indent, key, value)
        if value ~= nil then
            table.insert(buffer, string.format("%s<Property key=%q value=%q/>", indent, key, tostring(value)))
        end
    end

    local indentation = generateIndentation(indentationLevel)
    local innerIndentation = prettify and generateIndentation(indentationLevel + 1) or ""

    table.insert(buffer, string.format("%s<Controller type=%q>", indentation, self.type))

    local properties = {
        {"Coord", self.coord and string.format("%f %f %f %f", self.coord.x, self.coord.y, self.coord.width, self.coord.height) or nil},
        {"Function", self.functionPath},
        {"Position", self.position and string.format("%f %f", self.position.x, self.position.y) or nil},
        {"Size", self.size and string.format("%f %f", self.size.x, self.size.y) or nil},
        {"Time", self.time},
        {"Alpha", self.alpha},
        {"Coef", self.coef},
        {"Enabled", self.enabled},
        {"RemainPixels", self.remainPixels},
        {"ShadowSize", self.shadowSize},
   }

    for _, prop in ipairs(properties) do
        local key, value = prop[1], prop[2]
        if value ~= nil then
            if prettify then
                table.insert(buffer, "\n")
            end
            insertProperty(innerIndentation, key, value)
        end
    end

    if prettify then
        table.insert(buffer, "\n")
    end
    table.insert(buffer, string.format("%s</Controller>", indentation))

    return table.concat(buffer)
end

sm.regui.controllers = Controller