---@param instance ReGui.GUI
---@return string
function CreateHashFromGuiInstance(instance)
    local function serialize(tbl)
        local keys, str = {}, "{"
        for k in pairs(tbl) do
            table.insert(keys, k)
        end

        table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

        for _, k in ipairs(keys) do
            local v = tbl[k]
            local function valToStr(val)
                if type(val) == "table" then
                    return serialize(val)
                elseif type(val) == "string" then
                    return string.format("%q", val)
                else
                    return tostring(val)
                end
            end

            str = str .. "[" .. valToStr(k) .. "]=" .. valToStr(v) .. ","
        end
        return str .. "}"
    end

    local function fnv1a64(str)
        local hash = { 0x84222325, 0xcbf29ce4 }
        for i = 1, #str do
            local byte = string.byte(str, i)
            hash = { bit.bxor(hash[1], byte), hash[2] }

            local a_lo, a_hi = hash[1], hash[2]
            local b_lo, b_hi = 0x1b3, 0x100
            local lo_lo = bit.band(a_lo * b_lo, 0xFFFFFFFF)
            local hi_lo = bit.band(a_hi * b_lo + a_lo * b_hi, 0xFFFFFFFF)
            local hi_hi = bit.band(a_hi * b_hi, 0xFFFFFFFF)
            local mid = bit.rshift(a_lo * b_lo, 32) + bit.band(hi_lo, 0xFFFFFFFF)

            hash = {
                bit.band(lo_lo, 0xFFFFFFFF),
                bit.band(mid + hi_hi, 0xFFFFFFFF)
            }
        end

        return hash
    end

    local function toHex64(v)
        return string.format("%08x%08x", v[2], v[1])
    end

    local h1 = fnv1a64(serialize(instance.data))
    local h2 = fnv1a64(serialize(instance.modifiers))

    local lo = (h1[1] + h2[1]) % 2^32
    local carry = math.floor((h1[1] + h2[1]) / 2^32)
    local hi = (h1[2] + h2[2] + carry) % 2^32

    return toHex64({ lo, hi })
end