"""Generates ElvUI_MerathilisUI/Modules/MediaPlayer/Data.lua.

Sources (all public, nothing taken from other addons):
  - wago.tools DB2 exports: AreaTable, Map, ZoneMusic, SoundKitEntry
  - wowdev community listfile (file ID -> path), only sound/music/*

Usage:
  python .scripts/generate_media_data.py            # downloads the sources
  python .scripts/generate_media_data.py <dir>      # uses <dir>/<Table>.csv + listfile.csv

The track names live once in a "fileID name" block, every zone line is
"areaID|kind|English name|fileID,fileID,..." (folder entries carry areaID 0).
kind: z = zone, d = dungeon, r = raid, p = battleground/arena, s = scenario.
The addon localizes zone names at runtime through C_Map.GetAreaInfo(areaID).
"""

import collections
import csv
import os
import re
import sys
import tempfile
import urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT = os.path.join(ROOT, "ElvUI_MerathilisUI", "Modules", "MediaPlayer", "Data.lua")

TABLES = ("AreaTable", "Map", "ZoneMusic", "SoundKitEntry")
LISTFILE_URL = "https://github.com/wowdev/wow-listfile/releases/latest/download/community-listfile.csv"

# Map.InstanceType -> kind
KINDS = {"0": "z", "1": "d", "2": "r", "3": "p", "4": "p", "5": "s"}

# Internal/placeholder areas that never show up in the game
JUNK = re.compile(
    r"\b(test|unused|dev|dnt|temp|copy|ph|transition|do not use|deprecated|dummy)\b|\[|^(xx|zz)|testarea",
    re.IGNORECASE,
)

# Music folders that belong to an expansion; tracks no zone uses go there
FOLDER_EXPANSION = {
    "cataclysm": 3,
    "pandaria": 4,
    "draenor": 5,
    "legion": 6,
    "battleforazeroth": 7,
    "shadowlands": 8,
    "dragonflight": 9,
    "warwithin": 10,
    "midnight": 11,
}

# Remaining folders, shown in the "Various" category
FOLDER_NAMES = {
    "zonemusic": "Zone Music",
    "citymusic": "City Music",
    "classic": "Classic",
    "event": "Events",
    "worldevents": "World Events",
    "petbattles": "Pet Battles",
    "gluescreenmusic": "Login Screens",
    "musical moments": "Musical Moments",
    "forever": "Forever",
    "unknown": "Unknown",
}


def download(directory):
    for table in TABLES:
        url = "https://wago.tools/db2/%s/csv" % table
        print("downloading", url)
        urllib.request.urlretrieve(url, os.path.join(directory, table + ".csv"))
    print("downloading", LISTFILE_URL)
    urllib.request.urlretrieve(LISTFILE_URL, os.path.join(directory, "listfile.csv"))


def read_table(directory, name):
    with open(os.path.join(directory, name + ".csv"), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def read_listfile(directory):
    music = {}
    with open(os.path.join(directory, "listfile.csv"), encoding="utf-8") as f:
        for line in f:
            fid, _, path = line.rstrip("\r\n").partition(";")
            if path.startswith("sound/music/") and path.endswith((".mp3", ".ogg")):
                music[int(fid)] = path
    return music


def track_name(path):
    name = path[len("sound/music/") :].rsplit(".", 1)[0]
    # Drop the music folder, the zone or category already says where it is from
    name = name.split("/", 1)[-1]
    # One name per line inside a long bracket string
    return re.sub(r"[\r\n\]]", " ", name)


def lua_string(text):
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def main():
    if len(sys.argv) > 1:
        directory = sys.argv[1]
    else:
        directory = tempfile.mkdtemp(prefix="mer_media_")
        download(directory)

    music = read_listfile(directory)
    maps = {int(r["ID"]): r for r in read_table(directory, "Map")}
    zone_music = {int(r["ID"]): (int(r["Sounds_0"]), int(r["Sounds_1"])) for r in read_table(directory, "ZoneMusic")}

    kits = collections.defaultdict(list)
    for r in read_table(directory, "SoundKitEntry"):
        fid = int(r["FileDataID"])
        if fid in music:
            kits[int(r["SoundKitID"])].append(fid)

    def files_of(area):
        result = []
        for kit in zone_music.get(int(area["ZoneMusic"]), ()):
            result.extend(kits.get(kit, ()))
        return result

    areas = read_table(directory, "AreaTable")

    # Subzone music counts for its top-level zone
    sub_files = collections.defaultdict(list)
    for area in areas:
        parent = int(area["ParentAreaID"])
        if parent:
            sub_files[parent].extend(files_of(area))

    # (expansion, kind, name) -> [areaID, set of file IDs]
    zones = collections.OrderedDict()
    for area in areas:
        if area["ParentAreaID"] != "0":
            continue
        map_row = maps.get(int(area["ContinentID"]))
        if not map_row:
            continue
        kind = KINDS.get(map_row["InstanceType"])
        name = area["AreaName_lang"].strip()
        if not kind or not name or JUNK.search(name) or JUNK.search(map_row["MapName_lang"]):
            continue

        files = set(files_of(area)) | set(sub_files.get(int(area["ID"]), ()))
        if not files:
            continue

        key = (int(map_row["ExpansionID"]), kind, name)
        if key not in zones:
            zones[key] = [int(area["ID"]), set()]
        zones[key][1] |= files

    used = set()
    for _, files in zones.values():
        used |= files

    # Tracks no zone plays, grouped by their music folder
    leftovers = collections.defaultdict(set)
    for fid, path in music.items():
        if fid not in used:
            leftovers[path.split("/")[2] if path.count("/") > 2 else "unknown"].add(fid)

    expansions = collections.defaultdict(list)
    for (expansion, kind, name), (area_id, files) in zones.items():
        expansions[expansion].append((kind, name, area_id, files))

    various = []
    for folder, files in sorted(leftovers.items()):
        if folder in FOLDER_EXPANSION:
            expansions[FOLDER_EXPANSION[folder]].append(("o", "Other Music", 0, files))
        else:
            various.append(("o", FOLDER_NAMES.get(folder, folder.title()), 0, files))

    def lines(entries):
        out = []
        order = {"z": 0, "d": 1, "r": 2, "p": 3, "s": 4, "o": 5}
        for kind, name, area_id, files in sorted(entries, key=lambda e: (order[e[0]], e[1].lower())):
            tracks = sorted(files, key=lambda f: music[f])
            body = ",".join(str(f) for f in tracks)
            out.append("\t\t%s," % lua_string("%d|%s|%s|%s" % (area_id, kind, name, body)))
        return out

    total = sum(len(e[3]) for v in expansions.values() for e in v) + sum(len(e[3]) for e in various)

    out = [
        "local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)",
        'local module = MER:GetModule("MER_MediaPlayer") ---@class MediaPlayer',
        "",
        "-- GENERATED by .scripts/generate_media_data.py from wago.tools DB2 exports and the",
        "-- wowdev community listfile, do not edit by hand. %d tracks." % total,
        "-- Plain strings until the Media Player is opened the first time, see Core.lua.",
        "-- Zone line: areaID|kind|English name|fileID,fileID,...",
        "",
        "module.MusicData = {",
        "	names = [[",
    ]
    for fid in sorted(music, key=lambda f: music[f]):
        out.append("%d %s" % (fid, track_name(music[fid])))
    out.append("]],")
    for expansion in sorted(expansions):
        out.append("\t[%d] = {" % expansion)
        out.extend(lines(expansions[expansion]))
        out.append("\t},")
    out.append("\tvarious = {")
    out.extend(lines(various))
    out.append("\t},")
    out.append("}")

    os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
    # CRLF like the rest of the repo (.editorconfig)
    with open(OUTPUT, "w", encoding="utf-8", newline="\r\n") as f:
        f.write("\n".join(out) + "\n")

    print("wrote", OUTPUT, "-", len(zones), "zones,", total, "tracks")


if __name__ == "__main__":
    main()
