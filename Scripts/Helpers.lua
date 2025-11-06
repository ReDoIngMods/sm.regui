function GetTableSize(tbl)
    local size = 0
    for _, _ in pairs(tbl) do
        size = size + 1
    end

    return size
end

function CloneTable(tbl)
    local sharedReferences = {}
    local function cloneInternal(original)
        if type(original) ~= "table" then
            return original
        end

        if sharedReferences[original] then
            return sharedReferences[original]
        end

        local copy = {}
        sharedReferences[original] = copy

        for key, value in pairs(original) do
            copy[cloneInternal(key)] = cloneInternal(value)
        end

        return copy
    end

    return cloneInternal(tbl)
end

function PredictablePairs(tbl)
    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end

    table.sort(keys, function(a, b)
        return tostring(a) < tostring(b)
    end)

    local i = 0
    return function()
        i = i + 1
        local key = keys[i]
        if key ~= nil then
            return key, tbl[key]
        end
    end
end

function GetMyGuiScreenSize()
    local screenWidth, screenHeight = sm.gui.getScreenSize()

    -- 720p, 1080p, 1440p, 4k

    if screenWidth >= 3840 and screenHeight >= 2160 then
        return 3840, 2160 -- 4K
    elseif screenWidth >= 2560 and screenHeight >= 1440 then
        return 2560, 1440 -- 1440p
    elseif screenWidth >= 1920 and screenHeight >= 1080 then
        return 1920, 1080 -- 1080p
    else
        return 1280, 720 -- 720p
    end
end

function TablePack(...)
    return {
        __n = select("#", ...),
        ...
    }
end

function TableMove(src, first, last, offset, dst)
    for i = 0, last - first do
        dst[offset + i] = src[first + i]
    end
end

function TableRepack(...)
    local packed = TablePack(...)
    local result = {}
    TableMove(packed, 1, packed.__n, 1, result)
    return result
end

function ParseLayoutToValidJsonXML(xmlString)
    xmlString = xmlString:gsub("'", "&apos;") --Escape ' with &apos;, as we have to replace " with ' to make the Json serializer not escape them
    xmlString = xmlString:gsub('"', "'") --Replace remaining " with ', to make the Json serializer not escape them, keeping it valid XML
    xmlString = "\""..xmlString --Deal with the first ", making it valid but ignored
    xmlString = xmlString.."<!--" --Deal with the last ", commenting it out
    return xmlString
end

print("Loaded Helpers!")