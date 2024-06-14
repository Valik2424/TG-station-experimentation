# pylint: disable-all

import re
import os

from xarray import map_blocks

MAPS_DIRECTORY = "_maps/map_files/BoxStation"
MAP_FILE_EXTENSION = ".dmm"
DOOR_NAME_PREFIX = "/obj/machinery/power/apc"
VARIABLE_NAME = ["pixel_x", "pixel_y"]
RANGE = [-25, 25]

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
        while (
            k > 0
            and VARIABLE_NAME[0] not in file_content[k]
            and VARIABLE_NAME[1] not in file_content[k]
        ):
            k -= 1

        if k == 0:
            continue

        variable_value = file_content[k].split(" = ")[-1]
        if ";" in variable_value:
            variable_value = variable_value.split(";")[0].strip()

        if int(variable_value) in RANGE:
            continue

        lines.append(k)

    lines = list(set(lines))
    lines.sort()

    for line in lines:
        value = file_content[line].split(" = ")[-1]
        if ";" in value:
            value = int(value.split(";")[0].strip())
        else:
            value = int(value.strip())

        if value < 0:
            value = RANGE[0]
        elif value > 0:
            value = RANGE[1]

        if value < 0:
            file_content[line] = re.sub(r"-(\d+)", str(value), file_content[line])
        else:
            file_content[line] = re.sub(r"(\d+)", str(value), file_content[line])

        print(f"Changed {file_content[line].strip()}")

    with open(map_file, "w", encoding="utf-8") as file:
        file.write("".join(file_content))
        print(f"Processed {map_file}")
