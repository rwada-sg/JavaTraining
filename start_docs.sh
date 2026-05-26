#!/usr/bin/bash

set -euE -o pipefail

uv run mkdocs serve --livereload
