local function initalizeTableToMetatable()
    local createdMetatable = class()
    createdMetatable.__index = nil
    createdMetatable.__mode = "k"

    return createdMetatable()
end

local tableToMetatable = initalizeTableToMetatable()
function setmetatable(tbl, metatable)
    if not metatable then
        removemetatable(tbl)
        return tbl
    end
    
    local alreadyCreatedMetatable = tableToMetatable[tbl]
    if alreadyCreatedMetatable then
        assert(alreadyCreatedMetatable.__metatable ~= "locked", "cannot change a protected metatable")
        
        for key, _ in pairs(alreadyCreatedMetatable) do
            alreadyCreatedMetatable[key] = nil
        end
        
        for key, value in pairs(metatable) do
            alreadyCreatedMetatable[key] = value
        end
        
        return tbl
    end
    
    local createdMetatable = class(metatable)
    createdMetatable.__index = metatable.__index
    
    local output = createdMetatable()
    tableToMetatable[output] = createdMetatable
    
    local old = createdMetatable.__newindex
    createdMetatable.__newindex = nil
    for key, value in pairs(tbl) do
        output[key] = value
    end
    createdMetatable.__newindex = old
    return output
end

function getmetatable(tbl)
    local metatable = tableToMetatable[tbl]
    if type(metatable) ~= "table" then
        return metatable
    end

    return metatable.__metatable or metatable
end

function rawset(tbl, key, value)
    local metatable = tableToMetatable[tbl]
    if not metatable then
        tbl[key] = value
        return
    end
    
    local old = metatable.__newindex
    metatable.__newindex = nil
    tbl[key] = value
    metatable.__newindex = old
end

function rawget(tbl, key)
    local metatable = tableToMetatable[tbl]
    if not metatable then
        return tbl[key]
    end

    local old = metatable.__index
    metatable.__index = nil
    local value = tbl[key]
    metatable.__index = old

    return value
end

function removemetatable(tbl)
    local metatable = tableToMetatable[tbl]
    if not metatable then return end

    assert(metatable.__metatable ~= "locked", "cannot remove a protected metatable")
    tableToMetatable[tbl] = nil
end

print("Loaded Helper/Metatable.lua")