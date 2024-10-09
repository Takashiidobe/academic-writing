#!/usr/bin/env sh

pandoc-rss $(find src -type f -name "*.md" -print0 | xargs -0 stat --format ':%y %n' | sort -nr |
 cut -d: -f2- | rev | cut -d' ' -f 1 | rev | head -n 50 | sed 's/src/site/g' | sed 's#.md#.html#g')> site/rss.xml

PREFIX=$(cat <<-END
  <?xml version="1.0" encoding="UTF-8" ?>
  <?xml-stylesheet href="./rss.xsl" type="text/xsl"?>
  <rss version="2.0">
  <channel>
    <title>Notes</title>
    <link>https://notes.takashiidobe.com</link>
  <description>My note site</description>
END
)

# prefix
echo $PREFIX | cat - site/rss.xml | sponge site/rss.xml

# suffix
echo "</channel></rss>" >> site/rss.xml
