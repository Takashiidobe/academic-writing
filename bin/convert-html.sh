#!/usr/bin/env bash

find site/ -name '*.html' -exec sed -i '/^[^				View history for this file: ]/s/\.md/\.html/g' {} +
