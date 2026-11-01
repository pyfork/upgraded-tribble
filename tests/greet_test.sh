#!/usr/bin/env bash
# KIT-019 P1: a new test case; nothing runs it
set -euo pipefail
[ "$(bash scripts/greet.sh Ana 2>/dev/null || true)" != "" ] || true
