-- WidgetInfo --

---@enum ReGuiEditor.PropertyType Type of proprety
---| "String"
---| "Dropdown"
---| "Integer"
---| "Float"
---| "Boolean"
---| "Color"
---| "Vector2"
---| "Vector3"
---| "UDim"
---| "UDim2"
---| "Filepath"
---| "Enum"

---A property of a widget in the ReGuiEditor. Properties are used to define the behavior and appearance of widgets in the editor.
---@class ReGuiEditor.Property
---@field name string Name of the property
---@field description string Description of the property
---@field type ReGuiEditor.PropertyType Type of the property

---A property of type "String" in the ReGuiEditor. String properties are used to define text-based values for widgets in the editor.
---@class ReGuiEditor.Property.String : ReGuiEditor.Property
---@field type "String"
---@field placeholder string? Placeholder text to display when the input is empty (defaults to "")
---@field default string? Default value of the property (defaults to "")
---@field maxLength integer? Maximum length of the string (defaults to no limit)
---@field regex string? Regular expression that the string must match (defaults to no regex)
---@field regexError string? Error message to display if the string does not match the regex (defaults to "Invalid input")

---A property of type "Dropdown" in the ReGuiEditor. Dropdown properties are used to define a list of options for widgets in the editor.
---@class ReGuiEditor.Property.Dropdown : ReGuiEditor.Property
---@field type "Dropdown"
---@field placeholder string? Placeholder text to display when no option is selected (defaults to "")
---@field options string[] List of options for the dropdown
---@field default string? Default value of the property (defaults to the first option)
---@field allowCustom boolean? Whether to allow custom values (defaults to false)

---A property of type "Integer" in the ReGuiEditor. Integer properties are used to define whole number values for widgets in the editor.
---@class ReGuiEditor.Property.Integer : ReGuiEditor.Property
---@field type "Integer"
---@field placeholder string? Placeholder text to display when the input is empty (defaults to "")
---@field default integer? Default value of the property (defaults to 0)
---@field min integer? Minimum value of the property (defaults to no minimum)
---@field max integer? Maximum value of the property (defaults to no maximum)
---@field step integer? Step value for the property (defaults to 1)

---A property of type "Float" in the ReGuiEditor. Float properties are used to define decimal number values for widgets in the editor.
---@class ReGuiEditor.Property.Float : ReGuiEditor.Property
---@field type "Float"
---@field placeholder string? Placeholder text to display when the input is empty (defaults to "")
---@field default number? Default value of the property (defaults to 0.0)
---@field min number? Minimum value of the property (defaults to no minimum)
---@field max number? Maximum value of the property (defaults to no maximum)
---@field step number? Step value for the property (defaults to 0.1)

---A property of type "Boolean" in the ReGuiEditor. Boolean properties are used to define true/false values for widgets in the editor.
---@class ReGuiEditor.Property.Boolean : ReGuiEditor.Property
---@field type "Boolean"
---@field placeholder string? Placeholder text to display when the input is empty (defaults to "")
---@field default boolean? Default value of the property (defaults to false)
---@field trueLabel string? Label to display for the true value (defaults to "True")
---@field falseLabel string? Label to display for the false value (defaults to "False")

---A property of type "Color" in the ReGuiEditor. Color properties are used to define color values for widgets in the editor.
---@class ReGuiEditor.Property.Color : ReGuiEditor.Property
---@field type "Color"
---@field placeholder string? Placeholder text to display when the input is empty (defaults to "")
---@field default string? Default value of the property (defaults to "#FFFFFF")
---@field allowAlpha boolean? Whether to allow alpha values (defaults to false)

---A property of type "Vector2" in the ReGuiEditor. Vector2 properties are used to define 2D vector values for widgets in the editor.
---@class ReGuiEditor.Property.Vector2 : ReGuiEditor.Property
---@field type "Vector2"
---@field placeholder {x: string, y: string}? Placeholder text to display when the input is empty (defaults to {x = "", y = ""})
---@field default ReGui.Vector2? Default value of the property (defaults to {x = 0, y = 0})
---@field min ReGui.Vector2? Minimum value of the property (defaults to no minimum)
---@field max ReGui.Vector2? Maximum value of the property (defaults to no maximum)

---A property of type "Vector3" in the ReGuiEditor. Vector3 properties are used to define 3D vector values for widgets in the editor.
---@class ReGuiEditor.Property.Vector3 : ReGuiEditor.Property
---@field type "Vector3"
---@field placeholder {x: string, y: string, z: string}? Placeholder text to display when the input is empty (defaults to {x = "", y = "", z = ""})
---@field default {x: number, y: number, z: number}? Default value of the property (defaults to {x = 0, y = 0, z = 0})
---@field min Vec3? Minimum value of the property (defaults to no minimum)
---@field max Vec3? Maximum value of the property (defaults to no maximum)

---A property of type "UDim" in the ReGuiEditor. UDim properties are used to define UDim values for widgets in the editor.
---@class ReGuiEditor.Property.UDim : ReGuiEditor.Property
---@field type "UDim"
---@field placeholder {scale: string, offset: string}? Placeholder text to display when the input is empty (defaults to {scale = "", offset = ""})
---@field default ReGui.UDim? Default value of the property (defaults to {scale = 0, offset = 0})
---@field min ReGui.UDim? Minimum value of the property (defaults to no minimum)
---@field max ReGui.UDim? Maximum value of the property (defaults to no maximum)

---A property of type "UDim2" in the ReGuiEditor. UDim2 properties are used to define UDim2 values for widgets in the editor.
---@class ReGuiEditor.Property.UDim2 : ReGuiEditor.Property
---@field type "UDim2"
---@field placeholder {x: {scale: string, offset: string}, y: {scale: string, offset: string}}? Placeholder text to display when the input is empty (defaults to {x = {scale = "", offset = ""}, y = {scale = "", offset = ""}})
---@field default ReGui.UDim2? Default value of the property (defaults to {x = {scale = 0, offset = 0}, y = {scale = 0, offset = 0}})
---@field min ReGui.UDim2? Minimum value of the property (defaults to no minimum)
---@field max ReGui.UDim2? Maximum value of the property (defaults to no maximum)

---A property of type "Filepath" in the ReGuiEditor. Filepath properties are used to define file or folder paths for widgets in the editor.
---@class ReGuiEditor.Property.Filepath : ReGuiEditor.Property
---@field type "Filepath"
---@field placeholder string? Placeholder text to display when the input is empty (defaults to "")
---@field default string? Default value of the property (defaults to "")
---@field acceptsFile boolean? Whether to accept files (defaults to true)
---@field acceptsFolder boolean? Whether to accept folders (defaults to false)
---@field acceptsMultiple boolean? Whether to accept multiple files/folders (defaults to false)
---@field fileExtensions string[]? List of accepted file extensions (defaults to no restriction)

---A Enum option for a property of type "Enum" in the ReGuiEditor. Enum options are used to define a list of options for widgets in the editor.
---@class ReGuiEditor.Property.EnumOption
---@field name string Name of the option
---@field description string? Description of the option (defaults to "")
---@field value any Value of the option. Defaults to the name of the option if not provided.

---A property of type "Enum" in the ReGuiEditor. Enum properties are used to define a list of options for widgets in the editor.
---@class ReGuiEditor.Property.Enum : ReGuiEditor.Property
---@field type "Enum"
---@field placeholder string? Placeholder text to display when no option is selected (defaults to "")
---@field options ReGuiEditor.Property.EnumOption[] List of options for the enum
---@field default string? Default value of the property (defaults to the first option)

---A group of properties in the ReGuiEditor. Property groups are used to organize properties for widgets in the editor.
---@class ReGuiEditor.PropertyGroup
---@field name string Name of the property group
---@field description string Description of the property group
---@field properties ReGuiEditor.Property[] List of properties in the group

---A widget type in the ReGuiEditor. Widget types are used to define the behavior and appearance of widgets in the editor.
---@class ReGuiEditor.WidgetInfo
---@field name string Name of the widget type
---@field description string Description of the widget type
---@field uniqueId Uuid Unique ID of the widget type
---@field properties ReGuiEditor.PropertyGroup[] List of property groups for the widget type

-- LayoutTreeNode --

---@class ReGuiEditor.LayoutTreeNode
---@field name string Name of the widget
---@field uniqueId Uuid Unique ID of the widget
---@field type string Type of the widget
---@field children ReGuiEditor.LayoutTreeNode[] List of child widgets

-- Widget Properties --

---@alias ReGuiEditor.WidgetPropertiesData string|string[]|integer|number|boolean|Color|ReGui.Vector2|Vec3|ReGui.UDim|ReGui.UDim2|string|string
---@alias ReGuiEditor.WidgetProperties table<string, ReGuiEditor.WidgetPropertiesData> Table of properties for the widget, where the key is the property name and the value is the property value