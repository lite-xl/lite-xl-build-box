#!/bin/bash

SCRIPT="$(mktemp)"

printf '%s' "$*" >> "$SCRIPT"

source /opt/rh/rh-python38/enable

exec /bin/bash --login -e -o pipefail "$SCRIPT"

