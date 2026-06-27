local function findIf(tbl, predicate)
    for key, value in ipairs(tbl) do
        if predicate(key, value) then
            return key, value
        end
    end
end

---@param commands table
---@param name string
---@param arguments table
---@param matchSlots boolean[]
---@return boolean
local function eraseMatching(commands, name, arguments, matchSlots)
    local changed = false
    while true do
        local key = findIf(commands, function(_, entry)
            if entry.name ~= name then
                return false
            end

            for index = 1, math.min(#entry.arguments, #matchSlots) do
                if matchSlots[index] and arguments[index] ~= entry.arguments[index] then
                    return false
                end
            end

            return true
        end)

        if key then
            table.remove(commands, key)
            changed = true
        else
            break
        end
    end

    return changed
end

---@param commands table
---@param names string[]
---@param arguments table
---@param matchSlots boolean[]
local function eraseCross(commands, names, arguments, matchSlots)
    local nameSet = {}
    for _, n in ipairs(names) do nameSet[n] = true end

    local index = #commands
    while index >= 1 do
        local entry = commands[index]
        if nameSet[entry.name] then
            local match = true
            for slot = 1, math.min(#entry.arguments, #matchSlots) do
                if matchSlots[slot] and arguments[slot] ~= entry.arguments[slot] then
                    match = false
                    break
                end
            end

            if match then
                table.remove(commands, index)
            end
        end

        index = index - 1
    end
end

---@alias ArgSpec string[]|string

---@class CommandDefinition
---@field arguments ArgSpec[]
---@field erases boolean[]|nil
---@field crossErases {names:string[], slots:boolean[]}|nil
---@field validate (fun(arguments:table):nil)|nil

---@type table<string, CommandDefinition>
local COMMANDS = {
    setVisible = {
        arguments = {"string", "boolean"},
        erases = {true, false},
    },
    setColor = {
        arguments = {"string", "Color"},
        erases = {true, false},
    },

    setFocus = {
        arguments = {"string"},
        erases = {true},
    },

    setHost = {
        arguments = {"string", {"Shape", "Character"}, {"string", "nil"}},
        erases = {true, false, false},
    },

    setWorldPosition = {
        arguments = {"string", {"World", "nil"}},
        erases = {true, false},
    },

    setFadeRange = {
        arguments = {"number"},
        erases = {false},
    },

    setMaxRenderDistance = {
        arguments = {"number"},
        erases = {false},
    },

    setRequireLineOfSight = {
        arguments = {"boolean"},
        erases = {false},
    },

    setImage = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    setIconImage = {
        arguments = {"string", "Uuid"},
        erases = {true, false},
    },

    setItemIcon = {
        arguments = {"string", "string", "string", "string"},
        erases = {true, false, false, false},
    },

    setMeshPreview = {
        arguments = {"string", "Uuid"},
        erases = {true, false},
    },

    setButtonCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    setButtonState = {
        arguments = {"string", "boolean"},
        erases = {true, false},
    },

    setGridButtonCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    createHorizontalSlider = {
        arguments = {"string", "number", "number", "string", {"boolean", "nil"}},
        erases = {true, false, false, false, false},
    },

    createVerticalSlider = {
        arguments = {"string", "number", "number", "string"},
        erases = {true, false, false, false},
    },

    setSliderCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    setSliderData = {
        arguments = {"string", "number", "number"},
        erases = {true, false, false},
    },

    setSliderRange = {
        arguments = {"string", "number"},
        erases = {true, false},
    },

    setSliderRangeLimit = {
        arguments = {"string", "number"},
        erases = {true, false},
    },

    setSliderPosition = {
        arguments = {"string", "number"},
        erases = {true, false},
    },

    createDropDown = {
        arguments = {"string", "string", "table"},
        erases = {true, false, false},
    },

    setSelectedDropDownItem = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    addListItem = {
        arguments = {"string", "string", "table"},
    },

    clearList = {
        arguments = {"string"},
        erases = {true},
        crossErases = {
            names = {"addListItem", "setSelectedListItem", "setListSelectionCallback"},
            slots = {true},
        },
    },

    setListSelectionCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    setSelectedListItem = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    addGridItem = {
        arguments = {"string", "table"},
    },

    addGridItemsFromFile = {
        arguments = {"string", "string", {"table", "nil"}},
    },

    clearGrid = {
        arguments = {"string"},
        erases = {true},
        crossErases = {
            names = {
                "addGridItem", "addGridItemsFromFile",
                "setGridItem", "setGridSize", "createGridFromJson",
                "setGridItemChangedCallback", "setGridMouseFocusCallback",
                "setGridButtonCallback",
            },
            slots = {true},
        },
    },

    createGridFromJson = {
        arguments = {"string", "table"},
        erases = {true, false},
        validate = function(arguments)
            local data = arguments[2]
            ErrorHandler.AssertTableValue(data, "type", "string")
            ErrorHandler.AssertTableValue(data, "layout", "string")
            ErrorHandler.AssertTableValue(data, "itemWidth", "number")
            ErrorHandler.AssertTableValue(data, "itemHeight", "number")
            ErrorHandler.AssertTableValue(data, "itemCount", "number")
        end,
    },

    setGridItem = {
        arguments = {"string", {"number"}, "table"},
        erases = {true, true, false},
    },

    setGridSize = {
        arguments = {"string", {"number"}},
        erases = {true, false},
    },

    setGridItemChangedCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    setGridMouseFocusCallback = {
        arguments = {"string", "string", "string"},
        erases = {true, false, false},
    },

    setContainer = {
        arguments = {"string", {"Container"}},
        erases = {true, false},
    },

    setContainers = {
        arguments = {"string", "table"},
        erases = {true, false},
        validate = function(arguments)
            local containers = arguments[2]
            for index, container in ipairs(containers) do
                ErrorHandler.AssertTableValue(containers, "[" .. index .. "]", "Container")
            end
        end,
    },

    playEffect = {
        arguments = {"string", "string", {"boolean", "nil"}},
    },

    stopEffect = {
        arguments = {"string", "string", {"boolean", "nil"}},
    },

    playGridEffect = {
        arguments = {"string", "number", "string", {"boolean", "nil"}},
    },

    stopGridEffect = {
        arguments = {"string", "number", "string"},
    },

    setOnCloseCallback = {
        arguments = {"string"},
        erases = {false},
    },

    setTextAcceptedCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    setTextChangedCallback = {
        arguments = {"string", "string"},
        erases = {true, false},
    },

    addToPickupDisplay = {
        arguments = {"Uuid", "number"},
    },

    trackQuest = {
        arguments = {"string", "string", "boolean", "table"},
        erases = {true, false, false, false},
        validate = function(arguments)
            local tasks = arguments[4]
            ErrorHandler.AssertTableValue(tasks, "name", "string")
            ErrorHandler.AssertTableValue(tasks, "text", "string")
            ErrorHandler.AssertTableValue(tasks, "count", "number")
            ErrorHandler.AssertTableValue(tasks, "target", "number")
            ErrorHandler.AssertTableValue(tasks, "complete", "boolean")
        end,
    },

    untrackQuest = {
        arguments = {"string"},
        erases = {true},
    },
}

local function generateMethods()
    for name, definition in pairs(COMMANDS) do
        sm.regui.guiinterface[name] = function(self, ...)
            ErrorHandler.AssertSelf(self, "ReGui.GUIInterface", #definition.arguments > 0 )
            
            local arguments = {...}
            for index, typeSet in ipairs(definition.arguments) do
                ErrorHandler.AssertArgument(arguments[index], index, typeSet)
            end

            if definition.validate then
                local success, errorMessage = pcall(definition.validate, arguments)
                assert(success, errorMessage)
            end

            if definition.erases then
                eraseMatching(self.commands, name, arguments, definition.erases)
            end

            if definition.crossErases then
                eraseCross(self.commands, definition.crossErases.names, arguments, definition.crossErases.slots)
            end

            table.insert(self.commands, {name = name, arguments = arguments, totalArguments = select("#", ...)})
            if self:isActive() then
                self.gui[name](self.gui, ...)
            end
        end
    end
end

generateMethods()