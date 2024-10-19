SOURCE_DOCS := $(shell find src -type f -name "*.typ")
OUT_DIR=site

HTML_FILES=$(SOURCE_DOCS:src/%.typ=site/%.html)

all: iterate fix_links html copy_files

iterate:
	./bin/iterate.py

deploy: html fix_links copy_files build_index
	ntl deploy --prod

html: mkdirs $(HTML_FILES)

site/%.html: src/%.typ src/%.bib templates/site.html
	pandoc -M link-citations=true --citeproc \
		-f typst -s $< -o $@ \
		--bibliography=$(shell printf "%sbib" `echo $< | rev | cut -c 4- | rev`) \
		--wrap=preserve \
	  --table-of-contents --mathjax \
 		--lua-filter=section-refs.lua \
		-M reference-section-title=References \
		-M section-refs-level=2 \
		--reference-location=section \
		-V curr_file=$< \
		--filter d2-filter --section-divs --template templates/site.html

build_index: $(SOURCE_DOCS)
	pagefind --site site

copy_files: templates/main.js
	cp templates/*{.css,.js} site/

fix_links: $(HTML_FILES)
	./bin/convert-html.sh

clean:
	find site -name "*.html" -type f -delete

$(OUT_DIR)/robots.txt:
	@echo "User-agent: *" > $@
	@echo "Allow: *" >> $@
	@echo "Sitemap: $(BASE_URL)/sitemap.xml" >> $@

$(OUT_DIR)/sitemap.xml: $(HTML_FILES)
	./bin/sitemap.py > site/sitemap.xml

$(OUT_DIR)/rss.xml: $(HTML_FILES)
	./bin/rss.sh

.PHONY: mkdirs
mkdirs:
	rsync -a --include='*/' \
	--include="*.png" \
	--include="*.jpg" \
	--include="*.jpeg" \
	--include="*.gif" \
	--exclude='*' src/ site/
	rsync -a --include='*/' \
	--include="*.png" \
	--include="*.jpg" \
	--include="*.jpeg" \
	--include="*.svg" \
	--include="*.gif" \
	--exclude='*' src/img/ site/img
	rsync -a --include='*/' \
	--include="*.xml" \
	--include="*.xsl" \
	--exclude='*' assets/ site/
