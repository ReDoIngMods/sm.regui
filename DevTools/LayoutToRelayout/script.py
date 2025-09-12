import xml.etree.ElementTree as ET
import json

def parse_bool(val):
    if val.lower() == "true":
        return True
    if val.lower() == "false":
        return False
    return val

def parse_position(element):
    """
    Parse either 'position_real' (relative) or 'position' (pixel-based).
    """
    pos_str = element.attrib.get("position_real")
    use_pixels = False

    if pos_str:
        coords = list(map(float, pos_str.split()))
    else:
        pos_str = element.attrib.get("position")
        use_pixels = True
        if pos_str:
            coords = list(map(int, pos_str.split()))
        else:
            coords = [0, 0, 1, 1]
            use_pixels = False

    keys = ["x", "y", "width", "height"]
    return {
        "usePixels": use_pixels,
        **dict(zip(keys, coords))
    }

def parse_properties(widget_element):
    properties = {}
    for prop in widget_element.findall("Property"):
        key = prop.attrib.get("key")
        value = prop.attrib.get("value")
        if value is not None:
            value = value.encode('utf-8').decode('unicode_escape')
            
            # Convert string booleans to Python bools
            if value.lower() in ["true", "false"]:
                value = parse_bool(value)

            properties[key] = value
    return properties

def parse_widget(element):
    """
    Recursively parse a <Widget> element into the custom structure.
    """
    if element.tag != "Widget":
        return None

    name = element.attrib.get("name", "Unnamed")
    widget_type = element.attrib.get("type", "Unknown")
    skin = element.attrib.get("skin", "PanelEmpty")

    widget_obj = {
        "instanceProperties": {
            "name": name,
            "type": widget_type,
            "skin": skin
        },
        "positionSize": parse_position(element),
        "isTemplateContents": False,
        "properties": parse_properties(element),
        "controllers": [],
        "children": []
    }
    
    # Recursively process child widgets
    for child in element:
        if child.tag == "Widget":
            child_parsed = parse_widget(child)
            if child_parsed:
                widget_obj["children"].append(child_parsed)
        elif child.tag == "Controller":
            controller = {
                "type": child.attrib.get("type", "Unknown"),
                "properties": parse_properties(child)
            }
            widget_obj["controllers"].append(controller)

    if not widget_obj["controllers"]:
        del widget_obj["controllers"]

    if not widget_obj["children"]:
        del widget_obj["children"]
    
    if not widget_obj["properties"]:
        del widget_obj["properties"]

    return widget_obj

def convert_xml_to_custom_json(xml_path):
    """
    Parse the XML file and convert it to the custom JSON structure.
    """
    tree = ET.parse(xml_path)
    root = tree.getroot()

    result = {
        "identifier": "ReGui",
        "version": 1,
        "data": []
    }

    # Top-level Widgets under <MyGUI>
    for widget in root.findall("./Widget"):
        widget_data = parse_widget(widget)
        if widget_data:
            result["data"].append(widget_data)

    return result

output = convert_xml_to_custom_json("input.layout")

with open("output.json", "w") as f:
    json.dump(output, f, indent=4, ensure_ascii=False)