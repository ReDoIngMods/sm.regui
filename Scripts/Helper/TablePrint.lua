function PrintTable(tbl)
    if not next(tbl) then
        print("{}")
        return
    end

    local function iterator(value, indentation)
        local indentText = string.rep("    ", indentation)
        
        local isArray = IsTableArray(value)
        local tableSize = GetTableSize(value)

        local virtualIndex = 0

        for index, value in PredictablePairs(value) do
            virtualIndex = virtualIndex + 1
            
            local isLast = (virtualIndex == tableSize)
            local comma = isLast and "" or ","

            local keyText = ""
            if not isArray then
                if type(index) == "string" then
                    local needsEscaped = false
                    if not string.match(index, "^[%a_][%w_]*$") then
                        needsEscaped = true
                    end

                    if string.match(index, "^%s*$") then
                        needsEscaped = true
                    end
                    
                    if needsEscaped then
                        keyText = string.format("[%q]", index) .. " = "
                    else
                        keyText = index .. " = "
                    end
                else
                    keyText = string.format("[%s]", tostring(index)) .. " = "
                end
            end

            if type(value) == "table" then
                if not next(value) then
                    print(indentText .. keyText .. "{}" .. comma)
                else
                    print(indentText .. keyText .. "{")
                    iterator(value, indentation + 1)
                    print(indentText .. "}" .. comma)
                end
            elseif type(value) == "string" then
                print(indentText .. keyText .. string.format("%q", value) .. comma)
            elseif type(value) == "number" or type(value) == "boolean" then
                print(indentText .. keyText .. tostring(value) .. comma)
            else
                print(indentText .. keyText .. string.format("<%s>", type(value)) .. comma)
            end
        end
    end
    
    print("{")
    iterator(tbl, 1)
    print("}")
end

print("Loaded Helper/TablePrint.lua")