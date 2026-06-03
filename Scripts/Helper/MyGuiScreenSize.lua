function GetMyGuiScreenSize()
    local screenWidth, screenHeight = sm.gui.getScreenSize()
    if screenWidth >= 3840 and screenHeight >= 2160 then
        return 3840, 2160 -- 4K
    elseif screenWidth >= 2560 and screenHeight >= 1440 then
        return 2560, 1440 -- 1440p
    elseif screenWidth >= 1920 and screenHeight >= 1080 then
        return 1920, 1080 -- 1080p
    else
        return 1280, 720 -- 720p
    end
end

print("Loaded Helper/MyGuiScreenSize.lua")