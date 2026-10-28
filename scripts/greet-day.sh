#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# greet-day: prints "Hello, <name>! (<date>)" (AC-6).
set -euo pipefail
day="${2:-$(date +%F)}"
echo "$day: Hello, ${1:-world}!"
