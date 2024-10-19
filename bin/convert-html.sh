#!/usr/bin/env bash

find site/ -name '*.html' -exec sed -i '/^[^				View history for this file: ]/s/\.typ/\.html/g' {} +
