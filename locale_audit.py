import os
import re
from pathlib import Path

root = Path('e:/GIT/ElvUI_MerathilisUI/ElvUI_MerathilisUI/Locales')

locale_files = sorted([p for p in root.glob('*.lua')])

key_pattern = re.compile(r"L\[(?:'|")(.+?)(?:'|")\]\s*=")

for path in locale_files:
    keys = []
    for line in path.read_text(encoding='utf-8').splitlines():
        m = key_pattern.search(line)
        if m:
            keys.append(m.group(1))
    print(f"{path.name}: {len(keys)} keys")

# compare with enUS
base = root / 'enUS.lua'
base_keys = []
for line in base.read_text(encoding='utf-8').splitlines():
    m = key_pattern.search(line)
    if m:
        base_keys.append(m.group(1))
base_set = set(base_keys)
for path in locale_files:
    if path.name == 'enUS.lua':
        continue
    keys = []
    for line in path.read_text(encoding='utf-8').splitlines():
        m = key_pattern.search(line)
        if m:
            keys.append(m.group(1))
    missing = sorted(set(base_keys) - set(keys))
    extra = sorted(set(keys) - set(base_keys))
    print(f"\n{path.name}: missing {len(missing)}, extra {len(extra)}")
    if missing:
        print('  missing sample:', missing[:10])
    if extra:
        print('  extra sample:', extra[:10])
