#!/usr/bin/env python3
"""
locale_fixer.py – Fixes localization keys for ElvUI_MerathilisUI.

Functions:
  • Adds missing keys used in code to enUS.lua (and other locale files).
  • Syncs all other locale files against enUS.lua.
  • (Optional) Removes unused/superfluous keys from locale files.

Usage:
  python locale_fixer.py
  python locale_fixer.py --dry-run
  python locale_fixer.py --remove-unused
  python locale_fixer.py --path /path/to/addon
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from typing import Dict, Set

# Reuse matching logic from locale_audit.py
L_PATTERN = re.compile(
    r"""L\s*\[\s*(?:
        "((?:\\.|[^"\\])*)"      |   # double quotes
        '((?:\\.|[^'\\])*)'      |   # single quotes
        \[\[(.*?)\]\]               # long string [[...]]
    )\s*\]""",
    re.VERBOSE | re.DOTALL,
)

LOCALE_DEF_PATTERN = re.compile(
    r"""L\s*\[\s*(?:
        "((?:\\.|[^"\\])*)"      |
        '((?:\\.|[^'\\])*)'      |
        \[\[(.*?)\]\]
    )\s*\]\s*=""",
    re.VERBOSE | re.DOTALL,
)

IGNORE_DIRS = {".git", ".github", ".vscode", "__pycache__", "node_modules", "Locales"}


def extract_key(match: re.Match) -> str:
    for g in match.groups():
        if g is not None:
            return g.replace(r"\"", '"').replace(r"\'", "'").replace(r"\\", "\\")
    return ""


def find_lua_files(root: Path) -> list[Path]:
    files = []
    for path in root.rglob("*.lua"):
        if any(part in IGNORE_DIRS for part in path.parts):
            continue
        files.append(path)
    return sorted(files)


def extract_keys_from_file(path: Path) -> Set[str]:
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return set()

    keys = set()
    for match in L_PATTERN.finditer(content):
        key = extract_key(match)
        if key:
            keys.add(key)
    return keys


def extract_locale_keys(path: Path) -> Set[str]:
    try:
        content = path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return set()

    keys = set()
    for match in LOCALE_DEF_PATTERN.finditer(content):
        key = extract_key(match)
        if key:
            keys.add(key)
    return keys


def append_keys_to_file(file_path: Path, new_keys: Set[str], dry_run: bool = False, comment_out: bool = False):
    """Appends new localization keys at the bottom of the specified file."""
    if not new_keys:
        return

    sorted_keys = sorted(new_keys)
    lines_to_add = ["\n-- Automatically added missing keys\n"]
    
    for k in sorted_keys:
        # Escape double quotes if present in key
        escaped_key = k.replace('"', r'\"')
        if comment_out:
            lines_to_add.append(f'-- L["{escaped_key}"] = "{escaped_key}"\n')
        else:
            lines_to_add.append(f'L["{escaped_key}"] = "{escaped_key}"\n')

    print(f"  [+] Adding {len(new_keys)} keys to {file_path.name}")
    
    if not dry_run:
        content = file_path.read_text(encoding="utf-8")
        content += "".join(lines_to_add)
        file_path.write_text(content, encoding="utf-8")


def remove_unused_keys_from_file(file_path: Path, unused_keys: Set[str], dry_run: bool = False):
    """Removes definition lines for unused keys from a Lua locale file."""
    if not unused_keys:
        return

    content = file_path.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)
    new_lines = []
    removed_count = 0

    for line in lines:
        match = LOCALE_DEF_PATTERN.search(line)
        if match:
            key = extract_key(match)
            if key in unused_keys:
                removed_count += 1
                continue  # Skip this line
        new_lines.append(line)

    if removed_count > 0:
        print(f"  [-] Removing {removed_count} unused keys from {file_path.name}")
        if not dry_run:
            file_path.write_text("".join(new_lines), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Fix missing and unused locale entries.")
    parser.add_argument("--path", type=Path, default=Path("."), help="Path to repository root")
    parser.add_argument("--dry-run", action="store_true", help="Simulate changes without modifying files")
    parser.add_argument("--remove-unused", action="store_true", help="Remove keys from locales that are unused in code")
    args = parser.parse_args()

    root = args.path.resolve()
    locales_dir = root / "Locales"

    if not locales_dir.is_dir():
        print(f"Error: Directory {locales_dir} not found.")
        sys.exit(1)

    enus_file = locales_dir / "enUS.lua"
    if not enus_file.exists():
        print(f"Error: {enus_file} does not exist.")
        sys.exit(1)

    # 1. Gather keys used in code
    print("Scanning code for L[...] usages...")
    used_in_code = set()
    for lua_file in find_lua_files(root):
        used_in_code.update(extract_keys_from_file(lua_file))

    # 2. Process enUS.lua
    print("\nAuditing enUS.lua...")
    enus_keys = extract_locale_keys(enus_file)
    missing_in_enus = used_in_code - enus_keys
    unused_in_enus = enus_keys - used_in_code

    if missing_in_enus:
        append_keys_to_file(enus_file, missing_in_enus, dry_run=args.dry_run)
    else:
        print("  ✓ No missing keys in enUS.lua")

    if args.remove_unused and unused_in_enus:
        remove_unused_keys_from_file(enus_file, unused_in_enus, dry_run=args.dry_run)

    # Reload enUS keys after potential update
    updated_enus_keys = enus_keys.union(missing_in_enus)

    # 3. Sync other locale files with enUS
    print("\nSyncing other locale files with enUS...")
    for loc_file in sorted(locales_dir.glob("*.lua")):
        if loc_file.name == "enUS.lua":
            continue

        loc_keys = extract_locale_keys(loc_file)
        missing_in_loc = updated_enus_keys - loc_keys
        
        # Add missing keys as commented out template
        if missing_in_loc:
            append_keys_to_file(loc_file, missing_in_loc, dry_run=args.dry_run, comment_out=True)

        if args.remove_unused:
            unused_in_loc = loc_keys - used_in_code
            if unused_in_loc:
                remove_unused_keys_from_file(loc_file, unused_in_loc, dry_run=args.dry_run)

    print("\nDone!")


if __name__ == "__main__":
    main()