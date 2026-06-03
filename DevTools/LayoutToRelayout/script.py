import xml.etree.ElementTree as ET
import json
import argparse
import sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
from typing import TypedDict

ScalarValue = bool | int | float | str
NormalizedValue = ScalarValue | list[ScalarValue]
VecDict = dict[str, int | float]
TypeSpec = tuple[str, int] | str


class PixelRect(TypedDict):
    x: int
    y: int
    width: int
    height: int


class CoordinateDict(TypedDict):
    x: int | float
    y: int | float
    width: int | float
    height: int | float


class ControllerDict(TypedDict, total=False):
    type: str | None


class WidgetNode(TypedDict, total=False):
    nodeProperties: dict[str, NormalizedValue]
    coordinate: CoordinateDict
    properties: dict[str, NormalizedValue]
    userStrings: dict[str, ScalarValue]
    controllers: list[ControllerDict]
    children: list["WidgetNode"]


KNOWN_TAGS: set[str] = {"Widget", "Property", "UserString", "Controller", "CodeGeneratorSettings"}

CONTROLLER_SCHEMAS: dict[str, dict[str, TypeSpec]] = {
    "ControllerPosition": {
        "Coord": ("vec4", 4),
        "Function": "string",
        "Position": ("vec2", 2),
        "Size": ("vec2", 2),
        "Time": "float",
    },
    "ControllerFadeAlpha": {
        "Alpha": "float",
        "Coef": "float",
        "Enabled": "bool",
    },
    "ControllerEdgeHide": {
        "RemainPixels": "int",
        "ShadowSize": "int",
        "Time": "float",
    },
}

FORCE_STRING_KEYS: set[str] = {"Caption"}


def cleanFloat(value: str, precision: int = 6) -> int | float:
    decimal = Decimal(value).quantize(
        Decimal(10) ** -precision,
        rounding=ROUND_HALF_UP
    ).normalize()
    return int(decimal) if decimal == decimal.to_integral() else float(decimal)


def normalizeScalar(raw: str) -> ScalarValue:
    stripped = raw.strip()

    if stripped.lower() == "true":
        return True
    if stripped.lower() == "false":
        return False

    if "." not in stripped:
        try:
            return int(stripped)
        except ValueError:
            pass

    try:
        return cleanFloat(stripped)
    except Exception:
        pass

    return stripped


def normalizeValue(raw: str, key: str | None = None) -> NormalizedValue:
    if key in FORCE_STRING_KEYS:
        return raw

    parts = raw.split()
    if len(parts) > 1:
        return [normalizeScalar(part) for part in parts]
    return normalizeScalar(raw)


def shapeVector(value: list[ScalarValue], kind: str) -> VecDict:
    if kind == "vec2":
        x, y = value
        return {"x": float(x), "y": float(y)}
    if kind == "vec4":
        x, y, w, h = value
        return {"x": float(x), "y": float(y), "width": float(w), "height": float(h)}
    raise ValueError(f"Unknown vector kind '{kind}'")


def coerceType(value: NormalizedValue, typeSpec: TypeSpec) -> NormalizedValue | VecDict:
    if isinstance(typeSpec, tuple):
        kind, size = typeSpec
        if not isinstance(value, list) or len(value) != size:
            raise ValueError(f"Expected {size} values for {kind}, got {value!r}")
        return shapeVector(value, kind)

    if typeSpec == "int":
        if not isinstance(value, int):
            raise ValueError(f"Expected int, got {value!r}")
        return value

    if typeSpec == "float":
        if not isinstance(value, (int, float)):
            raise ValueError(f"Expected float, got {value!r}")
        return float(value)

    if typeSpec == "bool":
        if not isinstance(value, bool):
            raise ValueError(f"Expected bool, got {value!r}")
        return value

    if typeSpec == "string":
        return str(value)

    return value


def resolveRealToPixels(values: list[ScalarValue], parent: PixelRect) -> PixelRect:
    rx, ry, rw, rh = (float(v) for v in values)

    return {
        "x": round(rx * parent["width"]),
        "y": round(ry * parent["height"]),
        "width": round(rw * parent["width"]),
        "height": round(rh * parent["height"]),
    }


def extractPosition(
    attributes: dict[str, NormalizedValue],
    parent: PixelRect
) -> CoordinateDict | None:

    if "position_real" in attributes:
        values = attributes.pop("position_real")

        if isinstance(values, list) and len(values) == 4:
            r = resolveRealToPixels(values, parent)
            return {
                "x": int(r["x"]),
                "y": int(r["y"]),
                "width": int(r["width"]),
                "height": int(r["height"]),
            }

    if "position" in attributes:
        values = attributes.pop("position")

        if isinstance(values, list) and len(values) == 4:
            x, y, width, height = values

            return {
                "x": float(x) if not isinstance(x, str) else float(x),
                "y": float(y) if not isinstance(y, str) else float(y),
                "width": float(width) if not isinstance(width, str) else float(width),
                "height": float(height) if not isinstance(height, str) else float(height),
            }

    return None


def parseProperties(element: ET.Element) -> dict[str, NormalizedValue]:
    return {
        child.attrib["key"]: normalizeValue(
            child.attrib["value"],
            key=child.attrib["key"]
        )
        for child in element
        if child.tag == "Property"
        and "key" in child.attrib
        and "value" in child.attrib
    }


def parseWidget(element: ET.Element, parent: PixelRect) -> WidgetNode:
    nodeProperties: dict[str, NormalizedValue] = {
        key: normalizeValue(value, key=key)
        for key, value in element.attrib.items()
    }

    position = extractPosition(nodeProperties, parent)

    if position is not None:
        childParent: PixelRect = {
            "x": int(position["x"]),
            "y": int(position["y"]),
            "width": int(position["width"]),
            "height": int(position["height"]),
        }
    else:
        childParent = parent

    properties: dict[str, NormalizedValue] = {}
    userStrings: dict[str, ScalarValue] = {}
    controllers: list[ControllerDict] = []
    children: list[WidgetNode] = []

    for child in element:
        tag = child.tag

        if tag == "Property":
            key = child.attrib.get("key")
            value = child.attrib.get("value")
            if key and value is not None:
                properties[key] = normalizeValue(value, key=key)

        elif tag == "UserString":
            key = child.attrib.get("key")
            value = child.attrib.get("value")
            if key and value is not None:
                userStrings[key] = normalizeScalar(value)

        elif tag == "Controller":
            controllerType = child.attrib.get("type")
            controller: ControllerDict = {"type": controllerType}

            rawProps = parseProperties(child)
            schema = CONTROLLER_SCHEMAS.get(controllerType or "", {})

            for propKey, propValue in rawProps.items():
                if propKey in schema:
                    try:
                        controller[propKey] = coerceType(
                            propValue,
                            schema[propKey]
                        )  # type: ignore[literal-required]
                    except ValueError as e:
                        print(f"WARNING: {controllerType}.{propKey}: {e}")
                else:
                    print(f"WARNING: Unknown property '{propKey}' in {controllerType}")
                    controller[propKey] = propValue  # type: ignore[literal-required]

            controllers.append(controller)

        elif tag == "Widget":
            parsedChild = parseWidget(child, childParent)
            children.append(parsedChild)

        elif tag == "CodeGeneratorSettings":
            pass

        else:
            print(f"WARNING: Unrecognised tag '<{tag}>'")

    node: WidgetNode = {
        "nodeProperties": nodeProperties,
        "properties": properties,
        "userStrings": userStrings,
        "controllers": controllers,
        "children": children,
    }

    if position is not None:
        node["coordinate"] = position

    return node


def buildArgumentParser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Convert MyGUI layout XML to JSON.")
    parser.add_argument("input", nargs="?", default="input.layout", help="Source .layout file")
    parser.add_argument("output", nargs="?", default="output.relayout", help="Destination .relayout file")
    parser.add_argument(
        "--resolution",
        type=int,
        choices=[1, 2, 3, 4],
        default=2,
        help="1=720p, 2=1080p, 3=1440p, 4=4K"
    )
    parser.add_argument("--indent", type=int, default=4, help="JSON indentation level")
    parser.add_argument("--compress", action="store_const", const=None, dest="indent", help="Disable JSON pretty-printing")

    return parser


def main() -> None:
    arguments = buildArgumentParser().parse_args()

    screenSizes = {
        1: (1280, 720),
        2: (1920, 1080),
        3: (2560, 1440),
        4: (3840, 2160),
    }
    screenWidth, screenHeight = screenSizes[arguments.resolution]
    print(f"Using screen resolution {screenWidth}x{screenHeight}")

    inputPath = Path(arguments.input)
    if not inputPath.exists():
        sys.exit(f"Error: input file '{inputPath}' not found.")

    try:
        tree = ET.parse(inputPath)
    except ET.ParseError as exception:
        sys.exit(f"Error: failed to parse XML — {exception}")

    root = tree.getroot()

    screenPixels: PixelRect = {
        "x": 0,
        "y": 0,
        "width": screenWidth,
        "height": screenHeight,
    }

    layout = parseWidget(root, screenPixels)

    output = {
        "version": 2,
        "metadata": {
            "screenWidth": screenWidth,
            "screenHeight": screenHeight,
        },
        "data": {
            "type": root.attrib.get("type", "Layout"),
            "version": root.attrib.get("version"),
            "children": layout.get("children", []),
        },
    }

    outputPath = Path(arguments.output)
    with outputPath.open("w", encoding="utf-8") as fileHandle:
        if arguments.indent is None:
            json.dump(output, fileHandle, separators=(",", ":"))
        else:
            json.dump(output, fileHandle, indent=arguments.indent)

    print(f"Written {outputPath} ({outputPath.stat().st_size} bytes)")


if __name__ == "__main__":
    main()