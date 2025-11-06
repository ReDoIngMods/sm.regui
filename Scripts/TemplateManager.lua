---@class sm.regui.template
sm.regui.template = {}

function sm.regui.template.createTemplate(path)
    AssertArgument(path, 1, {"string"})
    ValueAssert(sm.json.fileExists(path), 1, "File not found!")

    ---@class ReGui.Template : sm.regui.template
    local self = {
        __type = "ReGuiUserdata",

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
        __type = "ReGuiUserdata",
        
        interface = reGuiInterface:clone()
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

    local clonedInterface = self.interface:clone()

    ---@param widget ReGui.Widget
    local function iterator(widget)
        if widget:isLocationForTemplateContents() then
            return widget
        end

        local templateWidget = nil
        for _, child in pairs(widget:getChildren()) do
            local found = iterator(child)
            if found then
                return found
            end
        end
    end

    local templateWidget = nil ---@type ReGui.Widget?
    for _, child in pairs(clonedInterface:getRootChildren()) do
        local found = iterator(child)
        if found then
            templateWidget = found
            break
        end
    end

    assert(type(templateWidget) ~= "nil", "Template widget not found")
    templateWidget:setLocationForTemplateContents(false)

    local duplicateReGuiInterface = reGuiInterface:clone()
    for _, widget in pairs(duplicateReGuiInterface:getRootChildren()) do
        widget:setParent(templateWidget)
    end

    return clonedInterface
end

---@param self ReGui.Template
---@param path string
function sm.regui.template:applyTemplate(path)
    return self:applyTemplateFromInterface(sm.regui.new(path))
end

print("Loaded TemplateManager!")