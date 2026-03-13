import xml.etree.ElementTree as ET
import json
import argparse
import sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


# ---------------------------------------------------------------------------
# Value normalisation
# ---------------------------------------------------------------------------

def clean_float(value: str, precision: int = 6) -> int | float:
    d = Decimal(value).quantize(Decimal(10) ** -precision, rounding=ROUND_HALF_UP).normalize()
    return int(d) if d == d.to_integral() else float(d)


def normalize_scalar(raw: str) -> bool | int | float | str:
    s = raw.strip()
    if s.lower() == "true":
        return True
    if s.lower() == "false":
        return False
    if "." not in s:
        try:
            return int(s)
        except ValueError:
            pass
    try:
        return clean_float(s)
    except Exception:
        pass
    return s


def normalize_value(raw: str) -> bool | int | float | str | list:
    """Return a scalar or a list when the attribute holds space-separated tokens."""
    parts = raw.split()
    if len(parts) > 1:
        return [normalize_scalar(p) for p in parts]
    return normalize_scalar(raw)


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

KNOWN_TAGS = {"Widget", "Property", "UserString", "Controller", "CodeGeneratorSettings"}


def parse_properties(element: ET.Element) -> dict:
    """Collect <Property> children into a dict."""
    return {
        child.attrib["key"]: normalize_value(child.attrib["value"])
        for child in element
        if child.tag == "Property"
        and "key" in child.attrib
        and "value" in child.attrib
    }


def parse_widget(element: ET.Element) -> dict:
    node: dict = {k: normalize_value(v) for k, v in element.attrib.items()}

    properties: dict = {}
    user_strings: dict = {}
    controllers: list = []
    children: list = []
    unknown: list = []

    for child in element:
        tag = child.tag

        if tag == "Property":
            key = child.attrib.get("key")
            value = child.attrib.get("value")
            if key and value is not None:
                properties[key] = normalize_value(value)

        elif tag == "UserString":
            key = child.attrib.get("key")
            value = child.attrib.get("value")
            if key and value is not None:
                user_strings[key] = normalize_scalar(value)

        elif tag == "Controller":
            controller = {k: normalize_value(v) for k, v in child.attrib.items()}
            ctrl_props = parse_properties(child)
            if ctrl_props:
                controller["properties"] = ctrl_props
            controllers.append(controller)

        elif tag == "Widget":
            parsed = parse_widget(child)
            if parsed:
                children.append(parsed)

        elif tag == "CodeGeneratorSettings":
            pass  # intentionally ignored

        else:
            # Preserve unrecognised tags so nothing is silently dropped
            entry = {"_tag": tag, **{k: normalize_value(v) for k, v in child.attrib.items()}}
            unknown.append(entry)

    if properties:
        node["properties"] = properties
    if user_strings:
        node["userStrings"] = user_strings
    if controllers:
        node["controllers"] = controllers
    if children:
        node["children"] = children
    if unknown:
        node["_unknownChildren"] = unknown

    return node


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_arg_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Convert MyGUI layout XML to JSON.")
    p.add_argument("input",  nargs="?", default="input.layout",   help="Source .layout file")
    p.add_argument("output", nargs="?", default="output.relayout", help="Destination .relayout file")
    p.add_argument("--width",  type=int, default=1920, dest="screen_width")
    p.add_argument("--height", type=int, default=1080, dest="screen_height")
    p.add_argument("--indent", type=int, default=4,    help="JSON indentation level")
    return p


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    args = build_arg_parser().parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        sys.exit(f"Error: input file '{input_path}' not found.")

    try:
        tree = ET.parse(input_path)
    except ET.ParseError as exc:
        sys.exit(f"Error: failed to parse XML — {exc}")

    root = tree.getroot()
    layout = parse_widget(root)

    output = {
        "version": 2,
        "metadata": {
            "screenWidth":  args.screen_width,
            "screenHeight": args.screen_height
        },
        "data": {
            "type":     root.attrib.get("type", "Layout"),
            "version":  root.attrib.get("version"),
            "children": layout.get("children", []),
        },
    }

    output_path = Path(args.output)
    with output_path.open("w", encoding="utf-8") as fh:
        json.dump(output, fh, indent=args.indent)

    print(f"Written {output_path} ({output_path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()