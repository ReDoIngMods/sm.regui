function GenerateHashedString(str)
    local hash = 0
    for index = 1, #str do
        hash = bit.band(hash * 31 + string.byte(str, index), 0xFFFFFFFF)
    end

    if hash < 0 then
        hash = hash + 2^32
    end
    
    return string.format("%08x", hash)
end

print("Loaded Helper/StringHash.lua")