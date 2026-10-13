sm.regui = type(sm.regui) == "table" and sm.regui or {}

local modules = sm.json.open("$CONTENT_DATA/Scripts/Modules/modules.json", true)
for _, modulePath in ipairs(modules.modules) do
    dofile(modulePath)

    print("Loaded module: " .. modulePath)
end