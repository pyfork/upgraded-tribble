#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# greet-shout: prints "HELLO, <NAME>!" in capitals; no name becomes WORLD (AC-4).
set -euo pipefail
echo "HELLO, ${1:-world}!" | tr '[:lower:]' '[:upper:]'
