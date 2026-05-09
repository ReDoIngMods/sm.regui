-- TODO: TempData DLL Mod support

local storageFilePath = "$CONTENT_DATA/regui_cache.json"
local storage = nil

if sm.json.fileExists(storageFilePath) then
    local success, result = pcall(sm.json.open, storageFilePath)
    if success then
        storage = result
    else
        sm.log.error(result)
        sm.json.save({}, storageFilePath)
    end
else
    sm.json.save({}, storageFilePath)
end

storage = storage or {}

do
    -- Clear any files that dont exist
    local needsUpdate = false
    for modUuid, files in pairs(storage) do
        for filePath, time in pairs(files) do
            -- if not sm.json.fileExists(filePath) then
            --     storage[modUuid][filePath] = nil
            --     needsUpdate = true
            -- end
            local success, result = pcall(sm.json.open, filePath)
            if not success then
                -- Assume this is deleted
                warn("File not found or inaccessible, assumed to be deleted: " .. filePath)
                
                storage[modUuid][filePath] = nil
                needsUpdate = true
            else
                local oldTime = tonumber(time)
                local timeDistance = os.time() - oldTime

                -- Check if more than 24h, if so then this file can be deleted.
                if timeDistance > 24 * 3600 then
                    sm.json.save(0, filePath)

                    storage[modUuid][filePath] = nil
                    needsUpdate = true
                end
            end
        end

        if not next(storage[modUuid]) then
            storage[modUuid] = nil
            needsUpdate = true
        end
    end

    if needsUpdate then
        sm.json.save(storage, storageFilePath)
    end
end

local function WriteStorage(newStorage)
    if IsCurrentlyExecutingModReGui() then
        sm.json.save(storageFilePath, newStorage)
        return
    end
    
    ExecuteCodeAsReGui("sm.regui.internal.cache.writeStorage", newStorage)
end

sm.regui.cache = {}

sm.regui.internal.cache = {}

function sm.regui.internal.cache.writeStorage(newStorage)
    sm.json.save(newStorage, storageFilePath)
end

function sm.regui.cache.writeCachedFile(filePath, data)
    if sm.json.fileExists(filePath) then
        local success, result = pcall(sm.json.open, filePath)
        if not success or result == 0 then
            -- Either this file was cached but got cleared because the user was in their game for more than 24h without
            -- the Temp Data DLL mod OR it got corrupted.

            sm.json.save(data, filePath)
        end
    else
        sm.json.save(data, filePath)
    end

    local executingModUuid = tostring(GetCurrentlyExecutingModUUID())
    storage[executingModUuid] = storage[executingModUuid] or {}

    local resolvedPath = ResolveContentPath(filePath)
    storage[executingModUuid][resolvedPath] = tostring(os.time())

    WriteStorage(storage)
end

function sm.regui.cache.generateCachePath(hash)
    if sm.modTempDataSupport_installed then
        return "$TEMP_DATA/regui_cache_" .. hash .. ".layout"
    end

    return "$CONTENT_" .. tostring(GetCurrentlyExecutingModUUID()) .. "/ReGuiCache/regui_cache_" .. hash .. ".layout"
end

print("Loaded Cache/CacheManager.lua")