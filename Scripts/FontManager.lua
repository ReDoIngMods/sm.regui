---@class ReGui.Font.File
---@field metadata ReGui.Font.File.Metadata
---@field glyphs table<integer, ReGui.Font.File.Glyph>

---@class ReGui.Font.File.Metadata
---@field fontSize number
---@field rotations number[]
---@field cellSize number
---@field lineHeight number
---@field fontSpacing number

---@class ReGui.Font.File.Glyph
---@field advanceWidth number
---@field rotations ReGui.Font.File.Glyph.Rotation[]

---@class ReGui.Font.File.Glyph.Rotation
---@field [1] number
---@field [2] number

local sm_json_open = sm.json.open
local string_format = string.format
local string_byte = string.byte
local string_sub = string.sub
local math_abs = math.abs
local math_rad = math.rad
local math_cos = math.cos
local math_sin = math.sin

sm.regui.font = {}

local function getUTF8Character(str, index)
    local byte = string_byte(str, index)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string_sub(str, index, index + byteCount - 1)
end

local function parseTextForColoring(text)
    local outputText = ""

    local indexColorChange = {}

    local colorMode = false
    local colorText = ""

    local appliedColors = 0
    local reducedOffset = 0

    local index = 1
    while index <= #text do
        local character = getUTF8Character(text, index)

        if colorMode then
            colorText = colorText .. character

            if #colorText == 6 then
                colorMode = false
                appliedColors = appliedColors + 1

                indexColorChange[index - (7 * appliedColors) + 1 - reducedOffset] = colorText
                colorText = ""
            end
        else
            if character == "#" then
                if getUTF8Character(text, index + #character) == "#" then
                    outputText = outputText .. "#"
                    index = index + 1
                    reducedOffset = reducedOffset + 1
                else
                    colorMode = true
                    colorText = ""
                end
            else
                outputText = outputText .. character
            end
        end

        index = index + #character
    end

    return outputText, indexColorChange
end

local function getClosestNumber(tbl, input)
    local closest = tbl[1]
    local closestIndex = 1
    local minDiff = math_abs(input - closest)

    for i = 2, #tbl do
        local diff = math_abs(input - tbl[i])
        if diff < minDiff then
            minDiff = diff
            closest = tbl[i]
            closestIndex = i
        end
    end

    return closest, closestIndex
end

local function rotatePoint(cx, cy, x, y, angle)
    local rad = math_rad(angle)
    local cosA = math_cos(rad)
    local sinA = math_sin(rad)

    local dx = x - cx
    local dy = y - cy

    local rx = dx * cosA - dy * sinA
    local ry = dx * sinA + dy * cosA

    return cx + rx, cy + ry
end

local function hexToMyGuiColor(hex)
    if string_sub(hex, 1, 1) == "#" then
        hex = string_sub(hex, 2)
    end
    
    local r = tonumber(string_sub(hex, 1, 2), 16)
    local g = tonumber(string_sub(hex, 3, 4), 16)
    local b = tonumber(string_sub(hex, 5, 6), 16)
    
    r = r / 255
    g = g / 255
    b = b / 255
    
    return string_format("%.3f %.3f %.3f 1", r, g, b)
end

local cachedFonts = {} ---@type table<string, ReGui.Font.File>
local fontNameToFontPath = {} ---@type table<string, string>

---@param fontName string
---@param fontPath string
function sm.regui.font.addFont(fontName, fontPath)
    AssertArgument(fontName, 1, {"string"})
    AssertArgument(fontPath, 2, {"string"})

    if fontPath:sub(#fontPath) == "/" then
        fontPath = fontPath:sub(1, #fontPath - 1)
    end

    fontNameToFontPath[fontName] = fontPath
end

---@return string[]
function sm.regui.font.getFontNames()
    local fontNames = {}
    for fontName, _ in pairs(fontNameToFontPath) do
        table.insert(fontNames, fontName)
    end

    return fontNames
end

---@param fontName string
---@return boolean
function sm.regui.font.fontExists(fontName)
    AssertArgument(fontName, 1, {"string"})

    for name, _ in pairs(fontNameToFontPath) do
        if name == fontName then
            return true
        end
    end

    return false
end

---@param fontName string
---@return string
function sm.regui.font.getFontPath(fontName)
    AssertArgument(fontName, 1, {"string"})

    local path = fontNameToFontPath[fontName]
    ValueAssert(path, 1, "Font not found!")

    return path
end

---@param text string
---@param fontName string
---@param fontSize number
---@param rotation number
---@return number width, number height
function sm.regui.font.calcCustomTextSize(text, fontName, fontSize, rotation, forcedFontSpacing)
    AssertArgument(text    , 1, {"string"})
    AssertArgument(fontName, 2, {"string"})
    AssertArgument(fontSize, 3, {"number"})

    local fontPath = fontNameToFontPath[fontName]
    ValueAssert(value, 2, "Font not found!")

    AssertArgument(forcedFontSpacing, 7, {"number", "nil"})
    
    cachedFonts[fontPath] = cachedFonts[fontPath] or sm_json_open(fontPath .. "/data.json")
    local font = cachedFonts[fontPath]

    local scale = fontSize / font.metadata.fontSize
    local lineHeight = font.metadata.lineHeight * scale
    local tabSize = fontSize * 4 * scale

    local maxWidth = 0
    local currentLineWidth = 0
    local totalHeight = lineHeight

    local parsedText = select(1, parseTextForColoring(text)) -- Strip color codes

    local fontSpacing = forcedFontSpacing or (font.metadata.fontSpacing == 0 and 1 or font.metadata.fontSpacing)

    local index = 1
    while index <= #parsedText do
        local char = getUTF8Character(parsedText, index)

        if char == "\n" then
            maxWidth = math.max(maxWidth, currentLineWidth)
            currentLineWidth = 0
            totalHeight = totalHeight + lineHeight
        elseif char == "\t" then
            currentLineWidth = currentLineWidth + (tabSize * fontSpacing)
        else
            local glyph = font.glyphs[char] or font.glyphs['\xFF\xFD']
            if glyph then
                currentLineWidth = currentLineWidth + (glyph.advanceWidth * fontSpacing * scale)
            else
                currentLineWidth = currentLineWidth + (fontSize * fontSpacing * scale)
            end
        end

        index = index + #char
    end

    maxWidth = math.max(maxWidth, currentLineWidth)

    if not rotation or rotation % 360 == 0 then
        return maxWidth, totalHeight
    end

    local angle = math_rad(rotation)
    local cosA = math_cos(angle)
    local sinA = math_sin(angle)

    local halfW = maxWidth / 2
    local halfH = totalHeight / 2

    local rotatedW = math_abs(halfW * cosA - halfH * sinA) * 2 + math_abs(halfW * cosA + halfH * sinA) * 0
    local rotatedH = math_abs(halfW * sinA + halfH * cosA) * 2 + math_abs(halfW * sinA - halfH * cosA) * 0

    return rotatedW, rotatedH
end

---@param widget ReGuiInterface.Widget
---@param position {[1]: integer?, [2]: integer?, x: integer?, y: integer?}
---@param text string
---@param fontName string
---@param fontSize number
---@param rotation number
function sm.regui.font.drawCustomText(widget, position, text, fontName, fontSize, rotation, forcedFontSpacing)
    AssertArgument(widget  , 1, {"table"}, {"ReguiInterface.Widget"})
    AssertArgument(position, 2, {"table"})
    
    local x = position.x ~= nil and position.x or position[1]
    local y = position.y ~= nil and position.y or position[2]
    ValueAssert(type(x) == "number", 2, "Expected x or [1] to be a number!")
    ValueAssert(type(y) == "number", 2, "Expected y or [2] to be a number!")
    
    AssertArgument(text    , 3, {"string"})
    AssertArgument(fontName, 4, {"string"})
    AssertArgument(fontSize, 5, {"number"})
    AssertArgument(rotation, 6, {"number"})

    AssertArgument(forcedFontSpacing, 7, {"number", "nil"})
    
    local fontPath = fontNameToFontPath[fontName]
    ValueAssert(value, 2, "Font not found!")

    cachedFonts[fontPath] = cachedFonts[fontPath] or sm.json.open(fontPath .. "/data.json")
    local font = cachedFonts[fontPath]

    local scale = fontSize / font.metadata.fontSize
    local scaledImageSize = {
        font.metadata.cellSize * scale,
        font.metadata.cellSize * scale
    }

    local textWidth, textHeight = sm.regui.font.calcCustomTextSize(text, fontPath, fontSize)

    local centerX = x + textWidth / 2
    local centerY = y + textHeight / 2

    local cursorX = x
    local cursorY = y

    local acceptedRotation, acceptedRotationIndex = getClosestNumber(font.metadata.rotations, rotation)

    local cellSizeStr = tostring(font.metadata.cellSize)
    
    local parsedText, colorIndexes = parseTextForColoring(text)
    for key, value in pairs(colorIndexes) do
        colorIndexes[key] = hexToMyGuiColor(value)
    end

    local currentColor = "1 1 1 1"
    
    local fontSpacing = forcedFontSpacing or (font.metadata.fontSpacing == 0 and 1 or font.metadata.fontSpacing)

    local index = 1
    while index <= #parsedText do
        currentColor = colorIndexes[index] or currentColor
        
        local char = getUTF8Character(parsedText, index)

        local glyph = font.glyphs[char]

        if not glyph then
            glyph = font.glyphs['\xFF\xFD']
            
            if not glyph then
                
                if char == "\n" then
                    cursorX = x
                    cursorY = cursorY + (font.metadata.lineHeight * scale)
                elseif char == "\t" then
                    cursorX = cursorX + (fontSize * fontSpacing * 4 * scale)
                else
                    cursorX = cursorX + (fontSize * fontSpacing * scale)
                end

                goto continue
            end
        end

        if char == " " then
            cursorX = cursorX + (glyph.advanceWidth * fontSpacing * scale)
            goto continue
        end
        
        do
            local textureOffset = glyph.rotations[acceptedRotationIndex]
            local charWidget = widget:createWidget("ReGuiTextObject_" .. index, "ImageBox", "ImageBox")

            charWidget:setPosition({rotatePoint(centerX, centerY, cursorX, cursorY, acceptedRotation)})
            charWidget:setSize(scaledImageSize)
            charWidget:setProperty("Colour", currentColor)
            charWidget:setProperty("ImageTexture", fontPath .. "/" .. string_byte(char) .. ".png")
            charWidget:setProperty("ImageCoord", textureOffset[1] .. " " .. textureOffset[2] .. " " .. cellSizeStr .. " " .. cellSizeStr )
            
            cursorX = cursorX + (glyph.advanceWidth * fontSpacing * scale)
        end
        
        ::continue::
        index = index + #char
    end
end

function sm.regui.font.drawCustomTextRealUnits(widget, position, text, fontPath, fontSize, rotation, forcedFontSpacing)
    AssertArgument(widget  , 1, {"table"}, {"ReguiInterface.Widget"})
    AssertArgument(position, 2, {"table"})
    
    local x = position.x ~= nil and position.x or position[1]
    local y = position.y ~= nil and position.y or position[2]
    ValueAssert(type(x) == "number", 2, "Expected x or [1] to be a number!")
    ValueAssert(type(y) == "number", 2, "Expected y or [2] to be a number!")
    
    AssertArgument(text    , 3, {"string"})
    AssertArgument(fontPath, 4, {"string"})
    AssertArgument(fontSize, 5, {"number"})
    AssertArgument(rotation, 6, {"number"})

    AssertArgument(forcedFontSpacing, 7, {"number", "nil"})
    
    sm.regui.font.drawCustomText(widget, {x * 1920, y * 1920}, text, fontPath, fontSize, rotation, forcedFontSpacing)
end

print("Loaded FontManager")