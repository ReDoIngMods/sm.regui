---@diagnostic disable: missing-return
sm.regui = {}

---Creates a new ReGuiInterface from a Relayout file
---@param path string The path of the relayout file
---@return ReGuiInterface reGuiInterface The created interface
function sm.regui.new( path ) end

---Creates a new blank layout
---@return ReGuiInterface reGuiInterface
function sm.regui.newBlank() end

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
---@param value any The value to set
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
---@return boolean exists Wether the widget exists or not
function ReGuiInterface:widgetExists(widgetName) end

---Finds a widget recursively
---@param widgetName string The name of the widget
---@return ReguiInterface.Widget? widget The found widget. nil if not found
function ReGuiInterface:findWidgetRecursive(widgetName) end

---Finds a widget
---@param widgetName string The name of the widget
---@return ReguiInterface.Widget? widget The found widget. nil if not found
function ReGuiInterface:findWidget(widgetName) end

---Gets all widgets at the root of the GuiInterface
---@return ReguiInterface.Widget[] widgets All widgets at the root of the gui.
function ReGuiInterface:getRootChildren() end

---Creates a new widget at the root of the interface. It is recommended that you NOT create a widget
---with a name already in use of the interface! Using a already-in use name will cause issues with
---the game and the library!
---@param widgetName string The name of the widget
---@param widgetType string? The type of widget to create (NOT the instance) (Defaults to "Widget")
---@param skin string? The skin to use for this widget. (Defaults to "PanelEmpty")
---@return ReguiInterface.Widget widget The created widget
function ReGuiInterface:createWidget(widgetName, widgetType, skin) end

---Returns the settings of the GuiInterface itself.
---@return GuiSettings settings The settings that would be applied to the layout.
function ReGuiInterface:getSettings() end

---Overwrites the current settings with the new one
---@param settings GuiSettings The new settings
function ReGuiInterface:setSettings(settings) end

---Modifies the text translation function with a new one. This function gets used for all text-related
---widgets, great for i18n support
---
---The arguments of the function can be anything (eg a string or table)
---
---See github repo for a better explaination of this function aswel as a example
---
---@param translatorFunction function The callback.
function ReGuiInterface:setTextTranslation(translatorFunction) end

---Sets text of a widget. Note that this has diffirent behaviour and all arguments after widgetName
---will be passed through the translator function!
---@param widgetName string The name of the widget
---@param ... any The arguments to set the text
function ReGuiInterface:setText(widgetName, ...) end

---Gets text of a widget
---@param widgetName string The name of the widget
---@return string? text The text of the wiget. nil if not applied
function ReGuiInterface:getText(widgetName) end

---Reruns all text through the translation function. Use this when the language changes.
function ReGuiInterface:rerunTranslations() end

---Sets data to a widget. This is the same as doing setWidgetProperties
---@param widgetName string The name of the widget
---@param data table<string, ReGuiPropertyValueType> The properties to set.
function ReGuiInterface:setData(widgetName, data) end

---Sets data to a widget. This is the same as doing getWidgetProperties
---@param widgetName string The name of the widget
---@return table<string, ReGuiPropertyValueType> data The received properties
function ReGuiInterface:getData(widgetName) end


---A widget in a ReGuiInterface
---@class ReguiInterface.Widget
local ReGuiInterfaceWidget = {}

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
---@return ReguiInterface.Widget? parent The parent widget or nil if none.
function ReGuiInterfaceWidget:getParent() end

---Gets all child widgets of this widget.
---@return ReguiInterface.Widget[] children A list of child widgets.
function ReGuiInterfaceWidget:getChildren() end

---Gets the pixel position of the widget.
---@return table position A table with `x` and `y` keys in pixels.
function ReGuiInterfaceWidget:getPosition() end

---Gets the position of the widget in real units (0-1 scale).
---@return table position A table with `x` and `y` keys in real units.
function ReGuiInterfaceWidget:getPositionRealUnits() end

---Gets the pixel size of the widget.
---@return table size A table with `x` (width) and `y` (height) in pixels.
function ReGuiInterfaceWidget:getSize() end

---Gets the size of the widget in real units (0-1 scale).
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
---@return any value The property value.
function ReGuiInterfaceWidget:getProperty(index) end

---Sets an instance property of the widget.
---@param key string The instance property name.
---@param value string|number|boolean The property value.
function ReGuiInterfaceWidget:setInstanceProperty(key, value) end

---Gets an instance property of the widget.
---@param key string The instance property name.
---@return any value The property value.
function ReGuiInterfaceWidget:getInstanceProperty(key) end

---Sets the pixel position of the widget.
---@param position table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setPosition(position) end

---Sets the real unit position of the widget (0-1 scale).
---@param position table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setPositionRealUnits(position) end

---Sets the pixel size of the widget.
---@param size table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setSize(size) end

---Sets the size of the widget in real units (0-1 scale).
---@param size table A table with `x` and `y` or index [1], [2].
function ReGuiInterfaceWidget:setSizeRealUnits(size) end

---Checks if the widget currently exists in the GUI hierarchy.
---@return boolean exists True if it exists, false if not.
function ReGuiInterfaceWidget:exists() end

---Destroys the widget.
---@return boolean success True if it was removed, false if not found.
function ReGuiInterfaceWidget:destroy() end

---Creates a new widget inside of this widget It is recommended that you NOT create a widget
---with a name already in use of the interface! Using a already-in use name will cause issues with
---the game and the library!
---@param widgetName string The name of the widget
---@param widgetType string? The type of widget to create (NOT the instance) (Defaults to "Widget")
---@param skin string? The skin to use for this widget. (Defaults to "PanelEmpty")
---@return ReguiInterface.Widget widget The created widget
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
---@param value string|number|boolean|table|nil The property value.
function ReGuiInterfaceController:setProperty(key, value) end

---Gets an individual controller property.
---@param key string The property name.
---@return any value The value of the controller property.
function ReGuiInterfaceController:getProperty(key) end

---Destroys the controller, removing it from the widget.
function ReGuiInterfaceController:destroy() end