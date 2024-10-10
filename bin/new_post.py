#!/usr/bin/env python3

print("input name without an extension:")
file_name = input()

print("input post title:")
title = input()

md_file_name = f"src/{file_name}.md"
bib_file_name = f"src/{file_name}.bib"

with open(md_file_name, "w+") as f:
    f.write(f"""---
title: "{title}"
bibliography: "{bib_file_name}"
---
""")

with open(bib_file_name, "w") as f:
    pass
