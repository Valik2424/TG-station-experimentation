import os
import re


def find_files(
    directory: str,
    search_pattern: str,
    exclude_filenames: set[str] = set(),
    verbose: bool = False,
) -> list[str]:
    res = []

    for root, dirs, files in os.walk(directory):
        for file in files:
            if re.match(search_pattern, file):
                if os.path.basename(os.path.splitext(file)[0]) in exclude_filenames:
                    continue

                res.append(os.path.join(root, file))
                if verbose:
                    print(os.path.join(root, file))

    return res


def replace_in_files(files: list[str], to_change: str, change_to: str) -> None:
    for file in files:
        with open(file, "r") as f:
            content = f.read()
        content = content.replace(to_change, change_to)
        with open(file, "w") as f:
            f.write(content)
