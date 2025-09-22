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
---@field name string
---@field description string?
---@field type "Boolean"|"Number"|"String"|"Selector"|"Label"
---@field side "Left"|"Right"
---@field default boolean|number|string
---@field properties {number: ReGui.ModConfig.Config.NumberProperties?, string: ReGui.ModConfig.Config.StringProperties?, selector: ReGui.ModConfig.Config.SelectorProperties?, label: ReGui.ModConfig.Config.LabelProperties}?

---@class ReGui.ModConfig
---@field version 1
---@field tabs table<string, ReGui.ModConfig.Config[]>

---@class ModConfigToolClass : ToolClass
ModConfigToolClass = class()

-- SERVER --

function ModConfigToolClass:server_onCreate()
    sm.regui.modconfig.backend.toolInstance = self.tool

    self.sv = {}
end

function ModConfigToolClass:sv_requestSync(_, player)
    self.network:sendToClient(player, "cl_syncClient", {
        configurations = sm.regui.modconfig.backend.configurations,
        configurationsData = sm.regui.modconfig.backend.configurationsData,
    })
end

function ModConfigToolClass:server_onRefresh()
    self:server_onCreate()
end

-- CLIENT --

function ModConfigToolClass:client_onCreate()
    sm.regui.modconfig.backend.toolInstance = self.tool

    self.cl = {}
    self.cl.data = {} ---@type {configurations: table<string, ReGui.ModConfig>, configurationsData: table<string, boolean|number|string>}}
    self.cl.openGuiOnSync = false

    self.cl.guiTemplate = sm.regui.new("$CONTENT_DATA/Gui/Layouts/Options.relayout")
    self.cl.guiTemplate:setSettings({ backgroundAlpha = 0.5 })

    self.cl.guiTemplate:setButtonCallback("ModLeftBtn" , "cl_onModChange")
    self.cl.guiTemplate:setButtonCallback("ModRightBtn", "cl_onModChange")

    self.cl.guiTemplate:setButtonCallback("TabLeftBtn" , "cl_onTabChange")
    self.cl.guiTemplate:setButtonCallback("TabRightBtn", "cl_onTabChange")

    for i = 1, 8, 1 do
        self.cl.guiTemplate:setButtonCallback("Tab" .. i, "cl_onSelectedTabChange")
    end

    self.cl.selectedMod = {
        index = 0,
        value = "NaN",
    }

    self.cl.selectedTab = {
        index =  1,
        offset = 0
    }

    self.network:sendToServer("sv_requestSync")
end

function ModConfigToolClass:client_onOpen()
    self.network:sendToServer("sv_requestSync")
    self.cl.openGuiOnSync = true

    self:cl_changeSelectedTab(1)
end

function ModConfigToolClass:cl_syncClient(data)
    self.cl.data = data

    if self.cl.openGuiOnSync then
        self:cl_openGui()
        self.cl.openGuiOnSync = false
    end
end

function ModConfigToolClass:cl_openGui()
    if GetTableSize(self.cl.data.configurations) == 0 then
        sm.gui.chatMessage("No mod configurations avaliable.")
        return
    end

    if self.cl.selectedMod.index == 0 then
        self.cl.selectedMod.index = 2
        self:cl_changeMod(true)
    end

    self:cl_refreshTabs()

    local fullscreenGui = sm.regui.fullscreen.createFullscreenGuiFromInterface(self.cl.guiTemplate:clone(), true, "Center")
    fullscreenGui:update()

    local cloneGui = fullscreenGui:getGui()
    local currentTab = self:cl_getCurrentTab()

    local function loadConfigs(side)
        local optionsHostPanel = cloneGui:findWidgetRecursive("OptionsHostPanel")
        local widgetSide = optionsHostPanel:findWidget(side)

        local filteredConfigs = {} ---@type ReGui.ModConfig.Config[]
        for _, config in pairs(currentTab) do
            if config.side == side then
                table.insert(filteredConfigs, config)
            end
        end

        if #filteredConfigs == 0 then
            return
        end

        local flexWidget = sm.regui.flex.createFlexWidget(widgetSide, "Start", "Vertical")
        flexWidget:setGapPixels(14)
        for _, config in pairs(filteredConfigs) do
            local configWidget = widgetSide:createWidget("MyWidget", "Widget", "PanelEmpty")
            configWidget:setSizeRealUnits({1, .05})

            local gui = nil ---@type ReGuiInterface
            if config.type == "Label" then
                gui = sm.regui.new("$CONTENT_DATA/Gui/Layouts/Ported/OptionsItem_Label.relayout")
                local name = gui:findWidgetRecursive("Name"):setText(self:cl_getTranslatorFunc()(config.properties.label.label))
            end

            for _, value in pairs(gui:getRootChildren()) do
                value:setParent(configWidget)
            end

            flexWidget:pushWidget(configWidget)
        end

        flexWidget:update()
    end

    loadConfigs("Left")
    loadConfigs("Right")
    
    cloneGui:open()
end

function ModConfigToolClass:cl_onModChange(widgetName)
    if self:cl_changeMod(widgetName == "ModLeftBtn") then
        self:cl_openGui()
    end
end

function ModConfigToolClass:cl_onTabChange(widgetName)
    if self:cl_changeTabOffset(widgetName == "TabLeftBtn") then
        self:cl_openGui()
    end
end

function ModConfigToolClass:cl_changeMod(isLeft)
    local index = sm.util.clamp(self.cl.selectedMod.index + (isLeft and -1 or 1), 1, GetTableSize(self.cl.data.configurations))
    if index == self.cl.selectedMod.index then
        return false
    end

    local modName = nil

    local modNameIteratorIndex = 0
    for modNameIterator, _ in predictablePairs(self.cl.data.configurations) do
        modNameIteratorIndex = modNameIteratorIndex + 1

        if modNameIteratorIndex == index then
            modName = modNameIterator
            break
        end
    end

    self.cl.selectedMod.index = index
    self.cl.selectedMod.value = modName
    self.cl.selectedTab.index = 1
    self.cl.selectedTab.offset = -1
    self:cl_changeSelectedTab(1)
    self:cl_changeTabOffset(true)
    self:cl_refreshTabs()

    self.cl.guiTemplate:setText("SelectedModName", self:cl_getTranslatorFunc()(modName))
    return true
end

function ModConfigToolClass:cl_getCurrentMod()
    return self.cl.data.configurations[self.cl.selectedMod.value]
end

function ModConfigToolClass:cl_getCurrentTab()
    local indexToName = {}
    for key, _ in predictablePairs(self:cl_getCurrentMod().tabs) do
        table.insert(indexToName, key)
    end

    return self:cl_getCurrentMod().tabs[indexToName[self.cl.selectedTab.index]]
end

function ModConfigToolClass:cl_getTranslatorFunc()
    local modName = self.cl.selectedMod.value
    local func = sm.regui.modconfig.backend.modNameToTranslatorFunc[modName]

    if type(func) ~= "function" then
        func = function(text) return text end
    end

    return function(text)
        return ({func(text):gsub("#", "##")})[1]
    end
end

function ModConfigToolClass:cl_changeTabOffset(isLeft)
    local currentMod = self:cl_getCurrentMod()
    local newOffset = sm.util.clamp(self.cl.selectedTab.offset + (isLeft and -8 or 8), 0, ((math.ceil(GetTableSize(currentMod.tabs) / 8) - 1) * 8))
    
    if newOffset == self.cl.selectedTab.offset then
        return false
    end

    self.cl.selectedTab.offset = newOffset
    self:cl_refreshTabs()
    return true
end

function ModConfigToolClass:cl_refreshTabs()
    local currentMod = self:cl_getCurrentMod()
    local translatorFunction = self:cl_getTranslatorFunc()

    local indexToName = {}
    for key, _ in predictablePairs(currentMod.tabs) do
        table.insert(indexToName, key)
    end

    for i = 1, 8, 1 do
        local currentTabIndex = i + self.cl.selectedTab.offset
        local name = indexToName[currentTabIndex]

        self.cl.guiTemplate:setVisible("Tab" .. i, name ~= nil)
        self.cl.guiTemplate:setButtonState("Tab" .. i, currentTabIndex == self.cl.selectedTab.index)
        
        if name then
            self.cl.guiTemplate:setText("Tab" .. i, translatorFunction(name))
        end
    end
end

function ModConfigToolClass:cl_onSelectedTabChange(widgetName)
    if self:cl_changeSelectedTab(tonumber(widgetName:sub(4))) then
        self:cl_openGui()
    end
end

function ModConfigToolClass:cl_changeSelectedTab(tabIndex)
    if self.cl.selectedTab.index == tabIndex then
        return false
    end

    self.cl.selectedTab.index = tabIndex + self.cl.selectedTab.offset
    return true
end

function ModConfigToolClass:client_onRefresh()
    self:client_onCreate()
end