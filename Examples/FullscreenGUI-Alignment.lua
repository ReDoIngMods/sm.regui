local states = {
    "Left" , "Left VStretch" , "Left VCenter" ,
    "Right", "Right VStretch", "Right VCenter",
    "Top"   , "Top HStretch"   , "Top HCenter"   ,
    "Bottom", "Bottom HStretch", "Bottom HCenter",
    
    "VCenter HCenter",
    "VCenter HStretch",
    "VStretch HCenter",
    "VStretch HStretch",
    "Top Left", "Top Right",
    "Bottom Left", "Bottom Right",
    "Stretch", "[DEFAULT]", "Default", "Center"
}

local selectedState = states[math.random(1, #states)]
local enableFixedAspectRatio = true

local layoutGui = sm.regui.newBlank()
local widget = layoutGui:createWidget("EditBox", "EditBox", "EditBox")
widget:setPositionRealUnits({0, 0})
widget:setSizeRealUnits({1, 1})
widget:setProperties({
    Caption = "Current Alignment: " .. selectedState,
    FontName = "SM_Text",
    TextAlign = "Center",
    ReadOnly = true
})

local fullscreenGui = sm.regui.fullscreen.createFullscreenGuiFromInterface(layoutGui, enableFixedAspectRatio, selectedState)
fullscreenGui:update()
fullscreenGui:getGui():open()