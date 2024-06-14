# pylint: disable-all

import re
import os

from xarray import map_blocks

MAPS_DIRECTORY = "_maps"
MAP_FILE_EXTENSION = ".dmm"
DOOR_NAME_PREFIX = "/obj/machinery/door/"
VARIABLE_NAME = "name"

map_files = []
for root, _, files in os.walk(MAPS_DIRECTORY):
    for file in files:
        if file.endswith(MAP_FILE_EXTENSION):
            map_files.append(os.path.join(root, file))


for map_file in map_files:
    file = open(map_file, "r", encoding="utf-8")
    print(f"Processing {map_file}")
    file_content = file.readlines()
    file.close()

    lines = []

    for i, line in enumerate(file_content):
        if not line.startswith(DOOR_NAME_PREFIX):
            continue

        door_index_start = i

        j = i + 1
        while j < len(file_content) and "}" not in file_content[j]:
            j += 1

        door_index_end = j

        k = j
        while k > 0 and VARIABLE_NAME not in file_content[k]:
            k -= 1

        if k == 0:
            continue

        variable_value = file_content[k].split(" = ")[-1]
        if variable_value.isupper():
            continue

        lines.append(k)

    lines = list(set(lines))
    lines.sort()

    if lines:
        for line in lines:
            file_content[line] = re.sub(
                r"\"(.+?)\"", lambda x: x.group(0).upper(), file_content[line]
            )
            print(f"Changed {file_content[line].strip()}")

        with open(map_file, "w", encoding="utf-8") as file:
            file.write("".join(file_content))
            print(f"Processed {map_file}")
