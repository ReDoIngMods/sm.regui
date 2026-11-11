local banner = [[
 ________  _____ ______       ________  _______   ________  ___  ___  ___
|\   ____\|\   _ \  _   \    |\   __  \|\  ___ \ |\   ____\|\  \|\  \|\  \
\ \  \___|\ \  \\\__\ \  \   \ \  \|\  \ \   __/|\ \  \___|\ \  \\\  \ \  \
 \ \_____  \ \  \\|__| \  \   \ \   _  _\ \  \_|/_\ \  \  __\ \  \\\  \ \  \
  \|____|\  \ \  \    \ \  \ __\ \  \\  \\ \  \_|\ \ \  \|\  \ \  \\\  \ \  \
    ____\_\  \ \__\    \ \__\\__\ \__\\ _\\ \_______\ \_______\ \_______\ \__\
   |\_________\|__|     \|__\|__|\|__|\|__|\|_______|\|_______|\|_______|\|__|
   \|_________|          Remaking MyGui in MyGui, while being better
]]

for line in banner:gmatch("[^\n]+") do
    print(line)
end

print("Scrap Mechanic: " .. sm.version)
print("ReGuiEditor detected: " .. (reguieditor and "true (" .. reguieditor.version .. ")" or "false"))

sm.regui = type(sm.regui) == "table" and sm.regui or {}

local modules = sm.json.open("$CONTENT_DATA/Scripts/Modules/modules.json", true)
for _, modulePath in ipairs(modules.modules) do
    dofile(modulePath)

    print("Loaded module: " .. modulePath)
end