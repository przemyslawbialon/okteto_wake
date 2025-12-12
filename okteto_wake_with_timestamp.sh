#!/bin/bash

add_timestamp() {
    while IFS= read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line"
    done
}

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting okteto namespace wake..."
/usr/local/bin/okteto namespace wake 2>&1 | add_timestamp
exit_code=${PIPESTATUS[0]}
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Finished with exit code: $exit_code"
exit $exit_code

