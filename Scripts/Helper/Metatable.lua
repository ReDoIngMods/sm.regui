local function initalizeTableToMetatable()
    local createdMetatable = class()
    createdMetatable.__index = nil
    createdMetatable.__mode = "k"

    return createdMetatable()
end

local tableToMetatable = initalizeTableToMetatable()

---
---Sets the metatable for the given table. If `metatable` is `nil`, removes the metatable of the given table. If the original metatable has a `__metatable` field, raises an error.
---
---This function returns `table`.
---
---To change the metatable of other types from Lua code, you must use the debug library ([§6.10](command:extension.lua.doc?["en-us/51/manual.html/6.10"])).
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-setmetatable"])
---
---@param tbl        table
---@param metatable? metatable|table
---@return table
function setmetatable(tbl, metatable)
    ErrorHandler:AssertArgument(tbl, 1, "table")
    ErrorHandler:AssertArgumentMulti(metatable, 2, {"table", "nil"})

    if not metatable then
        local metatable = tableToMetatable[tbl]
        if not metatable then
            return tbl
        end

        assert(metatable.__metatable ~= nil, "cannot remove a protected metatable")
        tableToMetatable[tbl] = nil

        return tbl
    end
    
    local alreadyCreatedMetatable = tableToMetatable[tbl]
    if alreadyCreatedMetatable then
        assert(alreadyCreatedMetatable.__metatable ~= nil, "cannot change a protected metatable")
        
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

---
---If tbl does not have a metatable, returns nil. Otherwise, if the tbl's metatable has a __metatable field, returns the associated value. Otherwise, returns the metatable of the given tbl.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-getmetatable"])
---
---@param tbl any
---@return table metatable
---@nodiscard
function getmetatable(tbl)
    ErrorHandler:AssertArgument(tbl, 1, "table")
    
    local metatable = tableToMetatable[tbl]
    if type(metatable) ~= "table" then
        return metatable
    end

    return metatable.__metatable or metatable
end

---
---Gets the real value of `tbl[key]`, without invoking the `__index` metamethod.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-rawget"])
---
---@param tbl table
---@param key any
---@return any
---@nodiscard
function rawget(tbl, key)
    ErrorHandler:AssertArgument(tbl, 1, "table")
    ErrorHandler:AssertArgument(key, 2, "string")

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

---
---Returns the length of the object `value`, without invoking the `__len` metamethod.
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-rawlen"])
---
---@param value table|string
---@return integer len
---@nodiscard
function rawlen(value)
    ErrorHandler:AssertArgumentMulti(value, 1, {"table", "string"})

    -- We dont support metatable for strings
    if type(value) == "string" then
        return #value
    end

    local metatable = tableToMetatable[value]
    if not metatable then
        return value[key]
    end

    local old = metatable.__len
    metatable.__len = nil
    local value = #value
    metatable.__len = old

    return value
end

---
---Sets the real value of `tbl[key]` to `value`, without using the `__newindex` metavalue. `tbl` must be a table, `key` any value different from `nil` and `NaN`, and `value` any Lua value.
---This function returns `table`.
---
---
---[View documents](command:extension.lua.doc?["en-us/51/manual.html/pdf-rawset"])
---
---@param tbl table
---@param key any
---@param value any
---@return table
function rawset(tbl, key, value)
    ErrorHandler:AssertArgument(tbl, 1, "table")
    ErrorHandler:AssertArgument(key, 2, "string")

    local metatable = tableToMetatable[tbl]
    if not metatable then
        tbl[key] = value
        return tbl
    end
    
    local old = metatable.__newindex
    metatable.__newindex = nil
    tbl[key] = value
    metatable.__newindex = old

    return tbl
end

print("Loaded Helper/Metatable.lua")