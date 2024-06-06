#!/bin/bash

SCRIPT="$(mktemp)"

printf '#!/bin/bash\n' > "$SCRIPT"
printf '%s' "$*" >> "$SCRIPT"

exec /bin/bash --login -e -o pipefail "$SCRIPT"
