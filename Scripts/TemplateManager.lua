---@class sm.regui.template
sm.regui.template = {}

function sm.regui.template.createTemplate(path)
    AssertArgument(path, 1, {"string"})
    ValueAssert(sm.json.fileExists(path), 1, "File not found!")

    ---@class ReGui.Template : sm.regui.template
    local self = {
        data = sm.json.open(path) ---@type ReGui.LayoutFile
    }

    ValueAssert(self.data.identifier == "ReGui"         , 1, "Not a ReGui Layout File!")
    ValueAssert(self.data.version    == sm.regui.version, 1, "ReGui version mismatch!")

    for key, value in pairs(sm.regui.template) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    return self
end

---@param reGuiInterface ReGui.GUI
function sm.regui.template.createTemplateFromInterface(reGuiInterface)
    AssertArgument(reGuiInterface, 1, {"table"}, {"ReGuiInterface"})

    ---@class ReGui.Template : sm.regui.template
    local self = {
        data = unpack({reGuiInterface.data})
    }

    for key, value in pairs(sm.regui.template) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    return self
end

---@param self ReGui.Template
---@param reGuiInterface ReGui.GUI
function sm.regui.template:applyTemplateFromInterface(reGuiInterface)
    AssertArgument(reGuiInterface, 1, {"table"}, {"ReGuiInterface"})

    local outputData = unpack({self.data})
    
    ---@param widget ReGui.LayoutFile.Widget
    ---@return ReGui.LayoutFile.Widget?
    local function iterator(widget)
        if widget.isTemplateContents then
            return widget
        end

        for _, child in pairs(widget.children) do
            local result = iterator(child)
            if result then
                return result
            end
        end
    end

    local templateWidget = nil

    for _, widget in pairs(outputData.data) do
        templateWidget = iterator(widget)
        if templateWidget then break end
    end

    
    if false then
        --- Stupid VSCode Hack
        ---@type ReGui.LayoutFile.Widget
        templateWidget = templateWidget
    end

    ValueAssert(templateWidget, 1, "No template widget found!")

    local gui = sm.regui.newBlank()
    gui.data = outputData
    gui.commands = unpack({reGuiInterface.commands})
    gui.callbacks = unpack({reGuiInterface.callbacks})
    gui.modifiers = unpack({reGuiInterface.modifiers})
    gui.settings = unpack({reGuiInterface.settings})

    for _, widget in pairs(reGuiInterface.data.data) do
        table.insert(templateWidget.children, unpack({widget}))
    end

    templateWidget.isTemplateContents = false

    return gui
end

---@param self ReGui.Template
---@param path string
function sm.regui.template:applyTemplate(path)
    return self:applyTemplateFromInterface(sm.regui.new(path))
end

print("Loaded TemplateManager!")