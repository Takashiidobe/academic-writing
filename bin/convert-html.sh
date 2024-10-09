#!/usr/bin/env bash

find site/ -name '*.html' -exec sed -i 's/\.md/\.html/g' {} +
