---@diagnostic disable

---MyGui widget types
---@alias Regui.WidgetType 
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
---| SM_HeaderXLarge_Wide              |   FSize   60      |   Tracking   1.33   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzBCGHJKLQWXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| SM_HeaderLarge_Wide               |   FSize   40      |   Tracking   6.67   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   jqzQ`-=[];~+{}|:<>@#$%^&*()
---| SM_HeaderLarge_Medium             |   FSize   40      |   Tracking   2.67   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   jqzQ`-=[];~+{}|:<>@#$%^&*()
---| SM_HeaderLarge_Narrow             |   FSize   40      |   Tracking   0.67   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   jqzQ`-=[];~+{}|:<>@#$%^&*()
---| SM_HeaderMedium                   |   FSize   30      |   Tracking   2      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzFJKPQVXZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| SM_SubHeader                      |   FSize   25      |   Tracking   3      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_Header                         |   FSize   22.50   |   Tracking   1.33   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_HeaderSmall                    |   FSize   20      |   Tracking   1.33   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   dgjqxyzJQ`=\;',./~_+{}|"<>?@#$%^&*()
---| SM_HeaderTiny                     |   FSize   17.50   |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_Tab                            |   FSize   22.50   |   Tracking   1.33   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_TabSmall                       |   FSize   20      |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_TextLabel                      |   FSize   22.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_Label                          |   FSize   22.50   |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_LabelSmall                     |   FSize   20      |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_LabelTiny                      |   FSize   17.50   |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_LabelMini                      |   FSize   15      |   Tracking   0.67   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzBFGHJKMNPQUXYZ`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| SM_SliderLabel                    |   FSize   12.50   |   Tracking   0.67   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzBCDEGHJKNPQRUVYZ`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| SM_SearchText                     |   FSize   25      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_ToolTipText                    |   FSize   20      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_TextLarge                      |   FSize   30      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   qxEHJKLNOPRVWX0123456789`-=[]\;'/~_{}|"<>?@#$%^&*()
---| SM_Text                           |   FSize   25      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl   X   |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_TextDesc                       |   FSize   30      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   bdfgijkmquvxyzABCDEFGHIJKLMNOPQRTUVWXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| SM_TextSmall                      |   FSize   20      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl   X   |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_TextTiny                       |   FSize   17.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl   X   |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_ItemTitle                      |   FSize   27.50   |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_GameName                       |   FSize   27.50   |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_ButtonLarge                    |   FSize   32.50   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzDJQVWYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| SM_Button                         |   FSize   25      |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_ButtonSmall                    |   FSize   20      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   dgjqxyzJQ`=\;',./~_+{}|"<>?@#$%^&*()
---| SM_ButtonTiny                     |   FSize   17.50   |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_ButtonSmallBold                |   FSize   20      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_NumberHuge                     |   FSize   52.50   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`-=[]\;',./~_+{}|"<>?!@#$%^&*()
---| SM_NumberSmall                    |   FSize   20      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   dgjqxyzJQ`=\;',./~_+{}|"<>?@#$%^&*()
---| SM_NumberTiny                     |   FSize   17.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_NumberMini                     |   FSize   15      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYZ`-=[]\;',.~_+{}|:"<>?!@#$%^&()
---| SM_UserName                       |   FSize   20      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_ListItem                       |   FSize   22.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_HotbarBinding                  |   FSize   16.25   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_IntlText                       |   FSize   45      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl   X   |   All Chars:   PARTIAL   |   Missing en-US:   None
---| SM_Digital                        |   FSize   45      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`-=[]\;',./~_+{}|"<>?!@#$%^&*()
---| X_Interactable_Timer_TimeUnit     |   FSize   37.50   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLNOPQRTUVWXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| X_Interactable_Timer_TickCount    |   FSize   27.50   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzABDEFGHJLMNOPQRUVWXYZ`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| X_Interactable_LogicGate_Category |   FSize   27.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| X_MenuGamemodeMenu_GameMode       |   FSize   62.50   |   Tracking   3.33   |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzBDFJKMOPQWXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| X_Hud_Alert                       |   FSize   30      |   Tracking   0.67   |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| X_Hud_Interaction                 |   FSize   25      |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| X_Hud_PlayerName                  |   FSize   27.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| X_Hud_ItemStack                   |   FSize   27.50   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   None
---| HandbookTitle                     |   FSize   13.33   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzJKXZ0123456789`-=[]\;,./~_+{}|:"<>?!@#$%^&*() 
---| HandbookSubTitle                  |   FSize   30      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   DGJKOVXZ01246789`=[]\;/~_{}|:<>!@#$%^*
---| HandbookSubTitleItalic            |   FSize   30      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   jqzABCDFGHIJKMNOPQRSUVWXYZ0123456789`-=[]\;/~_+{}|:"<>?@#$%^&*()
---| HandbookPageCount                 |   FSize   40      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`-=[]\;',.~_+{}|:"<>?!@#$%^&*()
---| HandbookDescriptionLarge          |   FSize   23.33   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   jxDEFGHJKLMNOQRUVWXYZ0123456789`-=[]\;'/~_+{}|:"<>?!@#$%^&*()
---| HandbookDescriptionSmall          |   FSize   20      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   DGIJKLMNORVXZ0123456789`=[]\;'/~_+{}|"<>?@#$%^&*()
---| HandbookInstructionLarge          |   FSize   41.67   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   dfghjpqwxzADEFGJKLMNOQRSTUVWXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| HandbookInstructionMedium         |   FSize   28.33   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   fqwxyzBEFGKNQTUVWXYZ0123456789`-=[]\;',.~_+{}|:"<>?!@#$%^&*()
---| HandbookInstructionSmall          |   FSize   25      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   qvxzEFGIJMNOQUVXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| HandbookLogicDescription          |   FSize   13.33   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   bjmpquwxzBCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`-=[]\;',./~_+{}|:"<>?!@#$%^&*()
---| HandbookFAQQuestion               |   FSize   26.67   |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   jkqxzABCDEFGJKLNPQRSTUVXYZ0123456789`-=[]\;'./~_+{}|:"<>@#$%^&*()
---| HandbookFAQAnswer                 |   FSize   30      |   Tracking   0      |   en-US       |   Latn       |   Cyrl       |   All Chars:   PARTIAL   |   Missing en-US:   DGJKOVXZ01246789`=[]\;/~_{}|:<>!@#$%^*
---| DeJaVuSans                        |   FSize   18.75   |   Tracking   0      |   en-US   X   |   Latn   X   |   Cyrl   X   |   All Chars:   FULL      |   Missing en-US:   None

---sm.regui, ReDoing Graphical User Interfaces
sm.regui = {}

---Creates a GUI from a layout file
---@param path string The path to the layout file
---@return ReGui.GuiInterface guiinterface The created GUI object
function sm.regui.createGuiFromLayout(path) end

---Creates an empty GUI
---@return ReGui.GuiInterface guiinterface The created GUI object
function sm.regui.createGui() end

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

--- CLASSES ---

---A interface for creating and managing GUIs with sm.regui
---@class ReGui.GuiInterface
local GuiInterface = {}

---Renders the GUIInterface into a valid MyGUI layout file.
---@param prettify boolean? Whether the output should be as small as possible or be readable for the user. Defaults to minimal.
---@return string output The produced output.
function GuiInterface:render(prettify) end

---Opens the GuiInterface.
function GuiInterface:open() end

---Closes the GuiInterface
function GuiInterface:close() end

---Clones the GuiInterface, creating a new instance with the same properties and widgets.
---@return ReGui.GuiInterface clone The cloned GuiInterface
function GuiInterface:clone() end

---Checks if automatic conversion of pixel coordinates to real units is enabled.
---@return boolean enabled True if automatic conversion is enabled, false otherwise.
function GuiInterface:isAutoConversionToRealUnitsEnabled() end

---Toggles whether pixel coordinates should be automatically converted to real units.
---@param value boolean Whether to enable or disable automatic conversion.
function GuiInterface:toggleAutomaticConversionToRealUnits(value) end

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
---@param skin string The skin of the widget to create.
function GuiInterface:createWidget(name, type, skin) end

---A parsed widget in the GUI tree.
---@class ReGui.Widget
local Widget = {}

---Clones this widget and returns the new instance.
---@return ReGui.Widget clone The cloned widget.
function Widget:clone() end

---Deletes this widget, removing it from the GUI tree and freeing associated resources.
function Widget:destroy() end

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

---Sets a node-property value.
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

---Sets a property value.
---@param key string The property key to write.
---@param value string The value to assign.
function Widget:setProperty(key, value) end

---Gets all property keys in this widget.
---@return string[] keys A list of all property keys.
function Widget:getAllPropertyKeys() end

---Gets the parent widget.
---@return ReGui.Widget? parent The parent widget, or nil if this is a root widget.
function Widget:getParent() end

---Sets the parent widget.
---@param parent ReGui.Widget? parent The new parent widget, or nil to detach this widget.
function Widget:setParent(parent) end

---Gets the GUI interface that owns this widget.
---@return ReGui.GuiInterface? guiInterface The owning GUI interface, or nil if detached.
function Widget:getGUIInterface() end

---Sets the GUI interface for this widget and its subtree.
---@param guiInterface ReGui.GuiInterface? guiInterface The GUI interface to assign, or nil to clear.
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
---@param widgetName string The name of the child widget to find.
---@param recursive boolean Whether to search recursively through descendants. Defaults to false.
---@return ReGui.Widget? widget The found child widget, or nil if not found.
function Widget:findWidget(widgetName, recursive) end

---Gets the child widgets of this widget.
---@return ReGui.Widget[] childWidgets A list of child widgets.
function Widget:getChildWidgets() end

---Gets the pixel position of this widget.
---@return integer x The x-coordinate of the widget in pixels.
---@return integer y The y-coordinate of the widget in pixels.
function Widget:getPosition() end

---Gets the pixel size of this widget.
---@return integer width The width of the widget in pixels.
---@return integer height The height of the widget in pixels.
function Widget:getSize() end

---Sets the pixel position of this widget.
---@param x integer The new x-coordinate in pixels.
---@param y integer The new y-coordinate in pixels.
function Widget:setPosition(x, y) end

---Sets the pixel size of this widget.
---@param width integer The new width in pixels.
---@param height integer The new height in pixels.
function Widget:setSize(width, height) end

---Gets the real-unit position of this widget.
---@return number x The x-coordinate of the widget in real units.
---@return number y The y-coordinate of the widget in real units.   
function Widget:getPositionReal() end

---Gets the real-unit size of this widget.
---@return number width The width of the widget in real units.
---@return number height The height of the widget in real units.
function Widget:getSizeReal() end

---Sets the real-unit position of this widget.
---@param x number The new x-coordinate in real units.
---@param y number The new y-coordinate in real units.
function Widget:setPositionReal(x, y) end

---Sets the real-unit size of this widget.
---@param width number The new width in real units.
---@param height number The new height in real units.
function Widget:setSizeReal(width, height) end

---Renders this widget and its children into MyGUI layout XML.
---@param indentationLevel number? The base indentation level used for pretty rendering.
---@param prettify boolean? Whether to render with indentation and line breaks.
---@return string output The rendered XML fragment for this widget subtree.
function Widget:renderWidget(indentationLevel, prettify) end