TablePointer = {}

---@return self
function TablePointer.new()
    local self = {}
    self.data = {}
    self.dataSize = 0
    self.ptr = 1
    self.keys = {}
    self.step = 1 -- default increment/decrement step size
    self.mode = "clamp" -- "clamp" or "block"

    for key, value in pairs(TablePointer) do
        if type(value) == "function" and key ~= "new" then
            self[key] = value
        end
    end

    return self
end

---@param data table
function TablePointer:setData(data)
    self.data = data
    self.dataSize = GetTableSize(data)

    self.keys = {}
    for key in pairs(data) do
        table.insert(self.keys, key)
    end
    table.sort(self.keys)

    self.ptr = 1
end

---@param step integer
function TablePointer:setStep(step)
    AssertArgument(step, 1, {"integer"})
    ValueAssert(step > 0, 1, "Negative step's are not allowed!")

    self.step = step
end

---@param mode '"clamp"' | '"block"'
function TablePointer:setMode(mode)
    AssertArgument(mode, 1, {"string"})
    ValueAssert(mode == "clamp" or mode == "block", 1, "Invalid mode!")

    self.mode = mode
end

---@return table
function TablePointer:getData()
    return self.data
end

---Move pointer right
function TablePointer:next()
    if self.dataSize == 0 then return end

    local newPtr = self.ptr + self.step
    if newPtr > self.dataSize then
        if self.mode == "clamp" then
            newPtr = self.dataSize
        elseif self.mode == "block" then
            return
        end
    end
    self.ptr = newPtr
end

---Move pointer left
function TablePointer:prev()
    if self.dataSize == 0 then return end

    local newPtr = self.ptr - self.step
    if newPtr < 1 then
        if self.mode == "clamp" then
            newPtr = 1
        elseif self.mode == "block" then
            return
        end
    end
    self.ptr = newPtr
end

---Get current key and value
---@return any key, any value
function TablePointer:current()
    if self.dataSize == 0 then
        return nil, nil
    end

    local key = self.keys[self.ptr]
    return key, self.data[key]
end
