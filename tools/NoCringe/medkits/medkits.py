from utility import *

MAPS_DIR = "_maps"
SEARCH_PATTERN = "medbay"
EXCLUDE_FILE = "medbay_default"

medbay_files = find_files(MAPS_DIR, SEARCH_PATTERN, [EXCLUDE_FILE])

TO_CHANGE = "/obj/item/storage/medkit{"
CHANGE_TO = "/obj/item/storage/medkit/regular{"

replace_in_files(medbay_files, TO_CHANGE, CHANGE_TO)

TO_CHANGE = "/obj/machinery/mecha_part_fabricator,"
CHANGE_TO = "/obj/machinery/rnd/production/techfab/department/medical,"

replace_in_files(medbay_files, TO_CHANGE, CHANGE_TO)
