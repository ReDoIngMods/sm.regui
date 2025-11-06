---@class ReGui.ModConfig.Config.NumberProperties
---@field min number
---@field max number
---@field integerOnly boolean

---@class ReGui.ModConfig.Config.StringProperties
---@field maxLength integer

---@class ReGui.ModConfig.Config.SelectorProperties
---@field options string[]

---@class ReGui.ModConfig.Config.LabelProperties
---@field label string

---@class ReGui.ModConfig.Config
---@field identifier string
---@field name string?
---@field description string?
---@field type "Boolean"|"Number"|"String"|"Selector"|"Label"
---@field side "Left"|"Right"
---@field default boolean|number|string
---@field properties {number: ReGui.ModConfig.Config.NumberProperties?, string: ReGui.ModConfig.Config.StringProperties?, selector: ReGui.ModConfig.Config.SelectorProperties?, label: ReGui.ModConfig.Config.LabelProperties?}?

---@class ReGui.ModConfig
---@field version 1
---@field tabs table<string, ReGui.ModConfig.Config[]>

sm.regui.modconfig = sm.regui.modconfig or {}

local backend = sm.regui.modconfig.backend or {}
sm.regui.modconfig.backend = backend

backend.configurations = backend.configurations or {} ---@type {structure: ReGui.ModConfig, updatedData: table<string, string|number|boolean>, onConfigChangeCallback: function}[]
backend.modNameToTranslatorFunc = backend.modNameToTranslatorFunc or {} ---@type table<string, function>
backend.syncNeeded = false

---@param name string
---@param configInfo ReGui.ModConfig
---@param currentSettings table<string, boolean|number|integer|string>
---@param configChangeCallback function
function sm.regui.modconfig.createModConfiguration(name, configInfo, currentSettings, configChangeCallback)
    SandboxAssert(true)

    AssertArgument(name, 1, {"string"})
    AssertArgument(configInfo, 2, {"table"}, {"ReGuiModConfig"})
    AssertArgument(currentSettings, 3, {"table"}, {"table<string, boolean|number|integer|string>"})
    AssertArgument(configChangeCallback, 4, {"function"})

    ValueAssert(backend.configurations[name] == nil, 1, "Mod configuration already exists!")

    AssertArgumentCustomErrMsg(configInfo.version, 2, {"integer"}, "Expected integer for configInfo.version, got " .. type(configInfo.version))
    ValueAssert(configInfo.version == 1, 2, "configInfo.version must be exactly 1, got " .. tostring(configInfo.version))

    AssertArgumentCustomErrMsg(configInfo.tabs, 2, {"table"}, "Expected table for configInfo.tabs, got " .. type(configInfo.tabs))

    local configurableTypes = { Boolean = true, Number = true, String = true, Selector = true }
    local displayOnlyTypes = { Label = true }

    local configTypeMap = {
        Boolean = "boolean",
        Number = "number",
        String = "string",
        Selector = "string"
    }

    local function assertUnusedProperties(config, ctx, allowedKey)
        for key, _ in pairs(config.properties or {}) do
            if key ~= allowedKey then
                ValueAssert(false, 2, ctx .. ".properties." .. key .. " must be nil for type '" .. config.type .. "'")
            end
        end
    end

    for tabName, configs in pairs(configInfo.tabs) do
        AssertArgumentCustomErrMsg(tabName, 2, {"string"}, "Expected string key in configInfo.tabs, got " .. type(tabName))
        AssertArgumentCustomErrMsg(configs, 2, {"table"}, "Expected array of config entries at configInfo.tabs[\"" .. tostring(tabName) .. "\"], got " .. type(configs))

        for i, config in pairs(configs) do
            AssertArgumentCustomErrMsg(i, 1, {"integer"}, string.format("configInfo.tabs[%q] index must be an integer, got %s", tabName, type(i)))

            local ctx = string.format("configInfo.tabs[%q][%d]", tabName, i)
            AssertArgumentCustomErrMsg(config, 2, {"table"},  ctx .. " must be ReGuiModConfig[], got " .. type(config))

            if config.type ~= "Label" then
                AssertArgumentCustomErrMsg(config.identifier, 2, {"string"}, ctx .. ".identifier must be a string, got " .. type(config.identifier))
                AssertArgumentCustomErrMsg(config.name, 2, {"string"}, ctx .. ".name must be a string, got " .. type(config.name))
                AssertArgumentCustomErrMsg(config.description, 2, {"string", "nil"}, ctx .. ".description must be a string if provided, got " .. type(config.description))
            else
                ValueAssert(config.identifier  == nil, 2, ctx .. ".identifier cannot be defined!")
                ValueAssert(config.name        == nil, 2, ctx .. ".name cannot be defined!")
                ValueAssert(config.description == nil, 2, ctx .. ".description cannot be defined!")
            end
            AssertArgumentCustomErrMsg(config.side, 2, {"string"}, ctx .. ".side must be a string, got " .. type(config.side))
            ValueAssert(config.side == "Left" or config.side == "Right" or config.side == "Center", 2, ctx .. ".side must be either \"Left\" or \"Right\", got " .. tostring(config.side))

            AssertArgumentCustomErrMsg(config.type, 2, {"string"}, ctx .. ".type must be a string, got " .. type(config.type))

            ValueAssert(configurableTypes[config.type] or displayOnlyTypes[config.type], 2, ctx .. ".type must be one of: Boolean, Number, String, Selector, Label. Got: " .. tostring(config.type))

            if config.type ~= "Label" then
                if config.default ~= nil then
                    ValueAssert(type(config.default) == configTypeMap[config.type], 2, ctx .. ".default must be of type " .. configTypeMap[config.type] .. ", got " .. type(config.default))
                end
            else
                ValueAssert(config.default == nil, 2, ctx .. ".default must be nil for type 'Label'")
            end

            if config.type == "Number" then
                local props = config.properties and config.properties.number
                AssertArgumentCustomErrMsg(props, 2, {"table"}, ctx .. ".properties.number must be a table, got " .. type(props))
                AssertArgumentCustomErrMsg(props.min, 2, {"number"}, ctx .. ".properties.number.min must be a number, got " .. type(props.min))
                AssertArgumentCustomErrMsg(props.max, 2, {"number"}, ctx .. ".properties.number.max must be a number, got " .. type(props.max))
                AssertArgumentCustomErrMsg(props.integerOnly, 2, {"boolean"}, ctx .. ".properties.number.integerOnly must be a boolean, got " .. type(props.integerOnly))
                ValueAssert(props.min <= props.max, 2, ctx .. ".properties.number.min must be <= max")

                assertUnusedProperties(config, ctx, "number")
            elseif config.type == "String" then
                local props = config.properties and config.properties.string
                AssertArgumentCustomErrMsg(props, 2, {"table"}, ctx .. ".properties.string must be a table, got " .. type(props))
                AssertArgumentCustomErrMsg(props.maxLength, 2, {"number"}, ctx .. ".properties.string.maxLength must be a number, got " .. type(props.maxLength))
                ValueAssert(props.maxLength >= 0, 2, ctx .. ".properties.string.maxLength must be >= 0")

                assertUnusedProperties(config, ctx, "string")
            elseif config.type == "Label" then
                local props = config.properties and config.properties.label
                AssertArgumentCustomErrMsg(props, 2, {"table"}, ctx .. ".properties.label must be a table, got " .. type(props))
                AssertArgumentCustomErrMsg(props.label, 2, {"string"}, ctx .. ".properties.label.label must be a string, got " .. type(props.label))

                assertUnusedProperties(config, ctx, "label")
            elseif config.type == "Selector" then
                local props = config.properties and config.properties.selector
                AssertArgumentCustomErrMsg(props, 2, {"table"}, ctx .. ".properties.selector must be a table, got " .. type(props))
                AssertArgumentCustomErrMsg(props.options, 2, {"table"}, ctx .. ".properties.selector.options must be a table, got " .. type(props.options))

                local hasAtLeastOne = false
                for i, v in pairs(props.options) do
                    AssertArgumentCustomErrMsg(i, 2, {"integer"}, ctx .. ".properties.selector.options's keys must be integers, got " .. type(i))
                    AssertArgumentCustomErrMsg(v, 2, {"string"}, ctx .. ".properties.selector.options[" .. i .. "] must be a string, got " .. type(v))
                    hasAtLeastOne = true
                end
                ValueAssert(hasAtLeastOne, 2, ctx .. ".properties.selector.options must contain at least one string")

                assertUnusedProperties(config, ctx, "selector")
            elseif config.type == "Boolean" then
                ValueAssert(config.properties == nil, 2, ctx .. ".properties must be nil for type 'Boolean'")
            end
        end
    end

    for key, value in pairs(currentSettings) do
        AssertArgumentCustomErrMsg(key, 3, {"string"}, "currentSettings must be a table with string keys, got key of type " .. type(key))
        local valType = type(value)
        ValueAssert(valType == "string" or valType == "number" or valType == "boolean", 3, "currentSettings[\"" .. key .. "\"] must be string, number, or boolean, got " .. valType)
    end

    backend.configurations[name] = {
        structure = configInfo,
        updatedData = currentSettings,
        onConfigChangeCallback = configChangeCallback,
    }

    backend.syncNeeded = true
end

function sm.regui.modconfig.setTranslationFunction(name, func)
    SandboxAssert(false)

    AssertArgument(name, 1, {"string"})
    AssertArgument(func, 2, {"function", "nil"})

    backend.modNameToTranslatorFunc[name] = func
end

print("Loaded ModConfig/API")
