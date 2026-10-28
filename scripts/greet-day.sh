#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# greet-day: prints "<date>: Hello, <name>!" (AC-6). The date is an
# argument, never the system clock (engineering rules 10).
set -euo pipefail
day="${2:?usage: greet-day.sh <name> <YYYY-MM-DD>}"
echo "$day: Hello, ${1:-world}!"
