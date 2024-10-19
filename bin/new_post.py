#!/usr/bin/env python3

print("input name without an extension:")
file_name = input()

print("input post title:")
title = input()

typ_file_name = f"src/{file_name}.typ"
bib_file_name = f"src/{file_name}.bib"

with open(typ_file_name, "w+") as f:
    f.write(f"""#bibliography("{bib_file_name}")""")

with open(bib_file_name, "w") as f:
    pass
