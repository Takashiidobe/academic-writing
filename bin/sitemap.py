#!/usr/bin/env python3

import glob
from pathlib import Path
from pathlib import Path
from subprocess import run

print('<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="./sitemap.xsl"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
for f in sorted(glob.glob("./src/**/*.md", recursive=True)):
    last_mod_res = run(['git', 'log', '-1', '--follow', '--format=%aI', '--date=iso-local', f], capture_output=True)
    pub_res = run(['git', 'log', '-1', '--diff-filter=A', '--follow', '--format=%aI', '--date=iso-local', f], capture_output=True)
    f = f.replace('.md', '.html')
    print(f"<url><loc>{f.replace('src', '')}</loc>")
    last_modified = last_mod_res.stdout.strip().decode('utf-8')
    print(f"<lastmod>{last_modified}</lastmod>")
    published = pub_res.stdout.strip().decode('utf-8')
    print(f"<pubdate>{published}</pubdate>")
    print("</url>")
print("</urlset>")
