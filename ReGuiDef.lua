-- sm.regui: Main namespace for ReDoing Graphical User Interfaces
-- sm.regui.template: Template manager for reusing GUI layouts
-- sm.regui.font: Utilities for rendering custom font-based text

---sm.regui, ReDoing Graphical User Interfaces
---@diagnostic disable: missing-return
sm.regui = {}

---Creates a new ReGuiInterface from a Relayout file.
---@param path string Path to the .relayout file to load.
---@return ReGuiInterface A new GUI interface instance.
function sm.regui.new( path ) end

---Creates a new blank layout
---@return ReGuiInterface ReGuiInterface
function sm.regui.newBlank() end

-- Fullscreen manager
sm.regui.fullscreen = {}

---A MyGUI Alignment.
---@alias ReGuiInterface.Alignment
---| "Left"
---| "Left VStretch"
---| "Left VCenter"
---| "Right"
---| "Right VStretch"
---| "Right VCenter"
---| "Top"
---| "Top HStretch"
---| "Top HCenter"
---| "Bottom"
---| "Bottom HStretch"
---| "Bottom HCenter"
---| "VCenter"
---| "HCenter"
---| "VStretch"
---| "HStretch"
---| "VCenter HCenter"
---| "VCenter HStretch"
---| "VStretch HCenter"
---| "VStretch HStretch"
---| "Top Left"
---| "Top Right"
---| "Bottom Left"
---| "Bottom Right"
---| "Stretch"
---| "[DEFAULT]"
---| "Default"
---| "Center"

---Creates a new FullscreenGUI instance
---@param guiInterface ReGuiInterface The gui interface to apply it to
---@param hasFixedAspectRatio boolean Wether to fix the aspect ratio of the fullscreen gui to 16:9 or not
---@param alignment ReGuiInterface.Alignment The alignment to use.
---@return ReGuiFullscreenGUI fullscreenGui A Fullscreen gui instance
function sm.regui.fullscreen.createFullscreenGuiFromInterface(guiInterface, hasFixedAspectRatio, alignment) end

-- Template manager
sm.regui.template = {}

---Creates a new template from a Relayout File
---@param path string The path of the relayout file
---@return ReGuiTemplate template The template created from the relayout file
function sm.regui.template.createTemplate(path) end

---Creates a reusable template from an existing ReGuiInterface.
---@param reGuiInterface ReGuiInterface Source interface to generate a template from.
---@return ReGuiTemplate A new template based on the interface.
function sm.regui.template.createTemplateFromInterface(reGuiInterface) end

-- Custom Font Rendering Manager
sm.regui.font = {}

---Adds a new font to the ReGui Library. This font can be used by any mod.
---@param fontName string The name of the font
---@param fontPath string Path to this font. Note that you cannot use $CONTENT_DATA here! (Eg: "$CONTENT_[MOD_UUID]/Gui/Fonts/MyFont")
function sm.regui.font.addFont(fontName, fontPath) end

---Gets all font names that the library has
---@return string[] fontNames All the font names.
function sm.regui.font.getFontNames() end

---Returns true if a font exists
---@param fontName string The name of the font to check
---@return boolean exists If it exists or not.
function sm.regui.font.fontExists(fontName) end

---Gets the fullpath of a font from the fontName
---@param fontName string The name of the font to get it's path
---@return string fontPath The font path.
function sm.regui.font.getFontPath(fontName) end

---Calculates the pixel size the given text would occupy.
---@param text string The text to measure.
---@param fontName string The name of the font to use
---@param fontSize number Font size in pixels.
---@param rotation number Rotation to apply (in degrees).
---@return number width The calculated text width in pixels.
---@return number height The calculated text height in pixels.
function sm.regui.font.calcCustomTextSize(text, fontName, fontSize, rotation) end

---Draws custom text onto a widget. (position being in pixels)
---
-- Renders the specified text at a given position within a widget, using a custom font, size, and rotation
---
---@param widget ReGuiInterface.Widget The widget on which to render the text
---@param position ReGuiCoordinate The position to draw the text
---@param text string The text string to display
---@param fontName string The name of the font to use
---@param fontSize number The size in pixels at which to render the font
---@param rotation number The rotation to apply to the text
function sm.regui.font.drawCustomText(widget, position, text, fontName, fontSize, rotation) end

---Draws custom text onto a widget. (position being in real units)
---
-- Renders the specified text at a given position within a widget, using a custom font, size, and rotation.
---
---@param widget ReGuiInterface.Widget The widget on which to render the text.
---@param position ReGuiCoordinate The position to draw the text.
---@param text string The text string to display.
---@param fontName string The name of the font to use
---@param fontSize number The size in pixels at which to render the font.
---@param rotation number The rotation degrees to apply to the text.
function sm.regui.font.drawCustomTextRealUnits(widget, position, text, fontName, fontSize, rotation) end

---Video player utility
sm.regui.video = {}

---Creates a Player instance
---@param path string Path of the video.
---@param widget ReGuiInterface.Widget The ImageBox to play it on to.
---@return ReGuiVideoPlayer videoPlayer A Video player instance
function sm.regui.video.createPlayer(path, widget) end

---Flexable widget utility (You can center a div with this one easly)
sm.regui.flex = {}

---@alias ReGuiFlexableWidget.JustifyContent "Start"|"Left"|"FlexStart"|"End"|"Right"|"FlexEnd"|"Center"|"SpaceBetween"|"SpacerAround"|"SpaceEvenly"|"Stretch"
---@alias ReGuiFlexableWidget.FlexDirection "Horizontal"|"Vertical"

---Creates a flexable widget
---@param widget ReGuiInterface.Widget The widget to place the flexable widget on.
---@param justifyContent ReGuiFlexableWidget.JustifyContent The content alignment
---@param flexDirection ReGuiFlexableWidget.FlexDirection The direction of the flex widget
---@return ReGuiFlexableWidget flexWidget The created flex widget
function sm.regui.flex.createFlexWidget(widget, justifyContent, flexDirection) end

--- CLASSES --

---A Coordinate class used by ReGui, you can ether define x and y or use [1] and [2]
---@class ReGuiCoordinate
---@field x number?
---@field y number?
---@field [1] number?
---@field [2] number?

---@alias ReGuiPropertyValueType string|number|boolean|nil|table

---A GuiInterface with sm.regui features applied
---@class ReGuiInterface : GuiInterface
local ReGuiInterface = {}

---Sets the position of a widget (using pixels)
---@param widgetName string The name of the widget
---@param position ReGuiCoordinate The position
function ReGuiInterface:setWidgetPosition(widgetName, position) end

---Sets the position of a widget (using real units)
---@param widgetName string The name of the widget
---@param position ReGuiCoordinate The position
function ReGuiInterface:setWidgetPositionRealUnits(widgetName, position) end

---Sets the size of a widget (using pixels)
---@param widgetName string The name of the widget
---@param size ReGuiCoordinate The size
function ReGuiInterface:setWidgetSize(widgetName, size) end

---Sets the size of a widget (using real units)
---@param widgetName string The name of the widget
---@param size ReGuiCoordinate The size
function ReGuiInterface:setWidgetSizeRealUnits(widgetName, size) end

---Sets a property of a widget
---@param widgetName string The name of the widget
---@param index string The index
---@param value ReGuiPropertyValueType The value to set
function ReGuiInterface:setWidgetProperty(widgetName, index, value) end

---Gets a property of a widget
---@param widgetName string The name of the widget
---@param index string The index
---@return ReGuiPropertyValueType value The value of the property
function ReGuiInterface:getWidgetProperty(widgetName, index) end

---Sets multiple properties to a widget
---@param widgetName string The name of the widget
---@param data table<string, ReGuiPropertyValueType> The properties to set.
function ReGuiInterface:setWidgetProperties(widgetName, data) end

---Gets all properties of a widget
---@param widgetName string The name of the widget
---@return table<string, ReGuiPropertyValueType> data The properties of the widget
function ReGuiInterface:getWidgetProperties(widgetName) end

---Returns true if a widget exists by their name
---@param widgetName string The name of the widget
---@return boolean exists Whether the widget exists or not
function ReGuiInterface:widgetExists(widgetName) end

---Finds a widget recursively
---@param widgetName string The name of the widget
---@return ReGuiInterface.Widget? widget The found widget. nil if not found
function ReGuiInterface:findWidgetRecursive(widgetName) end

---Finds a widget
---@param widgetName string The name of the widget
---@return ReGuiInterface.Widget? widget The found widget. nil if not found
function ReGuiInterface:findWidget(widgetName) end

---Gets all widgets at the root of the GuiInterface
---@return ReGuiInterface.Widget[] widgets All widgets at the root of the gui.
function ReGuiInterface:getRootChildren() end

---Creates a new widget at the root of the interface. It is recommended that you NOT create a widget
---with a name already in use of the interface! Using a already-in use name will cause issues with
---the game and the library!
---@param widgetName string The name of the widget
---@param widgetType string? The type of widget to create (NOT the instance) (Defaults to "Widget")
---@param skin string? The skin to use for this widget. (Defaults to "PanelEmpty")
---@return ReGuiInterface.Widget widget The created widget
function ReGuiInterface:createWidget(widgetName, widgetType, skin) end

---Returns the settings of the GuiInterface itself.
---@return GuiSettings settings The settings that would be applied to the layout.
function ReGuiInterface:getSettings() end

---Overwrites the current settings with the new one
---@param settings GuiSettings The new settings
function ReGuiInterface:setSettings(settings) end

---Sets the global text translation function (useful for internationalization).
---
---The function will be used by all widgets when setting or refreshing text.
---See the GitHub documentation for advanced usage and examples.
---@param translatorFunction fun(...: any): string The translation callback function.
function ReGuiInterface:setTextTranslation(translatorFunction) end

---Sets the widget's text, passing all additional arguments through the translator function.
---@param widgetName string The name of the widget
---@param ... any The arguments to set the text
function ReGuiInterface:setText(widgetName, ...) end

---Gets the translated text of a widget.
---@param widgetName string Name of the widget.
---@return string? text The translated widget text, or nil if unset.
function ReGuiInterface:getText(widgetName) end

---Reruns all text through the translation function. Use this when the language changes.
function ReGuiInterface:refreshTranslations() end

---Sets data to a widget. This is the same as doing setWidgetProperties
---@param widgetName string The name of the widget
---@param data table<string, ReGuiPropertyValueType> The properties to set.
function ReGuiInterface:setData(widgetName, data) end

---Sets data to a widget. This is the same as doing getWidgetProperties
---@param widgetName string The name of the widget
---@return table<string, ReGuiPropertyValueType> data The received properties
function ReGuiInterface:getData(widgetName) end


---A widget in a ReGuiInterface
---@class ReGuiInterface.Widget
local ReGuiInterfaceWidget = {}

---Gets the GUI that contains this widget. Nil if it isnt assigned to one
---@return ReGuiInterface? reGuiInterface The interface
function ReGuiInterfaceWidget:getGui() end

---Sets the image of this widget
---@param path string The image to set it to. ($CONTENT_DATA wont work here)
function ReGuiInterfaceWidget:setImage(path) end

---Sets whether this widget is where the contents of other GuiInterfaces should go
---when using a TemplateManager.
---@param state boolean True to make this the container for template contents, false to unset it
function ReGuiInterfaceWidget:setLocationForTemplateContents(state) end

---Checks if this widget is set as the container for template contents.
---@return boolean state True if this is the container, false if not
function ReGuiInterfaceWidget:isLocationForTemplateContents() end

---Gets the name of the widget.
---@return string name The name of the widget.
function ReGuiInterfaceWidget:getName() end

---Gets the type of the widget.
---@return string type The type of the widget.
function ReGuiInterfaceWidget:getType() end

---Gets the skin of the widget.
---@return string skin The skin of the widget.
function ReGuiInterfaceWidget:getSkin() end

---Sets the name of the widget.
---@param name string The new name to assign to the widget.
function ReGuiInterfaceWidget:setName(name) end

---Sets the type of the widget.
---@param widgetType string The type to assign to the widget.
function ReGuiInterfaceWidget:setType(widgetType) end

---Sets the skin of the widget.
---@param skin string The skin to apply to the widget.
function ReGuiInterfaceWidget:setSkin(skin) end

---Gets the parent of the widget.
---@return ReGuiInterface.Widget? parent The parent widget or nil if none.
function ReGuiInterfaceWidget:getParent() end

---Sets the parent of the widget.
---@param parent ReGuiInterface.Widget? The new parent widget or nil to set it to the root
function ReGuiInterfaceWidget:setParent(parent) end

---Gets all child widgets of this widget.
---@return ReGuiInterface.Widget[] children A list of child widgets.
function ReGuiInterfaceWidget:getChildren() end

---Gets the pixel position of the widget.
---@return table position A table with `x` and `y` keys in pixels.
function ReGuiInterfaceWidget:getPosition() end

---Gets the position of the widget in real units.
---@return table position A table with `x` and `y` keys in real units.
function ReGuiInterfaceWidget:getPositionRealUnits() end

---Gets the pixel size of the widget.
---@return table size A table with `x` (width) and `y` (height) in pixels.
function ReGuiInterfaceWidget:getSize() end

---Gets the size of the widget in real units.
---@return table size A table with `x` and `y` in real units.
function ReGuiInterfaceWidget:getSizeRealUnits() end

---Sets the properties of the widget in bulk.
---@param data table A key-value table of properties to set.
function ReGuiInterfaceWidget:setProperties(data) end

---Gets the properties of the widget.
---@return table properties A table of current widget properties.
function ReGuiInterfaceWidget:getProperties() end

---Sets an individual widget property.
---@param index string The property name.
---@param value string|number|boolean|table|nil The property value.
function ReGuiInterfaceWidget:setProperty(index, value) end

---Gets an individual widget property.
---@param index string The property name.
---@return ReGuiPropertyValueType value The property value.
function ReGuiInterfaceWidget:getProperty(index) end

---Sets an instance property of the widget.
---@param key string The instance property name.
---@param value string|number|boolean The property value.
function ReGuiInterfaceWidget:setInstanceProperty(key, value) end

---Gets an instance property of the widget.
---@param key string The instance property name.
---@return ReGuiPropertyValueType value The property value.
function ReGuiInterfaceWidget:getInstanceProperty(key) end

---Sets the pixel position of the widget.
---@param position table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setPosition(position) end

---Sets the real unit position of the widget.
---@param position table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setPositionRealUnits(position) end

---Sets the pixel size of the widget.
---@param size table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setSize(size) end

---Sets the size of the widget in real units.
---@param size table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setSizeRealUnits(size) end

---Checks if the widget currently exists in the GUI hierarchy.
---This is useful to know if a widget is used or unused.
---@return boolean exists True if it exists, false if not.
function ReGuiInterfaceWidget:exists() end

---Destroys the widget.
---@return boolean success True if it was removed, false if not found.
function ReGuiInterfaceWidget:destroy() end

---Returns true if this widget has any child widgets.
---@return boolean hasChildren
function ReGuiInterfaceWidget:hasChildren() end

---Creates a new widget inside of this widget It is recommended that you NOT create a widget
---with a name already in use of the interface! Using a already-in use name will cause issues with
---the game and the library!
---@param widgetName string The name of the widget
---@param widgetType string? The type of widget to create (NOT the instance) (Defaults to "Widget")
---@param skin string? The skin to use for this widget. (Defaults to "PanelEmpty")
---@return ReGuiInterface.Widget widget The created widget
function ReGuiInterfaceWidget:createWidget(widgetName, widgetType, skin) end

---Creates a new controller for the widget. Useful for animations
---@param controllerType string Type of controller to create
---@return ReGuiInterface.Controller controller The created controller
function ReGuiInterfaceWidget:createController(controllerType) end

---Finds a controller by type.
---@param controllerType string The type of the controller to find.
---@return ReGuiInterface.Controller controller A controller if found, or nil.
function ReGuiInterfaceWidget:findController(controllerType) end

---Destroys a controller by type.
---@param controllerType string The type of the controller to remove.
---@return boolean success True if found and removed, false otherwise.
function ReGuiInterfaceWidget:destroyController(controllerType) end

---Sets the visibility of the widget.
---@param visible boolean Whether the widget should be visible.
function ReGuiInterfaceWidget:setVisible(visible) end

---Sets the widget’s text/caption.
---@param ... any Arguments passed to the text-setting function.
function ReGuiInterfaceWidget:setText(...) end

---Gets the translated text of the widget.
---@return string? text The currently translated widget text, if any.
function ReGuiInterfaceWidget:getText() end

---Checks if the widget currently exists in the GUI hierarchy.
---@return boolean exists True if it exists, false if not.
function ReGuiInterfaceWidget:exists() end


---A controller for a widget. Useful for animations
---@class ReGuiInterface.Controller
local ReGuiInterfaceController = {}

---Gets the type of the controller.
---@return string type The controller's type.
function ReGuiInterfaceController:getType() end

---Sets the type of the controller.
---@param newType string The new controller type.
function ReGuiInterfaceController:setType(newType) end

---Gets all controller properties.
---@return table properties A table of controller properties.
function ReGuiInterfaceController:getProperties() end

---Sets multiple controller properties at once.
---@param data table A table of key-value property pairs.
function ReGuiInterfaceController:setProperties(data) end

---Sets an individual controller property.
---@param key string The property name.
---@param value ReGuiPropertyValueType The property value.
function ReGuiInterfaceController:setProperty(key, value) end

---Gets an individual controller property.
---@param key string The property name.
---@return ReGuiPropertyValueType value The value of the controller property.
function ReGuiInterfaceController:getProperty(key) end

---Destroys the controller, removing it from the widget.
function ReGuiInterfaceController:destroy() end


---A Fullscreen GUI Instance
---@class ReGuiFullscreenGUI
local ReGuiFullscreenGUI = {}

---Gets the gui interface that FullscreenGUI uses
---@return ReGuiInterface guiInterface The guiInterface
function ReGuiFullscreenGUI:getGui() end

---Gets the alignment of the fullscreengui
---@return ReGuiInterface.Alignment alignment The currently applied alignment
function ReGuiFullscreenGUI:getAlignment() end

---Gets if it has fixed aspect ratio or not.
---@return boolean hasFixedAspectRatio If it has fixed aspect ratio or not
function ReGuiFullscreenGUI:hasFixedAspectRatio() end

---Sets the alignment of the FullscreenGUI
---@param alignment ReGuiInterface.Alignment The alignment to apply
function ReGuiFullscreenGUI:setAlignment(alignment) end

---Sets whether the FullscreenGUI should maintain a fixed aspect ratio
---@param hasFixedAspectRatio boolean Whether to enforce a fixed aspect ratio
function ReGuiFullscreenGUI:setFixedAspectRatio(hasFixedAspectRatio) end

---Updates the position and size of the FullscreenGUI.
function ReGuiFullscreenGUI:update() end


---A template generated from the TemplateManager
---@class ReGuiTemplate
local ReGuiTemplate = {}

---Loads a Relayout file from the specified path and applies this template to it.
---Returns a **new** ReGuiInterface instance with the template applied.
---@param path string The file path to the Relayout definition.
---@return ReGuiInterface ReGuiInterface The resulting GUI interface with the template applied.
function ReGuiTemplate:applyTemplate(path) end

---Creates a new ReGuiInterface by applying this template to a layout file.
---This allows consistent styling or structure across GUIs.
---@param reGuiInterface ReGuiInterface The source GUI interface to base the new one on.
---@return ReGuiInterface reGuiInterface A new GUI interface with the template applied.
function ReGuiTemplate:applyTemplateFromInterface(reGuiInterface) end


---A video player instance that plays videos onto an ImageBox.
---@class ReGuiVideoPlayer
local ReGuiVideoPlayer = {}

---Runs a frame of the video.
---This must be called every tick inside `client_onFixedUpdate` to update the video frame properly.
function ReGuiVideoPlayer:runFrame() end

---Starts or resumes video playback.
function ReGuiVideoPlayer:play() end

---Stops video playback and resets to the beginning.
function ReGuiVideoPlayer:stop() end

---Pauses video playback at the current frame.
function ReGuiVideoPlayer:pause() end

---Returns whether the video is set to loop.
---@return boolean looping True if the video is looping, false otherwise.
function ReGuiVideoPlayer:isLooping() end

---Enables or disables looping for the video.
---@param looping boolean Whether the video should loop when it reaches the end.
function ReGuiVideoPlayer:setLooping(looping) end

---Returns whether the video is currently playing.
---@return boolean playing True if the video is playing, false if it is paused or stopped.
function ReGuiVideoPlayer:isPlaying() end

---Gets the current frame counter of the video.
---@return integer frame The current frame index being displayed.
function ReGuiVideoPlayer:getFrameCounter() end

---Sets the current frame counter of the video.
---@param frame integer The frame index to jump to.
function ReGuiVideoPlayer:setFrameCounter(frame) end

---**NOTE: SM-CustomAudioExtension Only!**
---Gets the current audio name that it would play
---@return string name The name of the audio
function ReGuiVideoPlayer:getAudioName() end

---**NOTE: SM-CustomAudioExtension Only!**
---Sets the current audio name that it would play
---@param name string The name of the audio to set
function ReGuiVideoPlayer:setAudioName(name) end

---**NOTE: SM-CustomAudioExtension Only!**
---Sets a parameter for the audio
---@param index string The name of the parameter
---@param value any The value to set for the parameter
function ReGuiVideoPlayer:setAudioParameter(index, value) end

---**NOTE: SM-CustomAudioExtension Only!**
---Gets a parameter value for the audio
---@param index string The name of the parameter
---@return any value The value of the parameter
function ReGuiVideoPlayer:getAudioParameter(index) end

---**NOTE: SM-CustomAudioExtension Only!**
---Gets all audio parameters
---@return table parameters A table of all audio parameters
function ReGuiVideoPlayer:getAllAudioParameters() end

--- A flexible widget which lets you put aligned widgets, 
---@class ReGuiFlexableWidget
local ReGuiFlexableWidget = {}

---Gets the current justification setting for how child widgets are aligned.
---@return ReGuiFlexableWidget.JustifyContent justifyContent The current justification setting.
function ReGuiFlexableWidget:getJustifyContent() end

---Sets the justification of how child widgets are aligned within the flexible widget.
---@param justifyContent ReGuiFlexableWidget.JustifyContent The justification setting to apply.
function ReGuiFlexableWidget:setJustifyContent(justifyContent) end

---Gets the current flex direction (e.g. row or column) of the widget.
---@return ReGuiFlexableWidget.FlexDirection flexDirection The current flex direction.
function ReGuiFlexableWidget:getFlexDirection() end

---Sets the direction in which child widgets are laid out (e.g. row or column).
---@param flexDirection ReGuiFlexableWidget.FlexDirection The flex direction to set.
function ReGuiFlexableWidget:setFlexDirection(flexDirection) end

---Pushes a widget to the flexible widget's layout stack.
--- 
---NOTE: The widget's parent will be set to the FlexibleWidget!
---
---Note: This method **does** change the widget's parent internally.
---@param widget ReGuiInterface.Widget The widget to push into the flexible layout.
function ReGuiFlexableWidget:pushWidget(widget) end

---Removes a widget from the flexible widget's layout stack.
---
---NOTE: Will not revert to the original parent from when you pushed it, instead it stays in the internal widget of the FlexibleWidget but not affected.
---      You will have to update its parent!
---
---@param widget ReGuiInterface.Widget The widget to remove from the layout.
function ReGuiFlexableWidget:popWidget(widget) end

---Updates the flexible widget, recalculating layout and positions of child widgets.
function ReGuiFlexableWidget:update() end
