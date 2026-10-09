sm.regui = type(sm.regui) == "table" and sm.regui or {}

dofile("$CONTENT_DATA/Scripts/Modules/Console.lua")

print("Scrap Mechanic: " .. sm.version)
print("ReGuiEditor detected: " .. (reguieditor and "true (" .. reguieditor.version .. ")" or "false"))