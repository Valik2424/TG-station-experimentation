# pylint: disable-all

import re
import os

MAPS_DIRECTORY = "_maps"
MAPS_SUBDIRECTORIES = ["map_files", "shuttles"]
MAP_FILE_EXTENSION = ".dmm"
REGEX_PATTERN = r"\"\w+\" = \("
DOOR_NAMES = ["/obj/machinery/door/airlock/external"]
TINYFAN = "/obj/structure/fans/tiny,\n"

map_files = []
for subdir in MAPS_SUBDIRECTORIES:
    subdir_path = os.path.join(MAPS_DIRECTORY, subdir)
    for root, _, files in os.walk(subdir_path):
        for file in files:
            if file.endswith(MAP_FILE_EXTENSION):
                map_files.append(os.path.join(root, file))

for map_file in map_files:
    file = open(map_file, "r")
    print(f"Processing {map_file}")

    file_content = file.readlines()
    file.close()

    tinyfans_added = 0

    for i, line in enumerate(file_content):
        if not re.search(REGEX_PATTERN, line):
            continue

        j = i + 1
        while j < len(file_content) and ")" not in file_content[j]:
            j += 1

        door_index_start = next(
            (
                k
                for k in range(i, j)
                if any(door_name in file_content[k] for door_name in DOOR_NAMES)
            ),
            -1,
        )
        if door_index_start == -1:
            continue

        door_index_end = -1
        if file_content[door_index_start].endswith("{\n"):
            for k in range(door_index_start, j):
                if file_content[k].endswith("},\n"):
                    door_index_end = k
                    break

        if door_index_end == -1:
            door_index_end = door_index_start

        if file_content[door_index_end + 11] == TINYFAN:
            continue

        file_content.insert(door_index_end + 1, TINYFAN)
        tinyfans_added += 1

    if tinyfans_added > 0:
        file = open(map_file, "w")
        file.writelines(file_content)
        file.close()

        print(f"Added {tinyfans_added} tinyfans")
