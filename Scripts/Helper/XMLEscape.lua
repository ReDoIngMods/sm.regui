function EscapeStringForXML(str)
    str = str:gsub("&", "&amp;")
    str = str:gsub("<", "&lt;")
    str = str:gsub(">", "&gt;")
    str = str:gsub('"', "&quot;")
    str = str:gsub("'", "&apos;")
    return str
end

function GenerateValidXMLFileForLayouts(str)
    str = str:gsub("'", "&apos;")
    str = str:gsub("\"", "'")
    
    return "\"" .. str .. "<!--"
end

print("Loaded Helper/XMLEscape.lua")