---@class sm.regui.template
sm.regui.template = {}

function sm.regui.template.createTemplate(path)
    assert(type(path) == "string", "path is expected to be a string!")
    assert(sm.json.fileExists(path), "File not found!")

    print("Creating new template...")

    ---@class ReGui.Template : sm.regui.template
    local self = {
        data = sm.json.open(path) ---@type ReGui.LayoutFile
    }

    assert(self.data.identifier == "ReGui", "Not a ReGui Layout File!")
    assert(self.data.version == sm.regui.version, "ReGui version mismatch!")

    for key, value in pairs(sm.regui.template) do
        if type(value) == "function" then
            self[key] = value
        end
    end

    return self
end

---@param reGuiInterface ReGui.GUI
function sm.regui.template.createTemplateFromInterface(reGuiInterface)
    assert(type(reGuiInterface) == "table", "reGuiInterface is expected to be a table!")

    print("Creating new template from interface...")

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
function sm.regui.template:applyTemplate(reGuiInterface)
    assert(type(reGuiInterface) == "table", "Invalid ReGuiInterface!")
    
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

    assert(templateWidget, "No template widget found!")

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

print("Loaded TemplateManager!")