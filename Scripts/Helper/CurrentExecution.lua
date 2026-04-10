function GetCurrentlyExecutingModUUID()
    local success, result = pcall(sm.json.open, "$CONTENT_DATA/description.json")
    if not success then
        return sm.uuid.getNil()
    end
    
    return sm.uuid.new(result.localId)
end

function IsCurrentlyExecutingModReGui()
    local success, result = pcall(sm.json.open, "$CONTENT_DATA/description.json")
    if not success then
        return false
    end

    return result.localId == "3f08fc72-fef1-4bd4-9809-a04612d2e847"
end

print("Loaded Helper/CurrentExecution.lua")