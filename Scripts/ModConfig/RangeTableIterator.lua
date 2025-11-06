function RangeTableIterator(tbl, indexStart, indexEnd)
    local keys = {}
    for key, _ in PredictablePairs(tbl) do
        table.insert(keys, key)
    end

    local totalKeys = #keys
    local currentIndex = indexStart - 1

    local function iterator()
        currentIndex = currentIndex + 1

        if currentIndex > indexEnd then
            return nil
        end

        local key = keys[currentIndex]
        local relativeIndex = currentIndex - indexStart + 1
        local absoluteIndex = currentIndex

        if not key then
            return relativeIndex, absoluteIndex, false, nil, nil
        end

        local value = tbl[key]
        return relativeIndex, absoluteIndex, true, key, value
    end

    return iterator
end
