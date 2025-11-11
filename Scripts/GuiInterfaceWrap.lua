local function findIf(tbl, func)
    for index, value in ipairs(tbl) do
        if func(index, value) then
            return index, value
        end
    end
end

---@alias GuiInterfaceWrap.CommandsTbl table<string, table>[]
function generateEraser(matchesEnabled)
    return function(tbl, name, arguments)
        local function iterator(_, value)
            local valueName = value[1]
            if valueName ~= name then
                return false
            end

            local valueArguments = value[2]
            for index = 1, math.min(#valueArguments, #matchesEnabled) do
                if matchesEnabled[index] and arguments[index] ~= valueArguments[index] then
                    return false
                end
            end

            return true
        end
        
        local hasChanges = false
        while true do
            local key = findIf(tbl, iterator)
            if key then
                table.remove(tbl, key)
                hasChanges = true
            else
                break
            end
        end

        return hasChanges
    end
end

local eraserTable = {
    -- When setting a grid item, previous calls for the same grid and index become obsolete.
    ["setGridItem"] = generateEraser({true, true, false}),

    -- Setting grid size replaces previous sizes for the same grid.
    ["setGridSize"] = generateEraser({true, false}),

    -- Changing color or visibility overrides earlier commands on the same widget.
    ["setColor"] = generateEraser({true, false}),
    ["setVisible"] = generateEraser({true, false}),

    -- Replacing container(s) invalidates earlier container assignments.
    ["setContainer"] = generateEraser({true, false}),
    ["setContainers"] = generateEraser({true, false}),

    -- Reassigning a callback replaces earlier ones on the same widget/list/etc.
    ["setButtonCallback"] = generateEraser({true, false}),
    ["setGridButtonCallback"] = generateEraser({true, false}),
    ["setListSelectionCallback"] = generateEraser({true, false}),
    ["setSliderCallback"] = generateEraser({true, false}),
    ["setTextAcceptedCallback"] = generateEraser({true, false}),
    ["setTextChangedCallback"] = generateEraser({true, false}),
    ["setGridItemChangedCallback"] = generateEraser({true, false}),
    ["setGridMouseFocusCallback"] = generateEraser({true, false, false}),

    -- Sliders overwrite older range/position/value commands for the same slider.
    ["setSliderData"] = generateEraser({true, true, true}),
    ["setSliderRange"] = generateEraser({true, true}),
    ["setSliderRangeLimit"] = generateEraser({true, true}),
    ["setSliderPosition"] = generateEraser({true, true}),

    -- Dropdown item selection overrides previous ones on the same dropdown.
    ["setSelectedDropDownItem"] = generateEraser({true, false}),
    ["setSelectedListItem"] = generateEraser({true, false}),

    -- Setting icon/image replaces older calls for the same widget.
    ["setIconImage"] = generateEraser({true, false}),
    ["setImage"] = generateEraser({true, false}),
    ["setItemIcon"] = generateEraser({true, false, false, false}),

    -- Setting focus, host, or mesh preview should replace prior ones.
    ["setFocus"] = generateEraser({true, false}),
    ["setHost"] = generateEraser({true, false, false}),
    ["setMeshPreview"] = generateEraser({true, false}),

    -- Setting quest tracking or untracking cancels prior commands with same quest.
    ["trackQuest"] = generateEraser({true, false, false, false}),
    ["untrackQuest"] = generateEraser({true, false}),

    -- Grid/list clearing should remove previous additions before it.
    ["clearGrid"] = generateEraser({true}),
    ["clearList"] = generateEraser({true}),
}

---@param self ReGui.GUI
local function onCommandRan(self)
    local latestCommand = self.commands[#self.commands]
    local name = latestCommand[1]
    local args = latestCommand[2]

   local func = eraserTable[name]
    if func then
        func(self.commands, name, args)
    end

    if self:isActive() then
        self.gui[name](self.gui, unpack(args))
    end
end

---@param self ReGui.GUI
function sm.regui:addGridItem(widgetName, item)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(item, 2, "table")

    table.insert(self.commands, {"addGridItem", {widgetName, item}})
    onCommandRan(self)
end

---@param self ReGui.GUI
function sm.regui:addGridItemsFromFile(gridName, jsonPath, additionalData)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(jsonPath, 2, {"string"})
    AssertArgument(additionalData, 3, {"table"})

    table.insert(self.commands, {"addGridItemsFromFile", {gridName, jsonPath, additionalData}})
    onCommandRan(self)
end

---@param self ReGui.GUI
function sm.regui:addListItem(listName, itemName, data)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})
    AssertArgument(itemName, 2, {"string"})
    AssertArgument(data, 3, {"table"})

    table.insert(self.commands, {"addListItem", {listName, itemName, data}})
    onCommandRan(self)
end

---@param self ReGui.GUI
function sm.regui:clearGrid(gridName)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})

    table.insert(self.commands, {"clearGrid", {gridName}})
    onCommandRan(self)
end

---@param self ReGui.GUI
function sm.regui:clearList(listName)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})

    table.insert(self.commands, {"clearList", {listName}})
    onCommandRan(self)
end

function sm.regui:createDropDown(widgetName, functionName, options)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(functionName, 2, {"string"})
    AssertArgument(options, 3, {"table"})

    table.insert(self.commands, {"createDropDown", {widgetName, functionName, options}})
    onCommandRan(self)
end

function sm.regui:createGridFromJson(gridName, data)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(data, 2, {"table"})

    ValueAssert(type(data.type      ) == "string", 2, "data.type is expected to be a string")
    ValueAssert(type(data.layout    ) == "string", 2, "data.layout is expected to be a string")
    ValueAssert(type(data.itemWidth ) == "number", 2, "data.itemWidth is expected to be a number")
    ValueAssert(type(data.itemHeight) == "number", 2, "data.itemHeight is expected to be a number")
    ValueAssert(type(data.itemCount ) == "number", 2, "data.itemCount is expected to be a number")

    table.insert(self.commands, {"createGridFromJson", {gridName, data}})
    onCommandRan(self)
end

function sm.regui:createHorizontalSlider(widgetName, range, value, callback, enableNumbers)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(range, 2, {"table"})
    AssertArgument(value, 3, {"number"})
    AssertArgument(callback, 4, {"string"})
    AssertArgument(enableNumbers, 5, {"boolean", "nil"})

    if enableNumbers == nil then
        enableNumbers = false
    end

    table.insert(self.commands, {"createHorizontalSlider", {widgetName, range, value, callback, enableNumbers}})
    onCommandRan(self)
end

function sm.regui:createVerticalSlider(widgetName, range, value, callback)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(range, 2, {"table"})
    AssertArgument(value, 3, {"number"})
    AssertArgument(callback, 4, {"string"})

    table.insert(self.commands, {"createVerticalSlider", {widgetName, range, value, callback}})
    onCommandRan(self)
end

function sm.regui:destroy()
    SelfAssert(self)
    warn("UNIMPLEMENTED destroy")
end

function sm.regui:playEffect(widget, effect, restart)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(effect, 2, {"string"})
    AssertArgument(restart, 3, {"boolean"})

    table.insert(self.commands, {"playEffect", {widget, effect, restart}})
    onCommandRan(self)
end

function sm.regui:playGridEffect(gridName, index, effectName, restart)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(index, 2, {"number"})
    AssertArgument(effectName, 3, {"string"})
    AssertArgument(restart, 4, {"boolean"})

    table.insert(self.commands, {"playGridEffect", {gridName, index, effectName, restart}})
    onCommandRan(self)
end

function sm.regui:setButtonCallback(button, callback)
    SelfAssert(self)
    AssertArgument(button, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setButtonCallback", {button, callback}})
    onCommandRan(self)
end

function sm.regui:setButtonState(button, state)
    SelfAssert(self)
    AssertArgument(button, 1, {"string"})
    AssertArgument(state, 2, {"boolean"})

    table.insert(self.commands, {"setButtonState", {button, state}})
    onCommandRan(self)
end

function sm.regui:setColor(widget, color)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(color, 2, {"Color"})

    table.insert(self.commands, {"setColor", {widget, color}})
    onCommandRan(self)
end

function sm.regui:setContainer(gridName, container)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(container, 2, {"Container"})

    table.insert(self.commands, {"setContainer", {gridName, container}})
    onCommandRan(self)
end

function sm.regui:setContainers(gridName, containers)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(containers, 2, {"table"})

    for i, container in ipairs(containers) do
        ValueAssert(type(container) == "Container", 2, "container is expected to be a Container")
    end

    table.insert(self.commands, {"setContainers", {gridName, containers}})
    onCommandRan(self)
end

function sm.regui:setFadeRange(range)
    SelfAssert(self)
    AssertArgument(range, 1, {"number"})

    table.insert(self.commands, {"setFadeRange", {range}})
    onCommandRan(self)
end

function sm.regui:setFocus(widget)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})

    table.insert(self.commands, {"setFocus", {widget}})
    onCommandRan(self)
end

function sm.regui:setGridButtonCallback(buttonName, callback)
    SelfAssert(self)
    AssertArgument(buttonName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setGridButtonCallback", {buttonName, callback}})
    onCommandRan(self)
end

function sm.regui:setGridItem(gridName, index, item)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(index, 2, {"number"})
    AssertArgument(item, 3, {"table"})

    table.insert(self.commands, {"setGridItem", {gridName, index, item}})
    onCommandRan(self)
end

function sm.regui:setGridItemChangedCallback(gridName, callback)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setGridItemChangedCallback", {gridName, callback}})
    onCommandRan(self)
end

function sm.regui:setGridMouseFocusCallback(widgetName, callbackName, gridName)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(callbackName, 2, {"string"})
    AssertArgument(gridName, 3, {"string"})

    table.insert(self.commands, {"setGridMouseFocusCallback", {widgetName, callbackName, gridName}})
    onCommandRan(self)
end

function sm.regui:setGridSize(gridName, size)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(size, 2, {"number"})

    table.insert(self.commands, {"setGridSize", {gridName, size}})
    onCommandRan(self)
end

function sm.regui:setHost(widget, host, joint)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(host, 2, {"Shape", "Character"})
    AssertArgument(joint, 3, {"string", "nil"})  -- optional

    table.insert(self.commands, {"setHost", {widget, host, joint}})
    onCommandRan(self)
end

function sm.regui:setIconImage(itemBox, uuid)
    SelfAssert(self)
    AssertArgument(itemBox, 1, {"string"})
    AssertArgument(uuid, 2, {"Uuid"})

    table.insert(self.commands, {"setIconImage", {itemBox, uuid}})
    onCommandRan(self)
end

function sm.regui:setImage(imageBox, image)
    SelfAssert(self)
    AssertArgument(imageBox, 1, {"string"})
    AssertArgument(image, 2, {"string"})

    local widget, _ = findWidgetRecursiveRaw(self, imageBox)
    ValueAssert(widget, 1, "Widget not found!")
    
    self.gui.modifiers[widget.instanceProperties.name] = self.gui.modifiers[widget.instanceProperties.name] or {}
    self.gui.modifiers[widget.instanceProperties.name].image = path
    
    table.insert(self.commands, {"setImage", {imageBox, image}})
    onCommandRan(self)
end

function sm.regui:setItemIcon(imageBox, itemResource, itemGroup, itemName)
    SelfAssert(self)
    AssertArgument(imageBox, 1, {"string"})
    AssertArgument(itemResource, 2, {"string"})
    AssertArgument(itemGroup, 3, {"string"})
    AssertArgument(itemName, 4, {"string"})

    table.insert(self.commands, {"setItemIcon", {imageBox, itemResource, itemGroup, itemName}})
    onCommandRan(self)
end

function sm.regui:setListSelectionCallback(listName, callback)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setListSelectionCallback", {listName, callback}})
    onCommandRan(self)
end

function sm.regui:setMaxRenderDistance(distance)
    SelfAssert(self)
    AssertArgument(distance, 1, {"number"})

    table.insert(self.commands, {"setMaxRenderDistance", {distance}})
    onCommandRan(self)
end

function sm.regui:setMeshPreview(widgetName, uuid)
    SelfAssert(self)
    AssertArgument(widgetName, 1, {"string"})
    AssertArgument(uuid, 2, {"Uuid"})

    table.insert(self.commands, {"setMeshPreview", {widgetName, uuid}})
    onCommandRan(self)
end

function sm.regui:setOnCloseCallback(callback)
    SelfAssert(self)
    AssertArgument(callback, 1, {"string"})

    table.insert(self.commands, {"setOnCloseCallback", {callback}})
    onCommandRan(self)
end

function sm.regui:setRequireLineOfSight(state)
    SelfAssert(self)
    AssertArgument(state, 1, {"boolean"})

    table.insert(self.commands, {"setRequireLineOfSight", {state}})
    onCommandRan(self)
end

function sm.regui:setSelectedDropDownItem(dropDownName, itemName)
    SelfAssert(self)
    AssertArgument(dropDownName, 1, {"string"})
    AssertArgument(itemName, 2, {"string"})

    table.insert(self.commands, {"setSelectedDropDownItem", {dropDownName, itemName}})
    onCommandRan(self)
end

function sm.regui:setSelectedListItem(listName, itemName)
    SelfAssert(self)
    AssertArgument(listName, 1, {"string"})
    AssertArgument(itemName, 2, {"string"})

    table.insert(self.commands, {"setSelectedListItem", {listName, itemName}})
    onCommandRan(self)
end

function sm.regui:setSliderCallback(sliderName, callback)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setSliderCallback", {sliderName, callback}})
    onCommandRan(self)
end

function sm.regui:setSliderData(sliderName, range, position)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(range, 2, {"number"})
    AssertArgument(position, 3, {"number"})

    table.insert(self.commands, {"setSliderData", {sliderName, range, position}})
    onCommandRan(self)
end

function sm.regui:setSliderPosition(sliderName, position)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(position, 2, {"number"})

    table.insert(self.commands, {"setSliderPosition", {sliderName, position}})
    onCommandRan(self)
end

function sm.regui:setSliderRange(sliderName, range)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(range, 2, {"number"})

    table.insert(self.commands, {"setSliderRange", {sliderName, range}})
    onCommandRan(self)
end

function sm.regui:setSliderRangeLimit(sliderName, limit)
    SelfAssert(self)
    AssertArgument(sliderName, 1, {"string"})
    AssertArgument(limit, 2, {"number"})

    table.insert(self.commands, {"setSliderRangeLimit", {sliderName, limit}})
    onCommandRan(self)
end

function sm.regui:setTextAcceptedCallback(editboxName, callback)
    SelfAssert(self)
    AssertArgument(editboxName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setTextAcceptedCallback", {editboxName, callback}})
    onCommandRan(self)
end

function sm.regui:setTextChangedCallback(editboxName, callback)
    SelfAssert(self)
    AssertArgument(editboxName, 1, {"string"})
    AssertArgument(callback, 2, {"string"})

    table.insert(self.commands, {"setTextChangedCallback", {editboxName, callback}})
    onCommandRan(self)
end

function sm.regui:setVisible(widget, state)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(state, 2, {"boolean"})

    table.insert(self.commands, {"setVisible", {widget, state}})
    onCommandRan(self)
end

function sm.regui:setWorldPosition(pos, world)
    SelfAssert(self)
    AssertArgument(pos, 1, {"Vec3"})
    AssertArgument(world, 2, {"World"})

    table.insert(self.commands, {"setWorldPosition", {pos, world}})
    onCommandRan(self)
end

function sm.regui:stopEffect(widget, effect, immediate)
    SelfAssert(self)
    AssertArgument(widget, 1, {"string"})
    AssertArgument(effect, 2, {"string"})
    AssertArgument(immediate, 3, {"boolean"})

    table.insert(self.commands, {"stopEffect", {widget, effect, immediate}})
    onCommandRan(self)
end

function sm.regui:stopGridEffect(gridName, index, effectName)
    SelfAssert(self)
    AssertArgument(gridName, 1, {"string"})
    AssertArgument(index, 2, {"number"})
    AssertArgument(effectName, 3, {"string"})

    table.insert(self.commands, {"stopGridEffect", {gridName, index, effectName}})
    onCommandRan(self)
end

function sm.regui:trackQuest(name, title, mainQuest, questTasks)
    SelfAssert(self)
    AssertArgument(name, 1, {"string"})
    AssertArgument(title, 2, {"string"})
    AssertArgument(mainQuest, 3, {"boolean"})
    AssertArgument(questTasks, 4, {"table"})

    -- QuestTasks structure
    --    {
    --      name = string,
    --      text = string,
    --      count = number,
    --      target = number,
    --      complete = bool
    --    }
    AssertArgument(questTasks.name, 4, {"string"})
    AssertArgument(questTasks.text, 4, {"string"})
    AssertArgument(questTasks.count, 4, {"number"})
    AssertArgument(questTasks.target, 4, {"number"})
    AssertArgument(questTasks.complete, 4, {"boolean"})

    table.insert(self.commands, {"trackQuest", {name, title, mainQuest, questTasks}})
    onCommandRan(self)
end

function sm.regui:untrackQuest(name)
    SelfAssert(self)
    AssertArgument(name, 1, {"string"})

    table.insert(self.commands, {"untrackQuest", {name}})
    onCommandRan(self)
end

print("Added GuiInterface wrapper!")