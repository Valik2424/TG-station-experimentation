# pylint: disable-all

import re
import os
MAPS_DIRECTORY = "code/datums/quirks"
MAP_FILE_EXTENSION = ".dm"
EXCLUDED_FILE = "_quirk.dm"
# REGEX_PATTERN = r"\"\w+\" = \("
# DOOR_NAMES = ["/obj/machinery/door/airlock/external"]
# TINYFAN = "/obj/structure/fans/tiny,\n"

quirk_files = []
for root, _, files in os.walk(MAPS_DIRECTORY):
    for file in files:
        if file.endswith(MAP_FILE_EXTENSION) and file != EXCLUDED_FILE:
            quirk_files.append(os.path.join(root, file))

for quirk_file in quirk_files:
    file = open(quirk_file, "r", encoding="utf-8")
    print(f"Processing {quirk_file}")

    file_content = file.readlines()
    file.close()

    for i, line in enumerate(file_content):
        if line.startswith('/datum/quirk/'):
            # get the name of the quirk
            quirk_name = line.split('/')[-1].strip()
            next_line = file_content[i+1]
            if '	name = ' in next_line:
                file_content[i+1] = next_line.replace('name = ', 'name_ru = ')
                # insert new line before next_line
                file_content.insert(i+1, f'	name = "{quirk_name}"\n')

    file = open(quirk_file, "w", encoding="utf-8")
    file.writelines(file_content)
