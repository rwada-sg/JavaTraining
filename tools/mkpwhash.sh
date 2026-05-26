#!/usr/bin/bash

set -eEuo pipefail

echo -n "$@" | argon2 $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1) -id -e -m 14 -t 2 -p 1 -l 32
