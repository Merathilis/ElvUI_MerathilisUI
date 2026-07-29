#!/usr/bin/env python3
"""
locale_audit.py – Localization audit tool for ElvUI_MerathilisUI

Scans the entire addon for L["..."] / L['...'] usages and compares them
against the keys defined in Locales/*.lua (reference = enUS.lua).

Features:
  • Finds missing keys (used in code but missing in locales)
  • Finds unused / superfluous keys (defined in locales but never used)
  • Compares all locale files against enUS
  • Pretty colored terminal output
  • Optional JSON report
  • Configurable ignore patterns

Usage (from the root of the repository):
  python locale_audit.py
  python locale_audit.py --path .
  python locale_audit.py --json report.json
  python locale_audit.py --verbose
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Set, Tuple

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# Regex that matches L["key"], L['key'] and L[ [[key]] ]
# Captures the key itself (group 1)
L_PATTERN = re.compile(
    r"""L\s*\[\s*(?:
        "((?:\\.|[^"\\])*)"      |   # double quotes
        '((?:\\.|[^'\\])*)'      |   # single quotes
        \[\[(.*?)\]\]               # long string [[...]]
    )\s*\]""",
    re.VERBOSE | re.DOTALL,
)

# Matches definition lines inside locale files: L["key"] = "value"
LOCALE_DEF_PATTERN = re.compile(
    r"""L\s*\[\s*(?:
        "((?:\\.|[^"\\])*)"      |
        '((?:\\.|[^'\\])*)'      |
        \[\[(.*?)\]\]
    )\s*\]\s*=""",
    re.VERBOSE | re.DOTALL,
)

# Files / directories that should never be scanned for *usage*
IGNORE_DIRS = {
    ".git",
    ".github",
    ".vscode",
    "__pycache__",
    "node_modules",
    "Locales",          # we parse locales separately
}

# Optional: keys that are allowed to exist only in locales (never reported as unused)
# Example: meta keys, section headers, etc.
ALWAYS_ALLOWED = {
    # add keys here if needed
}

# Optional: keys that may appear in code but are not required in locales
# (very rare – normally every L[] should be localised)
IGNORE_USAGE = set()


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

class Colors:
    HEADER = "\033[95m"
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"
    END = "\033[0m"

    @staticmethod
    def disable():
        Colors.HEADER = Colors.BLUE = Colors.CYAN = Colors.GREEN = ""
        Colors.YELLOW = Colors.RED = Colors.BOLD = Colors.UNDERLINE = Colors.END = ""


def color(text: str, c: str) -> str:
    return f"{c}{text}{Colors.END}"


def extract_key(match: re.Match) -> str:
    """Return the captured key from any of the three groups."""
    for g in match.groups():
        if g is not None:
            # Unescape common sequences
            return g.replace(r"\"", '"').replace(r"\'", "'").replace(r"\\", "\\")
    return ""


# ---------------------------------------------------------------------------
# Core logic
# ---------------------------------------------------------------------------

def find_lua_files(root: Path) -> List[Path]:
    """Return all .lua files under root, skipping ignored directories."""
    files = []
    for path in root.rglob("*.lua"):
        if any(part in IGNORE_DIRS for part in path.parts):
            continue
        files.append(path)
    return sorted(files)


def extract_keys_from_file(path: Path) -> Set[str]:
    """Extract all L[...] keys used in a single Lua file."""
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(color(f"  ⚠ Could not read {path}: {e}", Colors.YELLOW))
        return set()

    keys = set()
    for match in L_PATTERN.finditer(content):
        key = extract_key(match)
        if key and key not in IGNORE_USAGE:
            keys.add(key)
    return keys


def extract_locale_keys(path: Path) -> Set[str]:
    """Extract all defined keys from a locale file."""
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(color(f"  ⚠ Could not read locale {path}: {e}", Colors.YELLOW))
        return set()

    keys = set()
    for match in LOCALE_DEF_PATTERN.finditer(content):
        key = extract_key(match)
        if key:
            keys.add(key)
    return keys


def scan_usages(root: Path) -> Tuple[Set[str], Dict[str, List[str]]]:
    """
    Scan the whole tree for L[...] usages.
    Returns:
        all_keys: set of every unique key found
        locations: key → list of relative file paths where it appears
    """
    all_keys: Set[str] = set()
    locations: Dict[str, List[str]] = defaultdict(list)

    lua_files = find_lua_files(root)
    print(color(f"Scanning {len(lua_files)} Lua files for L[...] usages …", Colors.CYAN))

    for file in lua_files:
        rel = str(file.relative_to(root))
        keys = extract_keys_from_file(file)
        for k in keys:
            all_keys.add(k)
            locations[k].append(rel)

    return all_keys, locations


def load_locales(locales_dir: Path) -> Dict[str, Set[str]]:
    """Load every Locales/*.lua file and return {locale_name: set_of_keys}."""
    result = {}
    if not locales_dir.is_dir():
        print(color(f"Locales directory not found: {locales_dir}", Colors.RED))
        return result

    for path in sorted(locales_dir.glob("*.lua")):
        name = path.stem  # e.g. enUS, deDE, …
        keys = extract_locale_keys(path)
        result[name] = keys
        print(color(f"  Loaded {name}: {len(keys)} keys", Colors.BLUE))

    return result


# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------

def print_section(title: str):
    print()
    print(color("=" * 70, Colors.BOLD))
    print(color(f"  {title}", Colors.BOLD + Colors.HEADER))
    print(color("=" * 70, Colors.BOLD))


def report_missing(used: Set[str], defined: Set[str], locations: Dict[str, List[str]], verbose: bool):
    missing = sorted(used - defined)
    print_section(f"Missing keys in enUS  ({len(missing)})")

    if not missing:
        print(color("  ✓ None – everything used in code is present in enUS.", Colors.GREEN))
        return missing

    for key in missing:
        print(color(f"  ✗  {key}", Colors.RED))
        if verbose:
            for loc in locations.get(key, [])[:5]:
                print(f"       → {loc}")
            if len(locations.get(key, [])) > 5:
                print(f"       … and {len(locations[key]) - 5} more")
    return missing


def report_unused(used: Set[str], defined: Set[str], verbose: bool):
    unused = sorted((defined - used) - set(ALWAYS_ALLOWED)) # pyright: ignore[reportOperatorIssue]
    print_section(f"Unused / superfluous keys in enUS  ({len(unused)})")

    if not unused:
        print(color("  ✓ None – every key in enUS is used somewhere.", Colors.GREEN))
        return unused

    for key in unused:
        print(color(f"  •  {key}", Colors.YELLOW))
    return unused


def report_locale_diffs(locales: Dict[str, Set[str]], reference: str = "enUS"):
    if reference not in locales:
        print(color(f"Reference locale '{reference}' not found!", Colors.RED))
        return

    ref_keys = locales[reference]
    print_section(f"Locale comparison against {reference}")

    for name, keys in sorted(locales.items()):
        if name == reference:
            continue

        missing = sorted(ref_keys - keys)
        extra = sorted(keys - ref_keys)

        status = []
        if missing:
            status.append(color(f"{len(missing)} missing", Colors.RED))
        if extra:
            status.append(color(f"{len(extra)} extra", Colors.YELLOW))
        if not status:
            status.append(color("OK", Colors.GREEN))

        print(f"  {name:8} → {', '.join(status)}")

        if missing:
            for k in missing[:8]:
                print(f"           - {k}")
            if len(missing) > 8:
                print(f"           … and {len(missing) - 8} more")
        if extra:
            for k in extra[:5]:
                print(f"           + {k}")
            if len(extra) > 5:
                print(f"           … and {len(extra) - 5} more")


def write_json_report(
    path: Path,
    used: Set[str],
    enus: Set[str],
    missing: List[str],
    unused: List[str],
    locales: Dict[str, Set[str]],
    locations: Dict[str, List[str]],
):
    data = {
        "summary": {
            "keys_used_in_code": len(used),
            "keys_in_enUS": len(enus),
            "missing_in_enUS": len(missing),
            "unused_in_enUS": len(unused),
        },
        "missing_in_enUS": missing,
        "unused_in_enUS": unused,
        "locations": {k: locations[k] for k in missing},
        "locale_diffs": {},
    }

    ref = locales.get("enUS", set())
    for name, keys in locales.items():
        if name == "enUS":
            continue
        data["locale_diffs"][name] = {
            "missing": sorted(ref - keys),
            "extra": sorted(keys - ref),
        }

    path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding="utf-8")
    print(color(f"\nJSON report written to {path}", Colors.GREEN))


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    parser = argparse.ArgumentParser(
        description="Audit L[...] localization keys for ElvUI_MerathilisUI"
    )
    parser.add_argument(
        "--path",
        type=Path,
        default=Path("."),
        help="Root of the addon repository (default: current directory)",
    )
    parser.add_argument(
        "--json",
        type=Path,
        metavar="FILE",
        help="Write a detailed JSON report to FILE",
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Show file locations for missing keys",
    )
    parser.add_argument(
        "--no-color",
        action="store_true",
        help="Disable colored output",
    )
    args = parser.parse_args()

    if args.no_color or not sys.stdout.isatty():
        Colors.disable()

    root = args.path.resolve()
    locales_dir = root / "Locales"

    if not (root / "ElvUI_MerathilisUI.toc").exists() and not (root / "MerathilisUI.toc").exists():
        # soft check – just warn
        print(color(
            "Warning: No .toc file found. Are you running this from the addon root?",
            Colors.YELLOW,
        ))

    print(color(f"Root: {root}", Colors.CYAN))
    print()

    # 1. Scan code usages
    used_keys, locations = scan_usages(root)
    print(color(f"Found {len(used_keys)} unique L[...] keys in code.", Colors.GREEN))

    # 2. Load locales
    print()
    print(color("Loading locale files …", Colors.CYAN))
    locales = load_locales(locales_dir)

    if "enUS" not in locales:
        print(color("ERROR: enUS.lua not found in Locales/", Colors.RED))
        return 1

    enus = locales["enUS"]

    # 3. Reports
    missing = report_missing(used_keys, enus, locations, args.verbose)
    unused = report_unused(used_keys, enus, args.verbose)
    report_locale_diffs(locales)

    # 4. Summary
    print_section("Summary")
    print(f"  Keys used in code : {len(used_keys)}")
    print(f"  Keys in enUS      : {len(enus)}")
    print(color(f"  Missing in enUS   : {len(missing)}", Colors.RED if missing else Colors.GREEN))
    print(color(f"  Unused in enUS    : {len(unused)}", Colors.YELLOW if unused else Colors.GREEN))

    if args.json:
        write_json_report(args.json, used_keys, enus, missing, unused, locales, locations)

    print()
    if missing or unused:
        return 1  # non-zero exit code so CI can fail
    return 0


if __name__ == "__main__":
    sys.exit(main())
