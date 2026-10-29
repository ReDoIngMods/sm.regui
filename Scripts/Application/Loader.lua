dofile("$CONTENT_DATA/Scripts/Library/LibraryLoader.lua")

---Called when the editor is updating.
---@param deltaTime number The time in seconds since the last update.
function OnUpdate(deltaTime)

end

---Called on a 40 TPS interval. Recommended to put your non-render logic here.
function OnTick()

end

---Called when the editor wants to load a new layout
---@param layoutPath string The path to the layout file to load.
---@return boolean success Whether the layout was successfully loaded. If false, the editor will not load the layout.
function LoadLayout(layoutPath)
    print("Loading layout...", layoutPath)
    return true
end

---Called when the editor wants to get the layout tree for the current layout. This is used to display the Explorer panel in the editor.
---@return ReGuiEditor.LayoutTreeNode[]? layoutTreeRoot The layout tree for the current layout, or nil if the layout tree is not available.
function GetLayoutTree()
    return nil
end

---Called whether the editor needs information about a widget type. This is used to display the properties panel for the widget.
---@param widgetType string The type of the widget to get information about.
---@return ReGuiEditor.WidgetInfo? widgetInfo The information about the widget type, or nil if not found.
function GetWidgetInfo(widgetType)
    return nil
end

---Called when the editor requests the properties values of a widget.
---@param uniqueId Uuid The unique ID of the widget to get the property value for.
---@return ReGuiEditor.WidgetProperties? widgetProperties The properties of the widget, or nil if not found.
function GetWidgetProperties(uniqueId)
    return nil
end

---Returns a uniqueId for when the user presses on the mygui render view
---@param mousePositionX number The X position of the mouse in the render view.
---@param mousePositionY number The Y position of the mouse in the render view.
---@return Uuid? uniqueId The unique ID of the widget under the mouse position, or nil if no widget is under the mouse.
function GetWidgetUnderMouse(mousePositionX, mousePositionY)
    return nil
end

---Called when the editor requests to set the properties values of a widget.
---@param uniqueId Uuid The unique ID of the widget to set the property value for.
---@param propertyName string The name of the property to set.
---@param propertyValue ReGuiEditor.WidgetPropertiesData The value of the property to set.
---@return boolean success Whether the property was successfully set. If false, the property will not be set.
function SetWidgetProperty(uniqueId, propertyName, propertyValue)
    return false
end