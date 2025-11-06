dofile("./TablePointer.lua")
dofile("./RangeTableIterator.lua")

---@class ModConfigToolClass : ToolClass
ModConfigToolClass = class()

-- SERVER --

function ModConfigToolClass:server_onCreate()
    sm.regui.modconfig.backend.toolInstance = self.tool
    sm.regui.modconfig.backend.syncNeeded = true

    self.sv = {}
end

function ModConfigToolClass:server_onFixedUpdate()
    if sm.regui.modconfig.backend.syncNeeded then
        sm.regui.modconfig.backend.syncNeeded = false
        
        local packetData = {}
        for name, config in pairs(sm.regui.modconfig.backend.configurations) do
            packetData[name] = {
                structure = config.structure,
                updatedData = config.updatedData
            }
        end

        self.network:sendToClients("cl_onClientSync", packetData)
    end
end

function ModConfigToolClass:server_onRefresh()
    self:server_onCreate()
end

-- CLIENT --

function ModConfigToolClass:client_onCreate()
    sm.regui.modconfig.backend.toolInstance = self.tool

    self.cl = {}
    self.cl.fullscreenGui = sm.regui.fullscreen.createFullscreenGuiFromInterface(sm.regui.new("$CONTENT_DATA/Gui/Layouts/Options.relayout"), true, "Center")
    self.cl.gui = self.cl.fullscreenGui:getGui()

    self.cl.gui:setButtonCallback("ModLeftBtn", "cl_mod_updateAction")
    self.cl.gui:setButtonCallback("ModRightBtn", "cl_mod_updateAction")

    self.cl.gui:setButtonCallback("TabLeftBtn", "cl_tab_updateAction")
    self.cl.gui:setButtonCallback("TabRightBtn", "cl_tab_updateAction")
    
    self.cl.configs = {} ---@type table<string, {structure: ReGui.ModConfig, updatedData: table<string, string|number|boolean>}>

    self.cl.selectedModPointer = TablePointer.new()
    self.cl.selectedModPointer:setMode("clamp")
    
    self.cl.currentMod = nil ---@type {name: string, data: {structure: ReGui.ModConfig, updatedData: table<string, string|number|boolean>}}
    self.cl.currentModTranslator = nil

    self.cl.tabOffset = 1
    
    self.cl.currentTab = nil ---@type ReGui.ModConfig.Config[]
    self.cl.currentTabIndex = 1
end

function ModConfigToolClass:client_onOpen()
    if GetTableSize(self.cl.configs) == 0 then
        sm.gui.chatMessage("No configs found!")
        return
    end

    self:cl_mod_refreshCurrent()

    self.cl.fullscreenGui:update()
    self.cl.gui:open()
end

-- MOD RELATED SELECTION --

function ModConfigToolClass:cl_mod_updateAction(widgetName)
    local isLeft = widgetName == "ModLeftBtn"

    if isLeft then
        self.cl.selectedModPointer:prev()
    else
        self.cl.selectedModPointer:next()
    end

    self.cl.gui:close()
    self:client_onOpen()
end

function ModConfigToolClass:cl_mod_refreshCurrent()
    local name, data = self.cl.selectedModPointer:current()
    self.cl.currentModTranslator = sm.regui.modconfig.backend.modNameToTranslatorFunc[name] or function(...) return ... end
    self.cl.gui:setText("SelectedModName", name)

    self.cl.currentMod = {name = name, data = data}
    
    if name and data then
        self:cl_tabs_refresh()
    end
end

-- TAB RELATED SELECTION --

function ModConfigToolClass:cl_tabs_refresh()
    for relativeIndex, absoluteIndex, containsData, tabName, _ in RangeTableIterator(self.cl.currentMod.data.structure.tabs, self.cl.tabOffset, self.cl.tabOffset + 7) do
        local guiTabName = "Tab" .. relativeIndex
        
        self.cl.gui:setVisible(guiTabName, containsData)
        if containsData then
            self.cl.gui:setText(guiTabName, self.cl.currentModTranslator(tabName))
            self.cl.gui:setButtonState(guiTabName, self.cl.currentTabIndex == absoluteIndex)
        end
    end
end

function ModConfigToolClass:cl_tab_updateAction(widgetName)
    local oldTabOffset = self.cl.tabOffset
    local isLeft = widgetName == "TabLeftBtn"

    if isLeft then
        self.cl.tabOffset = self.cl.tabOffset - 8
    else
        self.cl.tabOffset = self.cl.tabOffset + 8
    end

    local tabs = self.cl.currentMod.data.structure.tabs
    local totalTabs = GetTableSize(tabs)

    local lastPageStart = math.max(1, math.floor((totalTabs - 1) / 8) * 8 + 1)
    self.cl.tabOffset = sm.util.clamp(self.cl.tabOffset, 1, lastPageStart)
    
    if oldTabOffset ~= self.cl.tabOffset then
        self:cl_tabs_refresh()
    end
end

function ModConfigToolClass:cl_onClientSync(mods)
    self.cl.configs = mods
    self.cl.selectedModPointer:setData(mods)

    self:cl_mod_refreshCurrent()
end

function ModConfigToolClass:client_onRefresh()
    self:client_onCreate()
end