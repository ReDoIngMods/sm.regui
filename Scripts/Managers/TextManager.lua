---@class Internal.ReGui.TextManager.Class
TextManager = {}
TextManager.__index = TextManager
TextManager.__type = "ReGui.TextManager"

local function DefaultTranslator(...)
    return string.format(...)
end

function TextManager.new(guiInterface)
    ErrorHandler.AssertArgument(guiInterface, 1, "ReGui.GUIInterface")

    ---@class Internal.ReGui.TextManager.Object : Internal.ReGui.TextManager.Class
    local self = setmetatable({}, TextManager)
    self.guiInterface = guiInterface ---@type ReGui.GuiInterface
    self.translatorFunction = DefaultTranslator

    return self
end

---@param self Internal.ReGui.TextManager.Object
---@return Internal.ReGui.TextManager.Object
function TextManager:clone()
    ErrorHandler.AssertSelf(self, TextManager.__type)

    local clone = TextManager.new(self.guiInterface)
    clone.translatorFunction = self.translatorFunction

    return clone
end

---@param self Internal.ReGui.TextManager.Object
---@return fun(...: any): string
function TextManager:getTranslatorFunction()
    ErrorHandler.AssertSelf(self, TextManager.__type)

    return self.translatorFunction
end

---@param self Internal.ReGui.TextManager.Object
---@param translatorFunction fun(...: any): string
function TextManager:setTranslatorFunction(translatorFunction)
    ErrorHandler.AssertSelf(self, TextManager.__type, true)
    ErrorHandler.AssertArgument(translatorFunction, 2, {"function"})

    if not translatorFunction then
        self.translatorFunction = DefaultTranslator
        return
    end

    local function safeWrapper(...)
        local data = PackTable(translatorFunction(...))
        return table.concat(data, "", 1, data.n)
    end

    self.translatorFunction = safeWrapper
end

---@param self Internal.ReGui.TextManager.Object
function TextManager:translateText(...)
    ErrorHandler.AssertSelf(self, TextManager.__type)

    return self.translatorFunction(...)
end