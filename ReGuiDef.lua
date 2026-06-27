---@diagnostic disable: missing-return, unused-local

---MyGui Widget Alignment types
---@alias ReGui.WidgetAlignmentType
---| "[DEFAULT]" Same as: Left Top
---| "Default" Same as: Left Top
---| "Stretch" Same as: HStretch VStretch
---| "Center" Same as: HCenter VCenter
---| "Left Top"
---| "Left Bottom"
---| "Left VStretch"
---| "Left VCenter"
---| "Right Top"
---| "Right Bottom"
---| "Right VStretch"
---| "Right VCenter"
---| "HStretch Top"
---| "HStretch Bottom"
---| "HCenter Top"
---| "HCenter Bottom"
---| "HStretch VStretch"
---| "HStretch VCenter"
---| "HCenter VStretch"
---| "HCenter VCenter"

---MyGui Text Alignment types
---@alias ReGui.TextAlign
---| "[DEFAULT]" Same as: Left Top
---| "Default" Same as: Left Top
---| "Center" Same as: HCenter VCenter
---| "Left Top"
---| "Left Bottom"
---| "Left VCenter"
---| "Right Top"
---| "Right Bottom"
---| "Right VCenter"
---| "HCenter Top"
---| "HCenter Bottom"
---| "HCenter VCenter"

---MyGui widget types
---@alias ReGui.WidgetType 
---| "Button"
---| "Canvas"
---| "ComboBox"
---| "DDContainer"
---| "EditBox"
---| "ItemBox"
---| "ListBox"
---| "MenuBar"
---| "MultiListBox"
---| "PopupMenu"
---| "ProgressBar"
---| "ScrollBar"
---| "ScrollView"
---| "ImageBox"
---| "TextBox"
---| "TabControl"
---| "Widget"
---| "Window"
---| "StrangeButton" 

---MyGui, New & old Scrap Mechanic skins
---@alias ReGui.SkinType
---| "InventoryBackground" [Old Scrap Mechanic]
---| "VerticalScroll" [Old Scrap Mechanic]
---| "GenericButton" [Old Scrap Mechanic]
---| "LeftArrow" [Old Scrap Mechanic]
---| "RightArrow" [Old Scrap Mechanic]
---| "TransparentTextBox"
---| "TabButton" [Old Scrap Mechanic]
---| "CameraBorder"
---| "SelectionFieldBox"
---| "InventoryVScroll" [Old Scrap Mechanic]
---| "DebugHSlider" [Old Scrap Mechanic]
---| "SMEditBox"
---| "SMButton" [Old Scrap Mechanic]
---| "SMWhiteButton"
---| "SMSmallButton" [Old Scrap Mechanic]
---| "SMTextBox_NoBackground"
---| "SMTextBox_Small_NoBackground"
---| "SMListBoxItem" [Old Scrap Mechanic]
---| "SMListBox" [Old Scrap Mechanic]
---| "SMTabHeaderButton" [Old Scrap Mechanic]
---| "SMTabControl" [Old Scrap Mechanic]
---| "SMEmptyScrollView"
---| "SMScrollView" [Old Scrap Mechanic]
---| "HyperTextLine"
---| "TileEditorHyperTextBox"
---| "PanelEmpty"
---| "RotatingSkin"
---| "TextBoxSkin"
---| "ImageBox"
---| "Canvas"
---| "EditClientSkin"
---| "CheckBoxSkin" [Old MyGui]
---| "RadioButtonSkin" [Old MyGui]
---| "ButtonCloseSkin" [Old MyGui]
---| "ButtonDownSkin" [Old MyGui]
---| "ButtonUpSkin" [Old MyGui]
---| "ButtonLeftSkin" [Old MyGui]
---| "ButtonRightSkin" [Old MyGui]
---| "SliderTrackVSkin" [Old MyGui]
---| "ScrollTrackVSkin" [Old MyGui]
---| "SliderTrackHSkin" [Old MyGui]
---| "ScrollTrackHSkin" [Old MyGui]
---| "ButtonSkin" [Old MyGui]
---| "ButtonEmptySkin" [Old MyGui]
---| "EditBoxSkin" [Old MyGui]
---| "MenuBarSkin" [Old MyGui]
---| "MenuItemSkin" [Old MyGui]
---| "ScrollPanelHSkin" [Old MyGui]
---| "ScrollPanelVSkin" [Old MyGui]
---| "ListBoxItemSkin" [Old MyGui]
---| "SepDownHSkin" [Old MyGui]
---| "SepUpHSkin" [Old MyGui]
---| "SepDownVSkin" [Old MyGui]
---| "SepUpVSkin" [Old MyGui]
---| "ClientDefaultSkin" [Old MyGui]
---| "ClientTileSkin" [Old MyGui]
---| "PanelSkin" [Old MyGui]
---| "WhiteSkin"
---| "CaptionEmptySkin" [Old MyGui]
---| "CaptionSkin" [Old MyGui]
---| "CaptionWithButtonSkin" [Old MyGui]
---| "WindowFrameSkin" [Old MyGui]
---| "WindowResizeLeftDownSkin" [Old MyGui]
---| "WindowResizeRightDownSkin" [Old MyGui]
---| "TabHeaderButtonSkin" [Old MyGui]
---| "TabHeaderEmptySkin" [Old MyGui]
---| "TabPanelSkin" [Old MyGui]
---| "MenuItemNormalSkin" [Old MyGui]
---| "MenuItemPopupButtonSkin" [Old MyGui]
---| "MenuItemCheckButtonSkin" [Old MyGui]
---| "ProgressBarTrackHSkin" [Old MyGui]
---| "MultiListButtonSkin" [Old MyGui]
---| "CheckBox" [Old MyGui]
---| "RadioButton" [Old MyGui]
---| "ScrollBarH" [Old MyGui]
---| "ScrollBarV" [Old MyGui]
---| "SliderH" [Old MyGui]
---| "SliderV" [Old MyGui]
---| "SliderHEmpty" [Old MyGui]
---| "SliderVEmpty" [Old MyGui]
---| "Button" [Old MyGui]
---| "ButtonImage"
---| "TextBox"
---| "EditBox" [Old MyGui]
---| "EditBoxStretch" [Old MyGui]
---| "EditBoxEmpty"
---| "WordWrapEmpty"
---| "ComboBox" [Old MyGui]
---| "Window" [Old MyGui]
---| "WindowC" [Old MyGui]
---| "WindowCS" [Old MyGui]
---| "WindowCX" [Old MyGui]
---| "WindowCSX" [Old MyGui]
---| "MenuBar" [Old MyGui]
---| "MenuBarButton" [Old MyGui]
---| "MenuBarSeparator" [Old MyGui]
---| "PopupMenu" [Old MyGui]
---| "PopupMenuSeparator" [Old MyGui]
---| "PopupMenuNormal" [Old MyGui]
---| "PopupMenuPopup" [Old MyGui]
---| "ProgressBar" [Old MyGui]
---| "ProgressBarFill" [Old MyGui]
---| "ListBoxItem" [Old MyGui]
---| "ListBox" [Old MyGui]
---| "ItemBox" [Old MyGui]
---| "ItemBoxEmpty" [Old MyGui]
---| "ScrollView" [Old MyGui]
---| "ScrollViewEmpty" [Old MyGui]
---| "TabHeaderButton" [Old MyGui]
---| "TabControl" [Old MyGui]
---| "MultiListBox" [Old MyGui]
---| "MultiListButton" [Old MyGui]
---| "MultiSubListBox" [Old MyGui]
---| "TextureBox"
---| "WhiteButton"
---| "SMEditorListBox"
---| "EditorWindow"
---| "EditorWindowNoResize"
---| "EditorEditBox"
---| "EditorButton"
---| "EditorCheckBox"
---| "EditorListBox"
---| "DressbotEffectBackground"
---| "ContainerItemBackground"
---| "InventoryScrollBackground"
---| "InventoryScrollTrack"
---| "SearchBarBackground"
---| "HotbarItemKeybindingBackground"
---| "PageArrowUp"
---| "PageArrowDown"
---| "PageIndicator"
---| "PropertyIndicator"
---| "ExpandButton"
---| "EditButton"
---| "ActiveButton"
---| "PrimaryButton"
---| "SecondaryButton"
---| "EscButton"
---| "GenderButton"
---| "FeatureButton"
---| "ColorBackground"
---| "ScrollBackgroundHorizontal"
---| "ScrollTrackHorizontal"
---| "SettingsButton"
---| "DropDownBackground"
---| "DropDownCollapse"
---| "DropDownItem"
---| "DropDownExpandBackground"
---| "DropDownExpand"
---| "LargeVerticalSliderBackground"
---| "LargeVerticalSliderInnerShadow"
---| "LargeVerticalSliderLimiter"
---| "LargeVerticalSliderHandle"
---| "UpgradeButton"
---| "LargeVerticalSliderProgress"
---| "CraftbotRecipeItemBackground"
---| "CraftbotVerticalScrollTrack"
---| "CraftbotProgressBackground"
---| "CraftbotProgressFill"
---| "CraftbotRepeat"
---| "StyledButtonLarge"
---| "StyledButtonSmall"
---| "ProcessBackground"
---| "InteractionBindingBackground"
---| "HudBackgroundShadowLarge"
---| "HudBackgroundShadowSmall"
---| "HudProgressBarDamageLarge"
---| "HudProgressBarDamageSmall"
---| "HudProgressBarHealth"
---| "HudProgressBarFood"
---| "HudProgressBarWater"
---| "LargeHorizontalSliderInnerShadow"
---| "LargeHorizontalSliderLimiter"
---| "LargeHorizontalSliderProgress"
---| "LargeHorizontalSliderHandle"
---| "LargeHorizontalSliderBackground"
---| "HudProgressBarBreath"
---| "SequenceListBackground"
---| "SequenceListBackgroundLocked"
---| "SmallBrightSliderBackground"
---| "SmallBrightSliderProgress"
---| "SmallBrightSliderTrack"
---| "ControllerCircle"
---| "ToggleButton"
---| "LargeVerticalSliderHandleLeft"
---| "LargeHorizontalSliderProgressInverted"
---| "LargeHorizontalSliderHandleNoPoint"
---| "DressbotQueueBackground"
---| "StyledButtonDressbotMake"
---| "StyledButtonDressbot"
---| "DressbotProgress"
---| "DressbotProgressBackground"
---| "DressbotArrowLeft"
---| "DressbotArrowRight"
---| "StyledButtonDressbotUnbox"
---| "HighlightSelectionBox"
---| "LoadingbarProgress"
---| "LoadingbarBackground"
---| "LoadingbarShadow"
---| "HotbarItemBackground"
---| "InteractionBackground"
---| "HudBackgroundLarge"
---| "HudBackgroundSmall"
---| "HudBackgroundIcon"
---| "MenuButton"
---| "gui_keybinds_bg"
---| "gui_keybinds_bg_white"
---| "gui_keybinds_bg_orange"
---| "ButtonPlay"
---| "InventoryItemBox2"
---| "InventoryVSlider"
---| "InventoryHSlider"
---| "SM_ListBoxItem"
---| "SM_ListBox"
---| "CraftbotVSlider"
---| "InventoryVSliderSmall"
---| "CraftbotProgressBar"
---| "HUDProgressBarGreen"
---| "HUDProgressBarYellow"
---| "HUDProgressBarBlue"
---| "HUDProgressBarRedLarge"
---| "HUDProgressBarRedSmall"
---| "HUDProgressBarLightBlue"
---| "DressbotProgressBar"
---| "LargeProgressBar"
---| "BlurryBackgroundSkin"
---| "BackgroundEngine"
---| "BackgroundEngineNoUpgrade"
---| "BackgroundSensor"
---| "BackgroundSensorNoUpgrade"
---| "BackgroundWorkbench"
---| "BackgroundCookbot"
---| "BackgroundHideout"
---| "BackgroundMechanicStation"
---| "BackgroundMechanicStationTooltip"
---| "BackgroundPiston"
---| "BackgroundMenuInGame"
---| "BackgroundContainerAmmunition"
---| "BackgroundContainerBattery"
---| "BackgroundContainerChemicals"
---| "BackgroundContainerFertilizer"
---| "BackgroundContainerGas"
---| "BackgroundContainerSeed"
---| "BackgroundContainerWater"
---| "BackgroundSequenceController"
---| "BackgroundInteractableNarrow"
---| "BackgroundInteractableWide"
---| "BackgroundDressbot"
---| "BackgroundBlueBot"
---| "BackgroundGreenBot"
---| "BackgroundRedBot"
---| "BackgroundYellowBot"
---| "BackgroundSensorColorSelect"
---| "BackgroundInteractableUltraWide"
---| "ButtonPizzaBurger"
---| "ButtonVeggieBurger"
---| "ButtonRevivalBaguette"
---| "ButtonCookBot"
---| "ButtonDressBot"
---| "ButtonCraftBot"
---| "ButtonRefineryBot"
---| "ButtonResourceBot"
---| "quest_partpin"
---| "quest_toolpin"
---| "quest_rotbearringpin"
---| "quest_connectionorderpin"
---| "BackgroundContainerItemAmmunition"
---| "BackgroundContainerItemBattery"
---| "BackgroundContainerItemChemicals"
---| "BackgroundContainerItemFertilizer"
---| "BackgroundContainerItemGas"
---| "BackgroundContainerItemSeeds"
---| "BackgroundContainerItemWater"
---| "BackgroundFuelBattery"
---| "BackgroundFuelGas"
---| "BackgroundDarkRoundedUpperRight"
---| "BackgroundDarkRoundedLowerLeft"
---| "BackgroundLightSquared"
---| "BackgroundLightRoundedLowerLeft"
---| "BackgroundPopup"
---| "BackgroundPromptNarrow"
---| "BackgroundPromptWide"
---| "ItemColorLine"
---| "InventoryTab"
---| "ModPanelBackground"
---| "BackgroundInventoryToolTip"
---| "ToolTipLeft"
---| "ToolTipRight"
---| "TutorialBgBottom"
---| "TutorialBgMain"
---| "BeaconBG"
---| "BeaconBottomBG"
---| "BeaconIconColor"
---| "BeaconIconColorBorder"
---| "BeaconIconBorder"
---| "BeaconWorldIconBG"
---| "Banner"
---| "Unlock"
---| "BackgroundCraftbot"
---| "BackgroundCraftbotTooltip"
---| "CraftbotTab"
---| "DressbotRewardItem"
---| "DressbotProcessItem"
---| "DressbotDragProcessItem"
---| "DressbotBoxItem"
---| "DressbotDragBoxItem"
---| "BackgroundLiftImport"
---| "BackgroundPanel"
---| "LiftTab"
---| "LiftGrid"
---| "LiftInput"
---| "BackgroundLiftExport"
---| "LiftCameraButton"
---| "LiftSteamButton"
---| "EditBox_LiftInput"
---| "LogbookBG"
---| "LogbookGridBG@720"
---| "LogbookBeaconIconBG"
---| "LogbookButton"
---| "LogbookButtonBeacon"
---| "LogbookButtonSwitch"
---| "LogbookItemBG"
---| "LogItemBox"
---| "BeaconItemBox"
---| "PhotoDescription"
---| "LogicGateBG"
---| "LogicGateButtons"
---| "NonBlurryBackgroundDarkRoundedUpperRight"
---| "NonBlurryBackgroundDarkRoundedLowerLeft"
---| "NonBlurryBackgroundLightSquared"
---| "NonBlurryBackgroundLightRoundedLowerLeft"
---| "BackgroundMenuSurvival"
---| "BackgroundMenuCreative"
---| "BackgroundMenuCreative_tilebuilder"
---| "BackgroundMenuCreative_worldbuilder"
---| "BackgroundMenuDownload"
---| "BackgroundMenuChallenge"
---| "BackgroundMenuChallenge_challengebuilder"
---| "BackgroundMenuChallenge_details"
---| "BackgroundMenuChallenge_builderdetails"
---| "PickupBgParts"
---| "PickupBgBlocks"
---| "PickupBgInteractives"
---| "PickupBgTools"
---| "PickupBgConsumables"

---All fonts available in Scrap Mechanic, including their size, spacing and supported characters. There may be inaccuracies for spacing & font size!
---@alias ReGui.FontName
---**Font Size:** `60px`<br>**Tracking:** `1,33`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@BCGHJKLQWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- ADEFIMNOPRSTUV
---```
---| "SM_HeaderXLarge_Wide"
---**Font Size:** `40px`<br>**Tracking:** `6,67`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---#$%&()*+-:;<=>@Q[]^`jqz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !"',./0123456789?ABCDEFGHIJKLMNOPRSTUVWXYZ\_abcdefghiklmnoprstuvwxy
---```
---| "SM_HeaderLarge_Wide"
---**Font Size:** `40px`<br>**Tracking:** `2,67`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---#$%&()*+-:;<=>@Q[]^`jqz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !"',./0123456789?ABCDEFGHIJKLMNOPRSTUVWXYZ\_abcdefghiklmnoprstuvwxy
---```
---| "SM_HeaderLarge_Medium"
---**Font Size:** `40px`<br>**Tracking:** `0,67`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---#$%&()*+-:;<=>@Q[]^`jqz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !"',./0123456789?ABCDEFGHIJKLMNOPRSTUVWXYZ\_abcdefghiklmnoprstuvwxy
---```
---| "SM_HeaderLarge_Narrow"
---**Font Size:** `30px`<br>**Tracking:** `2`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@FJKPQVXZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- ABCDEGHILMNORSTUWY
---```
---| "SM_HeaderMedium"
---**Font Size:** `25px`<br>**Tracking:** `3`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_SubHeader"
---**Font Size:** `22,5px`<br>**Tracking:** `1,33`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_Header"
---**Font Size:** `20px`<br>**Tracking:** `1,33`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&'()*+,./;<=>?@JQ\^_`dgjqxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !-0123456789:ABCDEFGHIKLMNOPRSTUVWXYZ[]abcefhiklmnoprstuvw
---```
---| "SM_HeaderSmall"
---**Font Size:** `17,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_HeaderTiny"
---**Font Size:** `22,5px`<br>**Tracking:** `1,33`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_Tab"
---**Font Size:** `20px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_TabSmall"
---**Font Size:** `22,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_TextLabel"
---**Font Size:** `22,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_Label"
---**Font Size:** `20px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_LabelSmall"
---**Font Size:** `17,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_LabelTiny"
---**Font Size:** `15px`<br>**Tracking:** `0,67`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./:;<=>?@BFGHJKMNPQUXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- 0123456789ACDEILORSTVW
---```
---| "SM_LabelMini"
---**Font Size:** `12,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./:;<=>?@BCDEGHJKNPQRUVYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- 0123456789AFILMOSTWX
---```
---| "SM_SliderLabel"
---**Font Size:** `25px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_SearchText"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_ToolTipText"
---**Font Size:** `30px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&'()*-/0123456789;<=>?@EHJKLNOPRVWX[\]^_`qx{|}~
---```
---**Supported en-US characters:**
---```txt
--- !+,.:ABCDFGIMQSTUYZabcdefghijklmnoprstuvwyz
---```
---| "SM_TextLarge"
---**Font Size:** `25px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_Text"
---**Font Size:** `30px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRTUVWXYZ[\]^_`bdfgijkmquvxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- Sacehlnoprstw
---```
---| "SM_TextDesc"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_TextSmall"
---**Font Size:** `17,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_TextTiny"
---**Font Size:** `27,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_ItemTitle"
---**Font Size:** `27,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_GameName"
---**Font Size:** `32,5px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@DJQVWYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- ABCEFGHIKLMNOPRSTUX
---```
---| "SM_ButtonLarge"
---**Font Size:** `25px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_Button"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&'()*+,./;<=>?@JQ\^_`dgjqxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !-0123456789:ABCDEFGHIKLMNOPRSTUVWXYZ[]abcefhiklmnoprstuvw
---```
---| "SM_ButtonSmall"
---**Font Size:** `17,5px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_ButtonTiny"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_ButtonSmallBold"
---**Font Size:** `52,5px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- 0123456789:
---```
---| "SM_NumberHuge"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&'()*+,./;<=>?@JQ\^_`dgjqxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !-0123456789:ABCDEFGHIKLMNOPRSTUVWXYZ[]abcefhiklmnoprstuvw
---```
---| "SM_NumberSmall"
---**Font Size:** `17,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_NumberTiny"
---**Font Size:** `15px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()+,-.:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- */0123456789X
---```
---| "SM_NumberMini"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_UserName"
---**Font Size:** `22,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_ListItem"
---**Font Size:** `16,25px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_HotbarBinding"
---**Font Size:** `45px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `✅ Yes`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "SM_IntlText"
---**Font Size:** `45px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- 0123456789:
---```
---| "SM_Digital"
---**Font Size:** `37,5px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLNOPQRTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- MS
---```
---| "X_Interactable_Timer_TimeUnit"
---**Font Size:** `27,5px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./:;<=>?@ABDEFGHJLMNOPQRUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- 0123456789CIKST
---```
---| "X_Interactable_Timer_TickCount"
---**Font Size:** `27,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "X_Interactable_LogicGate_Category"
---**Font Size:** `62,5px`<br>**Tracking:** `3,33`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@BDFJKMOPQWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- ACEGHILNRSTUV
---```
---| "X_MenuGamemodeMenu_GameMode"
---**Font Size:** `30px`<br>**Tracking:** `0,67`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "X_Hud_Alert"
---**Font Size:** `25px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "X_Hud_Interaction"
---**Font Size:** `27,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "X_Hud_PlayerName"
---**Font Size:** `27,5px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
--- !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---| "X_Hud_ItemStack"
---**Font Size:** `113,33333px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
--- !"#$%&()*+,-./0123456789:;<=>?@JKXZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
---'ABCDEFGHILMNOPQRSTUVWY
---```
---| "HandbookTitle"
---**Font Size:** `30px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!#$%*/01246789:;<=>@DGJKOVXZ[\]^_`{|}~
---```
---**Supported en-US characters:**
---```txt
--- "&'()+,-.35?ABCEFHILMNPQRSTUWYabcdefghijklmnopqrstuvwxyz
---```
---| "HandbookSubTitle"
---**Font Size:** `30px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&()*+-/0123456789:;<=>?@ABCDFGHIJKMNOPQRSUVWXYZ[\]^_`jqz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !',.ELTabcdefghiklmnoprstuvwxy
---```
---| "HandbookSubTitleItalic"
---**Font Size:** `40px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-.:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- /0123456789
---```
---| "HandbookPageCount"
---**Font Size:** `23,333332px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+-/0123456789:;<=>?@DEFGHJKLMNOQRUVWXYZ[\]^_`jx{|}~
---```
---**Supported en-US characters:**
---```txt
--- ,.ABCIPSTabcdefghiklmnopqrstuvwyz
---```
---| "HandbookDescriptionLarge"
---**Font Size:** `20px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&'()*+/0123456789;<=>?@DGIJKLMNORVXZ[\]^_`{|}~
---```
---**Supported en-US characters:**
---```txt
--- !,-.:ABCEFHPQSTUWYabcdefghijklmnopqrstuvwxyz
---```
---| "HandbookDescriptionSmall"
---**Font Size:** `41,66667px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@ADEFGJKLMNOQRSTUVWXYZ[\]^_`dfghjpqwxz{|}~
---```
---**Supported en-US characters:**
---```txt
--- BCHIPabceiklmnorstuvy
---```
---| "HandbookInstructionLarge"
---**Font Size:** `28,333332px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-.0123456789:;<=>?@BEFGKNQTUVWXYZ[\]^_`fqwxyz{|}~
---```
---**Supported en-US characters:**
---```txt
--- /ACDHIJLMOPRSabcdeghijklmnoprstuv
---```
---| "HandbookInstructionMedium"
---**Font Size:** `25px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@EFGIJMNOQUVXYZ[\]^_`qvxz{|}~
---```
---**Supported en-US characters:**
---```txt
--- ABCDHKLPRSTWabcdefghijklmnoprstuwy
---```
---| "HandbookInstructionSmall"
---**Font Size:** `13,333332px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!"#$%&'()*+,-./0123456789:;<=>?@BCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`bjmpquwxz{|}~
---```
---**Supported en-US characters:**
---```txt
--- Aacdefghiklnorstvy
---```
---| "HandbookLogicDescription"
---**Font Size:** `26,666668px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---"#$%&'()*+-./0123456789:;<=>@ABCDEFGJKLNPQRSTUVXYZ[\]^_`jkqxz{|}~
---```
---**Supported en-US characters:**
---```txt
--- !,?HIMOWabcdefghilmnoprstuvwy
---```
---| "HandbookFAQQuestion"
---**Font Size:** `30px`<br>**Tracking:** `0`<br>**Full en-US:** `❌ No`<br>**Full Latin:** `❌ No`<br>**Full Cyrillic:** `❌ No`
---
------
---**Missing en-US characters:**
---```txt
---!#$%*/01246789:;<=>@DGJKOVXZ[\]^_`{|}~
---```
---**Supported en-US characters:**
---```txt
--- "&'()+,-.35?ABCEFHILMNPQRSTUWYabcdefghijklmnopqrstuvwxyz
---```
---| "HandbookFAQAnswer"
---**Font Size:** `18,75px`<br>**Tracking:** `0`<br>**Full en-US:** `✅ Yes`<br>**Full Latin:** `✅ Yes`<br>**Full Cyrillic:** `✅ Yes`
---
------
---**Missing en-US characters:**
---```txt
---None
---```
---**Supported en-US characters:**
---```txt
---ALL CHARACTERS
---```
---| "DeJaVuSans"

---GuiInterface settings
---@class ReGui.GuiSettings
---@field isHud? boolean Whether the gui is part of the HUD or not
---@field isInteractive? boolean Whether the gui is interactive or not
---@field needsCursor? boolean Whether the gui makes use of the mouse cursor or not
---@field hidesHotbar? boolean Whether the gui hides the hotbar or not
---@field isOverlapped? boolean Unknown
---@field backgroundAlpha? number The alpha of the background(0 - transparent | 1 - opaque, black background)

---Coordinate storage mode for a widget.
---@alias ReGui.CoordinateMode
---| "Pixels" Coordinates are stored as integer pixel values.
---| "Real"   Coordinates are stored as real units (0–1, relative to parent size or screen size).

---sm.regui, ReDoing Graphical User Interfaces
sm.regui = {}

---Creates a GUI from a layout file
---@param path string The path to the layout file
---@return ReGui.GuiInterface guiinterface The created GUI object
function sm.regui.createGuiFromLayout(path) end

---Creates an empty GUI
---@return ReGui.GuiInterface guiinterface The created GUI object
function sm.regui.createGui() end

---Creates a new FullscreenInterface from a layout file
---@param path string The path to the layout file
---@return ReGui.FullscreenInterface fullscreeninterface The created FullscreenInterface object
function sm.regui.createFullscreenInterfaceFromLayout(path) end

---Creates an empty FullscreenInterface
---@return ReGui.FullscreenInterface fullscreeninterface The created FullscreenInterface object
function sm.regui.createFullscreenInterface() end

--- UTILS --

---A XMLColorful theme. Keys are token names, Values are the color associated to that token.
---@alias ReGui.XMLColorful.Theme table<string, string>

-- Library to add coloring to XML data to be used in a MyGUI text widget.
sm.regui.xmlcolorful = {}

---Gets all theme names
---@return string[] names All themen ames
function sm.regui.xmlcolorful.getThemeNames() end

---Gets all token type names generated by the tokenizer.
---@return string[] tokenTypes All token types
function sm.regui.xmlcolorful.getTokenTypes() end

---Registers or replaces a theme.
---@param name string The name of the new theme
---@param theme ReGui.XMLColorful.Theme The contents of the theme.
function sm.regui.xmlcolorful.addTheme(name, theme) end

---Gets a theme by name.
---@param name string The name of the theme to get
---@return ReGui.XMLColorful.Theme? theme The theme, or nil if not found
function sm.regui.xmlcolorful.getTheme(name) end

---Converts XML text into a color-prefixed string for ReGui rich text rendering.
---@param xml string The XML text to color
---@param theme ReGui.XMLColorful.Theme? The theme to use for coloring
---@return string coloredXML The color-prefixed string
function sm.regui.xmlcolorful.colorXML(xml, theme) end

---Utility functions for sm.regui
sm.regui.utils = {}

---Creates a translator function for use with `TextManager` in `GuiInterface`.
---
---The translator reads from a JSON file at:
---`$CONTENT_DATA/Gui/Languages/<CurrentLanguage>/<fileName>.json`
---
---The JSON file must be a flat key-value object, where each key is a translation key and
---each value is the translated string. Missing files or unknown keys fall back to returning
---the key itself.
---
---**JSON format**
---```jsonc
---{
---    "greeting":        "Hello, World!",
---    "welcome_user":    "Welcome, %s!",        // %s is replaced by the first argument
---    "items_in_bag":    "%s has %d item(s).",  // multiple placeholders are supported
---}
---```
---
---**Example Usage**
---```lua
---local translator = sm.regui.utils.createTranslatorJSONFile("mymod_translations")
---
---translator("greeting")                      -- "Hello, World!"
---translator("welcome_user", "Alice")         -- "Welcome, Alice!"
---translator("items_in_bag", "Alice", 3)      -- "Alice has 3 item(s)."
---translator("unknown_key")                   -- "unknown_key"  (fallback)
---
----- You also can use it directly with TextManager:
---guiInterface:getTextManager():setTranslator(translator)
---```
---
---Additional arguments are forwarded to `string.format`, so any format specifiers
---supported by Lua's `string.format` (`%s`, `%d`, `%f`, etc.) can be used in values.
---@param fileName string The name of the JSON file (without path, with `.json` extension)
---@return fun(key: string, ...: any): string translator
function sm.regui.utils.createTranslatorJSONFile(fileName) end

--- CLASSES ---

---A interface for creating and managing GUIs with sm.regui
---@class ReGui.GuiInterface
local GuiInterface = {}

---Returns the attached TextManager of this GUIInterface.
---@return ReGui.TextManager textManager The attached TextManager.
function GuiInterface:getTextManager() end

---Renders the GUIInterface into a valid MyGUI layout file.
---@param prettify boolean? Whether the output should be as small as possible or be readable for the user. Defaults to minimal.
---@return string output The produced output.
function GuiInterface:render(prettify) end

---Opens the GuiInterface.
function GuiInterface:open() end

---Closes the GuiInterface
function GuiInterface:close() end

---Destroys the GUIInterface (behaves same as close but also removes all "commands")
function GuiInterface:destroy() end

---Checks if the GuiInterface is currently open/active or not.
---@return boolean isActive True if the GuiInterface is open/active, false otherwise.
function GuiInterface:isActive() end

---Clones the GuiInterface, creating a new instance with the same properties and widgets.
---@return ReGui.GuiInterface clone The cloned GuiInterface
function GuiInterface:clone() end

---Checks if automatic conversion of pixel coordinates to real units is enabled.
---@return boolean enabled True if automatic conversion is enabled, false otherwise.
function GuiInterface:isAutoConversionToRealUnitsEnabled() end

---Toggles whether pixel coordinates should be automatically converted to real units.
---@param value boolean Whether to enable or disable automatic conversion.
function GuiInterface:toggleAutomaticConversionToRealUnits(value) end

---Gets current GUIInterface settings
---@return ReGui.GuiSettings settings The current GUIInterface settings.
function GuiInterface:getSettings() end

---Sets current GUIInterface settings
---@param settings ReGui.GuiSettings The new settings to apply.
function GuiInterface:setSettings(settings) end

---Finds a widget by name.
---@param widgetName string The name of the widget to find.
---@param recursive boolean Whether to search recursively through child widgets. Defaults to false.
---@return ReGui.Widget? widget The found widget, or nil if not found.
function GuiInterface:findWidget(widgetName, recursive) end

---Gets the root widgets of this GUIInterface.
---@return ReGui.Widget[] rootWidgets A list of root widgets.
function GuiInterface:getRootWidgets() end

---Creates a widget and adds it to the GUIInterface.
---@param name string The name of the widget to create.
---@param type ReGui.WidgetType The type of the widget to create.
---@param skin ReGui.SkinType The skin of the widget to create.
---@return ReGui.Widget widget The created widget.
function GuiInterface:createWidget(name, type, skin) end

---Sets the text of a widget.
---@param widgetName string The name of the widget.
---@param ... any The text to set. Arguments are passed into TextManager's translator if available, and then formatted into a string.
function GuiInterface:setText(widgetName, ...) end

---Gets the text of a widget.
---@param widgetName string The name of the widget.
---@return string text The text of the widget.
function GuiInterface:getText(widgetName) end

---Adds an item to a grid  
---@param gridName string The name of the grid
---@param item table The item
function GuiInterface:addGridItem(gridName, item) end

---Adds items to a grid from json  
---@param gridName string The name of the grid
---@param jsonPath string Json file path
---@param additionalData? table Additional data to the json (Optional)
function GuiInterface:addGridItemsFromFile(gridName, jsonPath, additionalData) end

---*Client only*
---@param uuid Uuid The uuid of the item
---@param difference integer Amount of items
function GuiInterface:addToPickupDisplay( uuid, difference ) end

---Appends an item to a list  
---@param listName string The name of the list
---@param itemName string The name of the item
---@param data table Table of data to store
function GuiInterface:addListItem(listName, itemName, data) end

---Clears a grid  
---@param gridName string The name of the grid to clear
function GuiInterface:clearGrid(gridName) end

---Clears a list  
---@param listName string The name of the list
function GuiInterface:clearList(listName) end

---Creates a dropdown at the specified widget  
---@param widgetName string The name of the widget
---@param functionName string The name of the function
---@param options table The options in the dropdown menu
function GuiInterface:createDropDown(widgetName, functionName, options) end

---Creats a grid from a table/json  
---@param gridName string The name of the grid
---@param index table Grid data table { type=string, layout=string, itemWidth=integer, itemHeight=integer, itemCount=integer }
function GuiInterface:createGridFromJson(gridName, index) end

---Creates a slider at the specified widget  
---@param widgetName string The name of the widget
---@param range number The range of the slider
---@param value number The start value on the slider
---@param functionName string Slider change callback function name
---@param numbered? boolean Enable numbered steps (Defaults to false)
function GuiInterface:createHorizontalSlider(widgetName, range, value, functionName, numbered) end

---Creates a slider at the specified widget  
---@param widgetName string The name of the widget
---@param range number The range of the slider
---@param value number The start value on the slider
---@param functionName string Slider change callback function name
function GuiInterface:createVerticalSlider(widgetName, range, value, functionName) end

---Plays an effect at a widget  
---@param widgetName string The name of the widget
---@param effectName string The name of the effect
---@param restart? boolean If the effect should restart if its already palying
function GuiInterface:playEffect(widgetName, effectName, restart) end

---Plays an effect at widget inside a grid  
---@param gridName string The name of the grid
---@param index integer The index in the grid
---@param effectName string The name of the effect
---@param restart? boolean If the effect should restart if its already palying
function GuiInterface:playGridEffect(gridName, index, effectName, restart) end

---Sets a button callback to be called when the button is pressed  
---@param buttonName string The button name
---@param callback string Function to be called when button is pressed
function GuiInterface:setButtonCallback(buttonName, callback) end

---Sets the button state  
---@param buttonName string The name of the button
---@param state boolean The state of the button
function GuiInterface:setButtonState(buttonName, state) end

---Sets the color of a widget  
---@param widgetName string The name of the widget
---@param Color Color The color
function GuiInterface:setColor(widgetName, Color) end

---Sets a container to a grid  
---@param gridName string The name of the grid
---@param container Container The container
function GuiInterface:setContainer(gridName, container) end

---Sets multiple containers to a grid  
---@param gridName string The name of the grid
---@param containers table Table of containers. {[Container], ..}
function GuiInterface:setContainers(gridName, containers) end

---Sets data to a widget  
---@param widgetName string The name of the widget
---@param data table The data
function GuiInterface:setData(widgetName, data) end

---Sets the fade range for a world gui  
---@param range number The fade range
function GuiInterface:setFadeRange(range) end

---Sets a widget to recieve key focus  
---@param widgetName string The name of the widget that needs focus
function GuiInterface:setFocus(widgetName) end

---Sets a callback to be called when a button inside a grid is pressed  
---@param buttonName string The button name
---@param callback string Function to be called when button is pressed
function GuiInterface:setGridButtonCallback(buttonName, callback) end

---Sets an item in a grid  
---@param gridName string The name of the grid
---@param index integer The item index
---@param item? table The item
function GuiInterface:setGridItem(gridName, index, item) end

---Sets a callback to be called when a grid item is changed  
---@param gridName string The grid name
---@param callback string Function to be called when button is pressed
function GuiInterface:setGridItemChangedCallback(gridName, callback) end

---Sets a callback to be called when a grid widget gets mouse focus  
---@param buttonName string The button name
---@param callback string Function to be called when button is pressed
function GuiInterface:setGridMouseFocusCallback(buttonName, callback) end

---Sets the size of a grid  
---@param gridName string The name of the grid
---@param index integer The size
function GuiInterface:setGridSize(gridName, index) end

---Sets a [Character|Shape] as host for a world gui  
---@param object Character|Shape The object to host the gui
---@param joint? string The joint (Optional)
function GuiInterface:setHost(object, joint) end

---Sets the icon image to a shape from an uuid  
---@param itembox string The name of the itembox
---@param uuid Uuid The item uuid
function GuiInterface:setIconImage(itembox, uuid) end

---Sets the image of an imagebox  
---@param imagebox string The name of the imagebox widget
---@param image string The name or path of the image
function GuiInterface:setImage(imagebox, image) end

---Sets the resource, group and item name on an imagebox widget  
---@param imagebox string The name of the imagebox
---@param itemResource string The item resource 
---@param itemGroup string The item group
---@param itemName string The item name
function GuiInterface:setItemIcon(imagebox, itemResource, itemGroup, itemName) end

---Sets a callback to be called when a list selection is changed  
---@param listName string The list name
---@param callback string Function to be called when list is selected
function GuiInterface:setListSelectionCallback(listName, callback) end

---Sets the maximum render distance for a world gui  
---@param distance number The max render distance
function GuiInterface:setMaxRenderDistance(distance) end

---Sets a mesh preview to display an item from uuid  
---@param widgetName string The name of the widget
---@param uuid Uuid The item uuid to display
function GuiInterface:setMeshPreview(widgetName, uuid) end

---Sets a callback to be called when the gui is closed  
---@param callback string Function to be called when gui is closed
function GuiInterface:setOnCloseCallback(callback) end

---Sets if a world gui requires line of sight to be shown  
---@param required boolean True if gui requires line of sight to render
function GuiInterface:setRequireLineOfSight(required) end

---Sets the selected item in a dropdown widget
---@param widget string The dropdown widget
---@param item string The item to be selected in the dropdown
function GuiInterface:setSelectedDropDownItem(widget, item) end

---Selects an item in a list  
---@param listName string The name of the list
---@param itemName string The name of the item
function GuiInterface:setSelectedListItem(listName, itemName) end

---Sets a callback to be called when the slider is moved  
---@param sliderName string The button name
---@param callback string Function to be called when slider is moved
function GuiInterface:setSliderCallback(sliderName, callback) end

---Sets the position and range of a slider  
---@param sliderName string The name of the slider
---@param range number The slider range
---@param position number The slider position
function GuiInterface:setSliderData(sliderName, range, position) end

---Sets the position of a slider  
---@param sliderName string The name of the slider
---@param position integer The slider position
function GuiInterface:setSliderPosition(sliderName, position) end

---Sets the slider range of a slider.  
---@param sliderName string The name of the slider
---@param range integer The slider range
function GuiInterface:setSliderRange(sliderName, range) end

---Sets the range limit of a slider  
---@param sliderName string The name of the slider
---@param limit integer The slider range limit
function GuiInterface:setSliderRangeLimit(sliderName, limit) end

---Sets a callback to be called when the text change is accepted  
---@param editBoxName string The edit box name
---@param callback string Function to be called when text is committed
function GuiInterface:setTextAcceptedCallback(editBoxName, callback) end

---Sets a callback to be called when the text is changed  
---@param editBoxName string The edit box name
---@param callback string Function to be called when text is edited
function GuiInterface:setTextChangedCallback(editBoxName, callback) end

---Sets a widget to be visible or not  
---@param widgetName string The name of the widget
---@param visible boolean True if visible
function GuiInterface:setVisible(widgetName, visible) end

---Sets the world position for a world gui  
---@param position Vec3 The world position of the interface
---@param world? World The world, defaults to same as the script
function GuiInterface:setWorldPosition(position, world) end

---Stops an effect playing at a widget  
---@param widgetName string The name of the widget
---@param effectName string The name of the effect
---@param immediate? boolean When true, the effect stops immediately (Defaults to false)
function GuiInterface:stopEffect(widgetName, effectName, immediate) end

---Stopts an effect playing inside a grid  
---@param gridName string The name of the grid
---@param index integer The index in the grid
---@param effectName string The name of the effect
function GuiInterface:stopGridEffect(gridName, index, effectName) end

---Adds a quest to the quest tracker  
---@param name string The name of quest
---@param title string The quest title to be displayed in the tracker
---@param mainQuest boolean If the quest is a main quest (Displayed on top in the tracker)
---@param questTasks table The table of quest tasks to display in the log Task{ name = string, text = string, count = number, target = number, complete = boolean }
function GuiInterface:trackQuest(name, title, mainQuest, questTasks) end

---Removes a quest from the quest tracker  
---@param questName string The name of quest
function GuiInterface:untrackQuest(questName) end

---A parsed widget in the GUI tree.
---@class ReGui.Widget
local Widget = {}

---Clones this widget and returns the new instance.
---@return ReGui.Widget clone The cloned widget.
function Widget:clone() end

---Deletes this widget, removing it from the GUI tree and freeing associated resources.
function Widget:destroy() end

---Creates a child widget under this widget.
---@param name string The name of the child widget.
---@param type ReGui.WidgetType? The type of the child widget. Defaults to "Widget".
---@param skin ReGui.SkinType? The skin of the child widget. Defaults to "PanelEmpty".
---@return ReGui.Widget child The created child widget.
function Widget:createWidget(name, type, skin) end

---Creates a child widget under this widget. Alias for createWidget.
---@param name string The name of the child widget.
---@param type ReGui.WidgetType? The type of the child widget. Defaults to "Widget".
---@param skin ReGui.SkinType? The skin of the child widget. Defaults to "PanelEmpty".
---@return ReGui.Widget child The created child widget.
function Widget:addWidget(name, type, skin) end

---Gets a user-string value by key.
---@param key string The user-string key to read.
---@return string? value The value for the key, or nil if the key does not exist.
function Widget:getUserString(key) end

---Sets a user-string value.
---@param key string The user-string key to write.
---@param value string The value to assign.
function Widget:setUserString(key, value) end

---Gets all user-string keys in this widget.
---@return string[] keys A list of all user-string keys.
function Widget:getAllUserStringKeys() end

---Gets a node-property value by key.
---@param key string The node-property key to read.
---@return string? value The value for the key, or nil if the key does not exist.
function Widget:getNodeProperty(key) end

---Sets a node-property value. The keys "name", "type", "skin", "position", and "position_real" are reserved and cannot be set.
---@param key string The node-property key to write.
---@param value string The value to assign.
function Widget:setNodeProperty(key, value) end

---Gets all node-property keys in this widget.
---@return string[] keys A list of all node-property keys.
function Widget:getAllNodePropertyKeys() end

---Gets a property value by key.
---@param key string The property key to read.
---@return string? value The value for the key, or nil if the key does not exist.
function Widget:getProperty(key) end

---Sets a property value. The keys "Caption", "Image", "Color", "FontName", and "TextAlign" are reserved and cannot be set.
---@param key string The property key to write.
---@param value string The value to assign.
function Widget:setProperty(key, value) end

---Gets all property keys in this widget.
---@return string[] keys A list of all property keys.
function Widget:getAllPropertyKeys() end

---Gets the parent widget.
---@return ReGui.Widget? parent The parent widget, or nil if this is a root widget.
function Widget:getParent() end

---Sets the parent widget. Pass nil to detach this widget from its current parent.
---@param parent ReGui.Widget? The new parent widget, or nil to detach.
function Widget:setParent(parent) end

---Gets the GUI interface that owns this widget.
---@return ReGui.GuiInterface? guiInterface The owning GUI interface, or nil if detached.
function Widget:getGUIInterface() end

---Sets the GUI interface for this widget and its entire subtree.
---@param guiInterface ReGui.GuiInterface? The GUI interface to assign, or nil to clear.
function Widget:setGUIInterface(guiInterface) end

---Gets the name of this widget.
---@return string name The name of this widget.
function Widget:getName() end

---Gets the skin of this widget.
---@return ReGui.SkinType skin The skin of this widget.
function Widget:getSkin() end

---Gets the type of this widget.
---@return ReGui.WidgetType type The type of this widget.
function Widget:getType() end

---Sets the name of this widget.
---@param name string The new name for this widget.
function Widget:setName(name) end

---Sets the skin of this widget.
---@param skin ReGui.SkinType The new skin for this widget.
function Widget:setSkin(skin) end

---Sets the type of this widget.
---@param type ReGui.WidgetType The new type for this widget.
function Widget:setType(type) end

---Finds a child widget by name.
---@param name string The name of the child widget to find.
---@param recursive boolean? Whether to search recursively through descendants. Defaults to false.
---@return ReGui.Widget? widget The found child widget, or nil if not found.
function Widget:findWidget(name, recursive) end

---Gets the direct children of this widget.
---@return ReGui.Widget[] children A list of direct child widgets.
function Widget:getChildren() end

---Gets the coordinate mode currently used to store this widget's position and size.
---@return ReGui.CoordinateMode mode The current coordinate mode.
function Widget:getCoordinateMode() end

---Sets the coordinate mode, converting the stored position and size values into the new unit system.
---@param mode ReGui.CoordinateMode The new coordinate mode.
function Widget:setCoordinateMode(mode) end

---Gets the position of this widget in pixels.
---If the widget is stored in real units, the value is converted on-the-fly using the parent (or screen) size.
---@return integer x The x-coordinate in pixels.
---@return integer y The y-coordinate in pixels.
function Widget:getPosition() end

---Gets the size of this widget in pixels.
---If the widget is stored in real units, the value is converted on-the-fly using the parent (or screen) size.
---@return integer width The width in pixels.
---@return integer height The height in pixels.
function Widget:getSize() end

---Sets the position of this widget in pixels and switches the coordinate mode to "Pixels".
---@param x integer The new x-coordinate in pixels.
---@param y integer The new y-coordinate in pixels.
function Widget:setPosition(x, y) end

---Sets the size of this widget in pixels and switches the coordinate mode to "Pixels".
---@param width integer The new width in pixels.
---@param height integer The new height in pixels.
function Widget:setSize(width, height) end

---Gets the position of this widget in real units (0–1 relative to parent or screen).
---If the widget is stored in pixels, the value is converted on-the-fly using the parent (or screen) size.
---@return number x The x-coordinate in real units.
---@return number y The y-coordinate in real units.
function Widget:getPositionReal() end

---Gets the size of this widget in real units (0–1 relative to parent or screen).
---If the widget is stored in pixels, the value is converted on-the-fly using the parent (or screen) size.
---@return number width The width in real units.
---@return number height The height in real units.
function Widget:getSizeReal() end

---Sets the position of this widget in real units and switches the coordinate mode to "Real".
---@param x number The new x-coordinate in real units.
---@param y number The new y-coordinate in real units.
function Widget:setPositionReal(x, y) end

---Sets the size of this widget in real units and switches the coordinate mode to "Real".
---@param width number The new width in real units.
---@param height number The new height in real units.
function Widget:setSizeReal(width, height) end

---Sets the font name for this widget. Pass nil to clear the font.
---@param fontName ReGui.FontName? The new font name, or nil to clear.
function Widget:setFontName(fontName) end

---Gets the font name for this widget. Returns "DeJaVuSans" if no font is set.
---@return ReGui.FontName fontName The current font name.
function Widget:getFontName() end

---Sets the text alignment for this widget. Pass nil to clear the alignment.
---@param alignment ReGui.TextAlign? The new text alignment, or nil to clear.
function Widget:setTextAlign(alignment) end

---Gets the text alignment for this widget. Returns "[DEFAULT]" if no alignment is set.
---@return ReGui.TextAlign alignment The current text alignment.
function Widget:getTextAlign() end

---Gets the text content of this widget.
---@return string? text The text content, or nil if not set.
function Widget:getText() end

---Sets the text content of this widget. If the widget is attached to an active GUI interface, the text is applied immediately (with translation if enabled). Pass nil to clear the text.
---@param text string? The new text content, or nil to clear.
function Widget:setText(text) end

---Returns whether translation is enabled for this widget's text content.
---@return boolean isEnabled True if translation is enabled, false otherwise.
function Widget:isTranslationEnabled() end

---Sets whether text set via setText should be passed through the GUI interface's text manager for translation before being applied.
---@param enabled boolean True to enable translation, false to disable.
function Widget:setTranslationEnabled(enabled) end

---Renders this widget and its children into a MyGUI layout XML fragment.
---@param indentationLevel number? The base indentation level for pretty rendering. Defaults to 0.
---@param prettify boolean? Whether to render with indentation and line breaks. Defaults to false.
---@return string output The rendered XML fragment for this widget and its subtree.
function Widget:renderWidget(indentationLevel, prettify) end

---Manages text for proper updating & translation
---@class ReGui.TextManager
local TextManager = {}

---Clones the TextManager, creating a new instance with the same properties.
---@return ReGui.TextManager clone The cloned TextManager
function TextManager:clone() end

---Gets the translation function currently set.
---@return fun(...: any): string
function TextManager:getTranslationFunction() end

---Sets the translation function to use for translating text keys.
---@param translationFunction fun(...: any): string The function to use for translating text keys.
function TextManager:setTranslationFunction(translationFunction) end

---Translates a text key using the current translation function.
---@param ... any The arguments to pass to the translation function.
---@return string translation The translated text.
function TextManager:translateText(...) end

---FullscreenInterface is a custom class that allows you to place widgets anywhere aswell as align entire gui interfaces to
---the sides of the screen. Awesome for wide-screen gui's and HUD UI
---@class ReGui.FullscreenInterface
local FullscreenInterface = {}

---Gets the GUIInterface associated with this FullscreenInterface.
---@return ReGui.GuiInterface guiInterface The associated GUIInterface.
function FullscreenInterface:getGuiInterface() end

---Gets the current alignment of this FullscreenInterface. This determines where the interface is anchored on the screen aswel as its size.
---Note that anything that changes size will be ignored if theres a AspectRatio set, as the aspect ratio will always be maintained.
---@return ReGui.WidgetAlignmentType alignment The current alignment of the FullscreenInterface.
function FullscreenInterface:getAlignment() end

---Sets the alignment of this FullscreenInterface. This determines where the interface is anchored on the screen as well as its size.
---Note that anything that changes size will be ignored if theres a AspectRatio set, as the aspect ratio will always be maintained.
---@param alignment ReGui.WidgetAlignmentType The new alignment to set.
function FullscreenInterface:setAlignment(alignment) end

---Enables/disables whether a aspect ratio should be maintained for this FullscreenInterface. When enabled, the interface will maintain its aspect ratio regardless of screen size or resolution.
---@param enabled boolean True to enable aspect ratio maintenance, false to disable.
function FullscreenInterface:setMaintainAspectRatio(enabled) end

---Returns true if theres a aspect ratio applied
---@return boolean enabled True if aspect ratio is enabled, false otherwise.
function FullscreenInterface:isAspectRatioEnabled() end

---Sets the values for aspect ratio.
---@param width number The width of the aspect ratio.
---@param height number The height of the aspect ratio.
function FullscreenInterface:setAspectRatioValues(width, height) end

---Gets the current aspect ratio values.
---@return number width The width of the aspect ratio.
---@return number height The height of the aspect ratio.
function FullscreenInterface:getAspectRatioValues() end

---Sets the size constraints for this FullscreenInterface. This allows you to set a minimum and maximum size for the interface, which will be
---clamped when the screen is resized. Useful to not make the GUI too big or too small.
---@param minWidth integer? The minimum width of the interface. Pass nil to not set a minimum width.
---@param minHeight integer? The minimum height of the interface. Pass nil to not set a minimum height.
---@param maxWidth integer? The maximum width of the interface. Pass nil to not set a maximum width.
---@param maxHeight integer? The maximum height of the interface. Pass nil to not set a maximum height.
function FullscreenInterface:setSizeConstraints(minWidth, minHeight, maxWidth, maxHeight) end

---Gets the current size constraints for this FullscreenInterface.
---@return integer? minWidth The minimum width of the interface, or nil if not set.
---@return integer? minHeight The minimum height of the interface, or nil if not set.
---@return integer? maxWidth The maximum width of the interface, or nil if not set.
---@return integer? maxHeight The maximum height of the interface, or nil if not set.
function FullscreenInterface:getSizeConstraints() end

---Gets the root widget of this FullscreenInterface.
---@return ReGui.Widget rootWidget The root widget of the FullscreenInterface.
function FullscreenInterface:getRootWidget() end

---Updates the FullscreenInterface, applying any changes to alignment, aspect ratio, or size constraints.
---Call this every time you want the GUIInterface to open.
function FullscreenInterface:update() end