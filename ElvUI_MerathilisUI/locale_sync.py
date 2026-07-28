from pathlib import Path
import re
from collections import OrderedDict
import argparse

BASE_DIR = Path(__file__).resolve().parent
LOCALES_DIR = BASE_DIR / "Locales"
REFERENCE_LOCALE = "enUS"
ASSIGN_RE = re.compile(r'^\s*L\[(?P<quote>["\"])(?P<key>.*?)(?P=quote)\]\s*=\s*(?P<value>.+)$')


def read_lines(path):
    return path.read_text(encoding="utf-8").splitlines()


def parse_locale_sections(path):
    lines = read_lines(path)
    header = []
    sections = []
    current_section = None
    pending_comments = []
    in_header = True
    i = 0

    while i < len(lines):
        line = lines[i]
        match = ASSIGN_RE.match(line)
        if match:
            if in_header:
                in_header = False
                if pending_comments:
                    header.extend(pending_comments)
                    pending_comments = []
            if current_section is None:
                current_section = {
                    "comment_lines": pending_comments,
                    "keys": [],
                }
                pending_comments = []
            key = match.group("key")
            value = match.group("value").strip()
            raw_value = [value]
            if value.startswith("[=["):
                if not value.endswith("]=]"):
                    i += 1
                    while i < len(lines):
                        raw_value.append(lines[i])
                        if lines[i].strip().endswith("]=]"):
                            break
                        i += 1
            current_section["keys"].append(key)
            if i + 1 < len(lines) and lines[i + 1].strip().startswith("L["):
                pass
        else:
            if in_header:
                pending_comments.append(line)
            else:
                if current_section is not None and (not line.strip() or line.strip().startswith("--")):
                    sections.append(current_section)
                    current_section = None
                    pending_comments = [line]
                else:
                    pending_comments.append(line)
        i += 1

    if current_section is not None:
        sections.append(current_section)
    if in_header and pending_comments:
        header.extend(pending_comments)
    if not in_header and pending_comments:
        if sections:
            sections[-1]["comment_lines"].extend(pending_comments)
        else:
            header.extend(pending_comments)

    return header, sections


def parse_locale_entries(path):
    lines = read_lines(path)
    values = OrderedDict()
    i = 0
    while i < len(lines):
        line = lines[i]
        match = ASSIGN_RE.match(line)
        if not match:
            i += 1
            continue
        key = match.group("key")
        value = match.group("value").strip()
        entry_lines = [value]
        if value.startswith("[=[") and not value.endswith("]=]"):
            i += 1
            while i < len(lines):
                entry_lines.append(lines[i])
                if lines[i].strip().endswith("]=]"):
                    break
                i += 1
        values[key] = "\n".join(entry_lines)
        i += 1
    return values


def build_locale_output(header, reference_sections, locale_values):
    lines = []
    lines.extend(header)
    if header and header[-1].strip() != "":
        lines.append("")

    missing = []
    removed = []
    all_reference_keys = []
    for section in reference_sections:
        section_keys = sorted(section["keys"], key=lambda x: x.lower())
        all_reference_keys.extend(section_keys)
        lines.extend(section["comment_lines"])
        for key in section_keys:
            if key in locale_values:
                value = locale_values.pop(key)
            else:
                missing.append(key)
                value = "true"
            lines.append(f'L["{key}"] = {value}')
        if section is not reference_sections[-1]:
            lines.append("")

    if locale_values:
        removed.extend(locale_values.keys())
    return lines, missing, removed, all_reference_keys


def make_backup(path):
    backup_path = path.with_suffix(path.suffix + ".bak")
    if not backup_path.exists():
        backup_path.write_text(path.read_text(encoding="utf-8"), encoding="utf-8")
    return backup_path


if __name__ == "__main__":
    locale_paths = sorted([p for p in LOCALES_DIR.glob("*.lua") if p.is_file()])
    reference_path = LOCALES_DIR / f"{REFERENCE_LOCALE}.lua"
    if not reference_path.exists():
        raise FileNotFoundError(f"Reference locale not found: {reference_path}")

    ref_header, ref_sections = parse_locale_sections(reference_path)
    ref_entries = parse_locale_entries(reference_path)
    parser = argparse.ArgumentParser(description="Sync ElvUI locale files with enUS and sort keys alphabetically.")
    parser.add_argument("--dry-run", action="store_true", help="Show planned changes without writing files.")
    parser.add_argument("--no-backup", action="store_true", help="Do not create backup files when writing.")
    args = parser.parse_args()

    print(f"Reference locale {REFERENCE_LOCALE}: {len(ref_entries)} keys, {len(ref_sections)} sections")
    print("Dry run:" if args.dry_run else "Applying changes...")

    summary = []
    for path in locale_paths:
        locale_code = path.stem
        locale_values = parse_locale_entries(path)
        output_lines, missing, removed, _ = build_locale_output(ref_header, ref_sections, locale_values)
        if missing or removed:
            summary.append((locale_code, len(locale_values), len(missing), len(removed)))
        print(f"Processing {locale_code}: missing={len(missing)}, removed={len(removed)}")
        if args.dry_run:
            continue
        backup = make_backup(path) if not args.no_backup else None
        path.write_text("\n".join(output_lines).rstrip() + "\n", encoding="utf-8")
        if backup:
            print(f"  wrote {path}, backup {backup}")
        else:
            print(f"  wrote {path}")

    print("\nSummary:")
    for locale_code, _, missing, removed in summary:
        print(f" - {locale_code}: missing={missing}, removed={removed}")
