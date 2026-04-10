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

storage = storage or  {}

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
    sm.json.save(data, filePath)

    local executingModUuid = tostring(GetCurrentlyExecutingModUUID())
    storage[executingModUuid] = storage[executingModUuid] or {}

    local resolvedPath = ResolveContentPath(filePath)
    storage[executingModUuid][resolvedPath] = tostring(os.time())

    WriteStorage(storage)
end

function sm.regui.cache.generateCachePath(hash)
    return "$CONTENT_" .. tostring(GetCurrentlyExecutingModUUID()) .. "/ReGuiCache/cache_" .. hash .. ".layout"
end

print("Loaded Cache/CacheManager.lua")