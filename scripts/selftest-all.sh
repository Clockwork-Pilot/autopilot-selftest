#!/usr/bin/env bash
# Run both upstream and fork selftests back-to-back.
# Fails fast on the first mode that fails.
set -euo pipefail
here=$(dirname "$0")
"$here/selftest.sh" upstream "${1:-1}"
"$here/selftest.sh" fork     "${2:-1}"
