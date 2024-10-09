# Academic Writing

This repo has a pandoc setup that allows you to easily write academic
style posts.

## Installation

You'll need [`pandoc`](https://github.com/jgm/pandoc) on your $PATH and [`pagefind`](https://github.com/CloudCannon/pagefind) to build a search index.

Otherwise, write away, using bibtex and pandoc markdown to generate HTML
pages that have linking to references and have references at the end of
sections.

A copy of
[Section Refs](https://github.com/pandoc/lua-filters/blob/master/section-refs/section-refs.lua)
is included in this repo to put references at the end of sections
instead of at the end of pages.

## Building

To build, run `make`, and to build the search index, run `make
build_index`. To run the deploy script (which currently deploys to
netlify), run `make deploy`.
