dofile("API.lua")

local backend = sm.regui.modconfig.backend

if backend.cl_config_hook_command then
    return
end

backend.toolInstance = nil ---@type ToolClass?

function backend.cl_config_hook_command(toolSelf, event)
    sm.event.sendToTool(backend.toolInstance, event)
end

local configCommandNames = {
    "/config",
    "/configs",
    "/configurations",
    "/reconfig",
    "/reconfigs",
    "/reconfigurations",
}

local selectedCfgCmdName = configCommandNames[1]

local oldWorldEvent = sm.event.sendToWorld
sm.event.sendToWorld = function(world, callback, params)
    if not params then
        return oldWorldEvent(world, callback, params)
    end

    if params[1] == selectedCfgCmdName then
        if sm.isHost then
            sm.event.sendToTool(sm.regui.__getToolInstance().tool, "sv_config_hook_command", "client_onOpen")
        else
            sm.gui.chatMessage("Nuh uh!")
        end
    else
        return oldWorldEvent(world, callback, params)
    end
end

local commandBound = false
local alreadyBoundCommands = {}

local originalBindChatCommand = sm.game.bindChatCommand
sm.game.bindChatCommand = function(command, params, callback, help)
    if alreadyBoundCommands[command] then
        warn("[ModConfig] Skipping already registered command:", command)
        return
    end

    local success, errMsg = pcall(originalBindChatCommand, command, params, callback, help)
    if not success then
        warn("[ModConfig] First attempt to register command \"" .. command .. "\" failed. Retrying...")
        warn("[ModConfig] \t" .. errMsg)
        success, errMsg = pcall(originalBindChatCommand, command, params, callback, help)
    end
    

    if not success then
        warn("[ModConfig] Failed to register command \"" .. command .. "\" after retrying.")
        warn("[ModConfig] This may be due to another or same mod registering the same command.")
        warn("[ModConfig] \t" .. errMsg)
        return
    end

    if not commandBound then
        commandBound = true

        local success = false
        for _, name in ipairs(configCommandNames) do
            local ok, err = pcall(originalBindChatCommand, name, {}, "cl_onChatCommand", "Opens configurations for mods")
            print("[ModConfig] Trying command:", name, ok, err or "No error")
            if ok then
                selectedCfgCmdName = name
                alreadyBoundCommands[name] = true
                success = true
                break
            end
        end

        if not success then
            sm.gui.chatMessage("#AA0000[ModConfig] Failed to register config command! You will NOT be able to set configurations for some mods!")
        else
            print("[ModConfig] Registered config command as:", selectedCfgCmdName)
        end
    end

    alreadyBoundCommands[command] = true
end

print("Loaded ModConfig/Hook")
