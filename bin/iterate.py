#!/usr/bin/env python3
import os

h = set(["src"])

s = "= Index\n<Index>\n"

for root, dirs, files in os.walk("src"):
    dirs.sort()
    files.sort()
    for name in files:
        rel_dir = os.path.relpath(root, ".")
        file_name = os.path.join(rel_dir, name)
        if file_name.lower().endswith("index.typ"):
            continue
        if file_name.lower().endswith(("typ")):
            split_file_name = file_name.split(".")
            if root[4:] and root[4:] not in h:
                h.add(root[4:])
                s += f"## {root[4:].title().replace('-', ' ').replace('/', ' > ')}\n\n"
            title_string = name.replace("-", " ").replace("_", " ")
            s += f"- #link(\"{file_name[4:]}\")[{file_name[4:]}]\n\n"

with open("src/index.typ", "w+") as f:
    f.write(s)
