#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# greet-dated: prints "Hello, <name>! (<date>)" (AC-5).
set -euo pipefail
day="${2:-$(date +%F)}"
echo "Hello, ${1:-world}! ($day)"
