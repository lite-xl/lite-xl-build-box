#!/usr/bin/env bash

SCRIPT="$(mktemp)"

printf '%s' "$*" >> "$SCRIPT"

exec /bin/bash --login -e -o pipefail "$SCRIPT"
