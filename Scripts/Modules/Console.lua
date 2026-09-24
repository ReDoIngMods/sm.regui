local banner = [[
 ________  _____ ______       ________  _______   ________  ___  ___  ___     
|\   ____\|\   _ \  _   \    |\   __  \|\  ___ \ |\   ____\|\  \|\  \|\  \    
\ \  \___|\ \  \\\__\ \  \   \ \  \|\  \ \   __/|\ \  \___|\ \  \\\  \ \  \   
 \ \_____  \ \  \\|__| \  \   \ \   _  _\ \  \_|/_\ \  \  __\ \  \\\  \ \  \  
  \|____|\  \ \  \    \ \  \ __\ \  \\  \\ \  \_|\ \ \  \|\  \ \  \\\  \ \  \ 
    ____\_\  \ \__\    \ \__\\__\ \__\\ _\\ \_______\ \_______\ \_______\ \__\
   |\_________\|__|     \|__\|__|\|__|\|__|\|_______|\|_______|\|_______|\|__|
   \|_________|          Remaking MyGui in MyGui, while being better
]]

local sm_log_info = sm.log.info
local sm_log_warning = sm.log.warning
local sm_log_error = sm.log.error

local table_concat = table.concat

local function parseVariadicArguments(...)
    return table_concat({...}, "\t", 1, select("#", ...))
end

if reguieditor then
    for line in banner:gmatch("[^\n]+") do
        sm.log.info(line)
    end

    print = function(...)
        sm_log_info("[ReGui] INFO:", parseVariadicArguments(...))
    end

    warn = function(...)
        sm_log_warning("[ReGui] WARNING:", parseVariadicArguments(...))
    end

    oldError = oldError or error
    error = function(...)
        sm_log_error("[ReGui] ERROR:", select(1, ...))
        oldError(...)
    end

    oldAssert = oldAssert or assert
    assert = function(condition, ...)
        if not condition then
            local message = select(1, ...) or "Assertion failed!"

            sm_log_error("[ReGui] ASSERT:", message)
            oldError(message, 2)
        end
    end
else
    for line in banner:gmatch("[^\n]+") do
        sm.log.error("\b\b\b\b\b\b\b[ReGui]", line)
    end

    print = function(...)
        sm_log_info("[ReGui] INFO:", parseVariadicArguments(...))
    end

    warn = function(...)
        sm_log_warning("\b\b\b\b\b\b\b\b\b[ReGui] WARNING:", parseVariadicArguments(...))
    end

    oldError = oldError or error
    error = function(...)
        sm_log_error("\b\b\b\b\b\b\b[ReGui] ERROR:", select(1, ...))
        oldError(...)
    end

    oldAssert = oldAssert or assert
    assert = function(condition, ...)
        if not condition then
            local message = select(1, ...) or "Assertion failed!"

            sm_log_error("\b\b\b\b\b\b\b[ReGui] ASSERT:", message)
            oldError(message, 2)
        end
    end
end

print("Initialized ReGui Console")