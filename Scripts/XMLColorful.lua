local DEFAULT_COLOR = "#EEEEEE"

-- The themes 100% have wrong colors. not my problem cause im
-- too fucking lazy to fix it. - VeraDev

local THEMES = {
    Monokai = {
        TAG_OPEN        = "#F8F8F2",
        TAG_CLOSE       = "#F8F8F2",
        TAG_SLASH_OPEN  = "#F8F8F2",
        TAG_SELF_CLOSE  = "#F8F8F2",
        TAG_NAME_OPEN   = "#F92672",
        TAG_NAME_CLOSE  = "#F92672",
        ATTR_NAME       = "#A6E22E",
        ATTR_EQUALS     = "#F8F8F2",
        ATTR_QUOTE      = "#E6DB74",
        ATTR_VALUE      = "#E6DB74",
        COMMENT_OPEN    = "#75715E",
        COMMENT_CONTENT = "#75715E",
        COMMENT_CLOSE   = "#75715E",
        CDATA_OPEN      = "#66D9EF",
        CDATA_CONTENT   = "#66D9EF",
        CDATA_CLOSE     = "#66D9EF",
        PI_OPEN         = "#AE81FF",
        PI_TARGET       = "#F92672",
        PI_ATTR_NAME    = "#A6E22E",
        PI_ATTR_EQUALS  = "#F8F8F2",
        PI_ATTR_QUOTE   = "#E6DB74",
        PI_ATTR_VALUE   = "#E6DB74",
        PI_CLOSE        = "#AE81FF",
        DOCTYPE_OPEN    = "#AE81FF",
        DOCTYPE_KEYWORD = "#AE81FF",
        DOCTYPE_NAME    = "#F92672",
        DOCTYPE_CLOSE   = "#AE81FF",
        TEXT            = "#F8F8F2",
    },
    VSLight = {
        TAG_OPEN        = "#0000FF",
        TAG_CLOSE       = "#0000FF",
        TAG_SLASH_OPEN  = "#0000FF",
        TAG_SELF_CLOSE  = "#0000FF",
        TAG_NAME_OPEN   = "#800000",
        TAG_NAME_CLOSE  = "#800000",
        ATTR_NAME       = "#FF0000",
        ATTR_EQUALS     = "#000000",
        ATTR_QUOTE      = "#000000",
        ATTR_VALUE      = "#0000FF",
        COMMENT_OPEN    = "#008000",
        COMMENT_CONTENT = "#008000",
        COMMENT_CLOSE   = "#008000",
        CDATA_OPEN      = "#800080",
        CDATA_CONTENT   = "#800080",
        CDATA_CLOSE     = "#800080",
        PI_OPEN         = "#800000",
        PI_TARGET       = "#800000",
        PI_ATTR_NAME    = "#FF0000",
        PI_ATTR_EQUALS  = "#000000",
        PI_ATTR_QUOTE   = "#000000",
        PI_ATTR_VALUE   = "#0000FF",
        PI_CLOSE        = "#800000",
        DOCTYPE_OPEN    = "#800000",
        DOCTYPE_KEYWORD = "#800000",
        DOCTYPE_NAME    = "#FF0000",
        DOCTYPE_CLOSE   = "#800000",
        TEXT            = "#000000",
    },
    VSDark = {
        TAG_OPEN        = "#569CD6",
        TAG_CLOSE       = "#569CD6",
        TAG_SLASH_OPEN  = "#569CD6",
        TAG_SELF_CLOSE  = "#569CD6",
        TAG_NAME_OPEN   = "#9CDCFE",
        TAG_NAME_CLOSE  = "#9CDCFE",
        ATTR_NAME       = "#9CDCFE",
        ATTR_EQUALS     = "#D4D4D4",
        ATTR_QUOTE      = "#D4D4D4",
        ATTR_VALUE      = "#CE9178",
        COMMENT_OPEN    = "#6A9955",
        COMMENT_CONTENT = "#6A9955",
        COMMENT_CLOSE   = "#6A9955",
        CDATA_OPEN      = "#4EC9B0",
        CDATA_CONTENT   = "#4EC9B0",
        CDATA_CLOSE     = "#4EC9B0",
        PI_OPEN         = "#C586C0",
        PI_TARGET       = "#C586C0",
        PI_ATTR_NAME    = "#9CDCFE",
        PI_ATTR_EQUALS  = "#D4D4D4",
        PI_ATTR_QUOTE   = "#D4D4D4",
        PI_ATTR_VALUE   = "#CE9178",
        PI_CLOSE        = "#C586C0",
        DOCTYPE_OPEN    = "#C586C0",
        DOCTYPE_KEYWORD = "#C586C0",
        DOCTYPE_NAME    = "#569CD6",
        DOCTYPE_CLOSE   = "#C586C0",
        TEXT            = "#D4D4D4",
    },
    SolarizedLight = {
        TAG_OPEN        = "#268BD2",
        TAG_CLOSE       = "#268BD2",
        TAG_SLASH_OPEN  = "#268BD2",
        TAG_SELF_CLOSE  = "#268BD2",
        TAG_NAME_OPEN   = "#DC322F",
        TAG_NAME_CLOSE  = "#DC322F",
        ATTR_NAME       = "#859900",
        ATTR_EQUALS     = "#586E75",
        ATTR_QUOTE      = "#586E75",
        ATTR_VALUE      = "#2AA198",
        COMMENT_OPEN    = "#93A1A1",
        COMMENT_CONTENT = "#93A1A1",
        COMMENT_CLOSE   = "#93A1A1",
        CDATA_OPEN      = "#B58900",
        CDATA_CONTENT   = "#B58900",
        CDATA_CLOSE     = "#B58900",
        PI_OPEN         = "#6C71C4",
        PI_TARGET       = "#6C71C4",
        PI_ATTR_NAME    = "#859900",
        PI_ATTR_EQUALS  = "#586E75",
        PI_ATTR_QUOTE   = "#586E75",
        PI_ATTR_VALUE   = "#2AA198",
        PI_CLOSE        = "#6C71C4",
        DOCTYPE_OPEN    = "#6C71C4",
        DOCTYPE_KEYWORD = "#6C71C4",
        DOCTYPE_NAME    = "#DC322F",
        DOCTYPE_CLOSE   = "#6C71C4",
        TEXT            = "#073642",
    },
    SolarizedDark = {
        TAG_OPEN        = "#268BD2",
        TAG_CLOSE       = "#268BD2",
        TAG_SLASH_OPEN  = "#268BD2",
        TAG_SELF_CLOSE  = "#268BD2",
        TAG_NAME_OPEN   = "#CB4B16",
        TAG_NAME_CLOSE  = "#CB4B16",
        ATTR_NAME       = "#B58900",
        ATTR_EQUALS     = "#93A1A1",
        ATTR_QUOTE      = "#93A1A1",
        ATTR_VALUE      = "#2AA198",
        COMMENT_OPEN    = "#586E75",
        COMMENT_CONTENT = "#586E75",
        COMMENT_CLOSE   = "#586E75",
        CDATA_OPEN      = "#D33682",
        CDATA_CONTENT   = "#D33682",
        CDATA_CLOSE     = "#D33682",
        PI_OPEN         = "#6C71C4",
        PI_TARGET       = "#6C71C4",
        PI_ATTR_NAME    = "#B58900",
        PI_ATTR_EQUALS  = "#93A1A1",
        PI_ATTR_QUOTE   = "#93A1A1",
        PI_ATTR_VALUE   = "#2AA198",
        PI_CLOSE        = "#6C71C4",
        DOCTYPE_OPEN    = "#6C71C4",
        DOCTYPE_KEYWORD = "#6C71C4",
        DOCTYPE_NAME    = "#CB4B16",
        DOCTYPE_CLOSE   = "#6C71C4",
        TEXT            = "#EEE8D5",
    },
    Dracula = {
        TAG_OPEN        = "#FF79C6",
        TAG_CLOSE       = "#FF79C6",
        TAG_SLASH_OPEN  = "#FF79C6",
        TAG_SELF_CLOSE  = "#FF79C6",
        TAG_NAME_OPEN   = "#8BE9FD",
        TAG_NAME_CLOSE  = "#8BE9FD",
        ATTR_NAME       = "#50FA7B",
        ATTR_EQUALS     = "#FFB86C",
        ATTR_QUOTE      = "#FFB86C",
        ATTR_VALUE      = "#F1FA8C",
        COMMENT_OPEN    = "#6272A4",
        COMMENT_CONTENT = "#6272A4",
        COMMENT_CLOSE   = "#6272A4",
        CDATA_OPEN      = "#BD93F9",
        CDATA_CONTENT   = "#BD93F9",
        CDATA_CLOSE     = "#BD93F9",
        PI_OPEN         = "#FF79C6",
        PI_TARGET       = "#FF79C6",
        PI_ATTR_NAME    = "#50FA7B",
        PI_ATTR_EQUALS  = "#FFB86C",
        PI_ATTR_QUOTE   = "#FFB86C",
        PI_ATTR_VALUE   = "#F1FA8C",
        PI_CLOSE        = "#FF79C6",
        DOCTYPE_OPEN    = "#FF79C6",
        DOCTYPE_KEYWORD = "#FF79C6",
        DOCTYPE_NAME    = "#8BE9FD",
        DOCTYPE_CLOSE   = "#FF79C6",
        TEXT            = "#F8F8F2",
    },
    GruvboxDark = {
        TAG_OPEN        = "#FB4934",
        TAG_CLOSE       = "#FB4934",
        TAG_SLASH_OPEN  = "#FB4934",
        TAG_SELF_CLOSE  = "#FB4934",
        TAG_NAME_OPEN   = "#FABD2F",
        TAG_NAME_CLOSE  = "#FABD2F",
        ATTR_NAME       = "#B8BB26",
        ATTR_EQUALS     = "#EBDBB2",
        ATTR_QUOTE      = "#EBDBB2",
        ATTR_VALUE      = "#8EC07C",
        COMMENT_OPEN    = "#928374",
        COMMENT_CONTENT = "#928374",
        COMMENT_CLOSE   = "#928374",
        CDATA_OPEN      = "#83A598",
        CDATA_CONTENT   = "#83A598",
        CDATA_CLOSE     = "#83A598",
        PI_OPEN         = "#D3869B",
        PI_TARGET       = "#D3869B",
        PI_ATTR_NAME    = "#B8BB26",
        PI_ATTR_EQUALS  = "#EBDBB2",
        PI_ATTR_QUOTE   = "#EBDBB2",
        PI_ATTR_VALUE   = "#8EC07C",
        PI_CLOSE        = "#D3869B",
        DOCTYPE_OPEN    = "#D3869B",
        DOCTYPE_KEYWORD = "#D3869B",
        DOCTYPE_NAME    = "#FABD2F",
        DOCTYPE_CLOSE   = "#D3869B",
        TEXT            = "#EBDBB2",
    },
    TomorrowNight = {
        TAG_OPEN        = "#CC99CC",
        TAG_CLOSE       = "#CC99CC",
        TAG_SLASH_OPEN  = "#CC99CC",
        TAG_SELF_CLOSE  = "#CC99CC",
        TAG_NAME_OPEN   = "#F99157",
        TAG_NAME_CLOSE  = "#F99157",
        ATTR_NAME       = "#99CC99",
        ATTR_EQUALS     = "#FFFFFF",
        ATTR_QUOTE      = "#FFFFFF",
        ATTR_VALUE      = "#FFCC66",
        COMMENT_OPEN    = "#999999",
        COMMENT_CONTENT = "#999999",
        COMMENT_CLOSE   = "#999999",
        CDATA_OPEN      = "#66CCCC",
        CDATA_CONTENT   = "#66CCCC",
        CDATA_CLOSE     = "#66CCCC",
        PI_OPEN         = "#FF9999",
        PI_TARGET       = "#FF9999",
        PI_ATTR_NAME    = "#99CC99",
        PI_ATTR_EQUALS  = "#FFFFFF",
        PI_ATTR_QUOTE   = "#FFFFFF",
        PI_ATTR_VALUE   = "#FFCC66",
        PI_CLOSE        = "#FF9999",
        DOCTYPE_OPEN    = "#FF9999",
        DOCTYPE_KEYWORD = "#FF9999",
        DOCTYPE_NAME    = "#F99157",
        DOCTYPE_CLOSE   = "#FF9999",
        TEXT            = "#FFFFFF",
    },
}

---Tokenizes XML text into colored output segments.
---@param xml string
---@return table[] tokens
local function TokenizeXml(xml)
    local tokens = {}
    local position = 1
    local length = #xml

    ---Appends a token to the token list.
    ---@param tokenType string
    ---@param value string
    local function addToken(tokenType, value)
        tokens[#tokens + 1] = {
            type = tokenType,
            value = value
        }
    end

    ---Reads one or more characters from the current position without advancing.
    ---@param offset integer|nil
    ---@return string
    local function peek(offset)
        offset = offset or 0

        return xml:sub(position, position + offset)
    end

    ---Consumes a number of characters and advances the cursor.
    ---@param count integer
    ---@return string
    local function consume(count)
        local chunk = xml:sub(position, position + count - 1)
        position = position + count

        return chunk
    end

    ---Matches a Lua pattern at the current position.
    ---@param pattern string
    ---@return string|nil
    local function matchPattern(pattern)
        local startPosition, endPosition = xml:find(pattern, position)

        if startPosition == position then
            position = endPosition + 1
            return xml:sub(startPosition, endPosition)
        end
    end

    ---Reads text until a stop pattern begins (exclusive).
    ---@param stopPattern string
    ---@return string
    local function readUntilExclusive(stopPattern)
        local startPosition, _ = xml:find(stopPattern, position)
        if startPosition then
            local content = xml:sub(position, startPosition - 1)
            position = startPosition

            return content
        end

        local content = xml:sub(position)
        position = length + 1

        return content
    end

    ---Reads a newline token if present at the current position.
    ---@return boolean consumed
    local function readNewline()
        if peek() == "\r" and xml:sub(position + 1, position + 1) == "\n" then
            addToken("NEWLINE", consume(2))
            return true
        end

        if peek() == "\n" or peek() == "\r" then
            addToken("NEWLINE", consume(1))
            return true
        end

        return false
    end

    ---Reads a plain text token until a tag opening or newline.
    local function readText()
        local startPosition = position
        while position <= length do
            local character = peek()
            if character == "<" or character == "\n" or character == "\r" then
                break
            end

            position = position + 1
        end

        if position > startPosition then
            addToken("TEXT", xml:sub(startPosition, position - 1))
        end
    end

    ---Reads horizontal whitespace, or forwards newline handling.
    ---@return boolean consumed
    local function readWhitespace()
        if readNewline() then
            return true
        end

        local character = peek()
        if character ~= " " and character ~= "\t" then
            return false
        end

        local startPosition = position
        while position <= length do
            character = peek()
            if character ~= " " and character ~= "\t" then
                break
            end

            position = position + 1
        end

        addToken("WHITESPACE", xml:sub(startPosition, position - 1))
        return true
    end

    ---Reads an XML comment block.
    local function readComment()
        addToken("COMMENT_OPEN", consume(4)) -- <!--

        local content = readUntilExclusive("-->")
        if content ~= "" then
            addToken("COMMENT_CONTENT", content)
        end

        if xml:find("^-->", position) then
            addToken("COMMENT_CLOSE", consume(3))
        end
    end

    ---Reads an XML CDATA section.
    local function readCdata()
        addToken("CDATA_OPEN", consume(9)) -- <![CDATA[

        local content = readUntilExclusive("%]%]>")
        if content ~= "" then
            addToken("CDATA_CONTENT", content)
        end

        if xml:find("^%]%]>", position) then
            addToken("CDATA_CLOSE", consume(3))
        end
    end

    ---Reads one Processing Instruction attribute.
    local function readPIAttribute()
        local name = matchPattern("^[%w:_.%-]+")
        if not name then
            return
        end

        addToken("PI_ATTR_NAME", name)
        if peek() ~= "=" then
            return
        end

        addToken("PI_ATTR_EQUALS", consume(1))
        local quote = peek()
        if quote ~= '"' and quote ~= "'" then
            return
        end

        addToken("PI_ATTR_QUOTE", consume(1))
        local startPosition = position
        while position <= length and peek() ~= quote do
            position = position + 1
        end

        addToken("PI_ATTR_VALUE", xml:sub(startPosition, position - 1))
        if peek() == quote then
            addToken("PI_ATTR_QUOTE", consume(1))
        end
    end

    ---Reads an XML Processing Instruction, including attributes.
    local function readProcessingInstruction()
        addToken("PI_OPEN", consume(2)) -- <?

        local target = matchPattern("^[%w:_.%-]+")
        if target then
            addToken("PI_TARGET", target)
        end

        while position <= length do
            if readWhitespace() then
                goto continue
            end
            
            if xml:find("^%?>", position) then
                addToken("PI_CLOSE", consume(2))
                return
            end

            readPIAttribute()
            ::continue::
        end
    end

    ---Reads a simple DOCTYPE declaration.
    local function readDoctype()
        addToken("DOCTYPE_OPEN", consume(2))    -- <!
        addToken("DOCTYPE_KEYWORD", consume(7)) -- DOCTYPE

        while position <= length do
            if readWhitespace() then
                goto continue
            end

            if peek() == ">" then
                break
            end

            local name = matchPattern("^[%w:_.%-]+")
            if name then
                addToken("DOCTYPE_NAME", name)
                goto continue
            end

            -- Fallback: consume one character to avoid an infinite loop
            consume(1)
            ::continue::
        end

        if peek() == ">" then
            addToken("DOCTYPE_CLOSE", consume(1))
        end
    end

    ---Reads one standard XML attribute inside a normal tag.
    local function readAttribute()
        local name = matchPattern("^[%w:_.%-]+")
        if not name then
            return
        end

        addToken("ATTR_NAME", name)
        if peek() ~= "=" then
            return
        end

        addToken("ATTR_EQUALS", consume(1))
        local quote = peek()
        if quote ~= '"' and quote ~= "'" then
            return
        end

        addToken("ATTR_QUOTE", consume(1))
        local startPosition = position
        while position <= length and peek() ~= quote do
            position = position + 1
        end

        addToken("ATTR_VALUE", xml:sub(startPosition, position - 1))
        if peek() == quote then
            addToken("ATTR_QUOTE", consume(1))
        end
    end

    ---Reads a regular XML tag (opening, closing, or self-closing).
    local function readTag()
        local isClosing = xml:sub(position + 1, position + 1) == "/"
        if isClosing then
            addToken("TAG_SLASH_OPEN", consume(2))
        else
            addToken("TAG_OPEN", consume(1))
        end

        local tagName = matchPattern("^[%w:_.%-]+")
        if tagName then
            addToken(isClosing and "TAG_NAME_CLOSE" or "TAG_NAME_OPEN", tagName)
        end

        while position <= length do
            if readWhitespace() then
                goto continue
            end

            local character = peek()
            if character == ">" then
                addToken("TAG_CLOSE", consume(1))
                return
            end

            if character == "/" and xml:sub(position + 1, position + 1) == ">" then
                addToken("TAG_SELF_CLOSE", consume(2))
                return
            end

            readAttribute()
            ::continue::
        end
    end

    while position <= length do
        if readNewline() then
            goto continue
        end

        if peek() ~= "<" then
            readText()
            goto continue
        end

        if xml:find("^<!%-%-", position) then
            readComment()
            goto continue
        end

        if xml:find("^<!%[CDATA%[", position) then
            readCdata()
            goto continue
        end

        if xml:find("^<%?", position) then
            readProcessingInstruction()
            goto continue
        end
        if xml:find("^<!DOCTYPE", position) or xml:find("^<!doctype", position) then
            readDoctype()
            goto continue
        end
        readTag()
        ::continue::
    end

    return tokens
end

local XMLColorful = {}

---Gets all theme names
---@return string[] names
function XMLColorful.getThemeNames()
    local names = {}
    for name in pairs(THEMES) do
        names[#names + 1] = name
    end

    table.sort(names)
    return names
end

---Gets all token type names generated by the tokenizer.
---@return string[] tokenTypes
function XMLColorful.getTokenTypes()
    return {
        "TAG_OPEN",        "TAG_CLOSE",      "TAG_SLASH_OPEN", "TAG_SELF_CLOSE",
        "TAG_NAME_OPEN",   "TAG_NAME_CLOSE", "ATTR_NAME",      "ATTR_EQUALS",
        "ATTR_QUOTE",      "ATTR_VALUE",     "COMMENT_OPEN",   "COMMENT_CONTENT",
        "COMMENT_CLOSE",   "CDATA_OPEN",     "CDATA_CONTENT",  "CDATA_CLOSE",
        "PI_OPEN",         "PI_TARGET",      "PI_ATTR_NAME",   "PI_ATTR_EQUALS",
        "PI_ATTR_QUOTE",   "PI_ATTR_VALUE",  "PI_CLOSE",       "DOCTYPE_OPEN",
        "DOCTYPE_KEYWORD", "DOCTYPE_NAME",   "DOCTYPE_CLOSE",  "TEXT",
        "WHITESPACE",      "NEWLINE",
    }
end

---Registers or replaces a theme.
---@param name string
---@param theme table|nil
function XMLColorful.addTheme(name, theme)
    ErrorHandler.AssertArgument(name, 1, "string")
    ErrorHandler.AssertArgument(theme, 2, { "table", "nil" }, { "ReGui.XMLColorful.Theme" })
    ErrorHandler.AssertCondition(THEMES[name] == nil, 2, "Theme '%s' already exists", name)

    local tokenTypes = XMLColorful.getTokenTypes()
    for _, key in pairs(tokenTypes) do
        ErrorHandler.AssertTableValue(theme, 2, key, "string")
    end

    THEMES[name] = theme
end

---Gets a theme by name.
---@param name string
---@return table|nil
function XMLColorful.getTheme(name)
    ErrorHandler.AssertArgument(name, 1, "string")

    return THEMES[name]
end


---Converts XML text into a color-prefixed string for ReGui rich text rendering.
---@param xml string
---@param theme table|nil
---@return string
function XMLColorful.colorXML(xml, theme)
    ErrorHandler.AssertArgument(xml, 1, "string")
    ErrorHandler.AssertArgument(theme, 2, { "table", "nil" }, { "ReGui.XMLColorful.Theme" })

    theme = theme or THEMES.VSDark

    local tokens = TokenizeXml(xml)
    local buffer = { DEFAULT_COLOR }
    local lastColor = DEFAULT_COLOR

    for _, token in ipairs(tokens) do
        local color = theme[token.type] or DEFAULT_COLOR
        if color ~= lastColor then
            buffer[#buffer + 1] = color
            lastColor = color
        end

        buffer[#buffer + 1] = token.value
    end

    return table.concat(buffer)
end

sm.regui.xmlcolorful = XMLColorful