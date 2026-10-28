#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# bye-loud: prints "BYE, <NAME>!" in capitals; no name becomes WORLD (AC-5).
set -euo pipefail
echo "BYE, ${1:-world}!" | tr '[:lower:]' '[:upper:]'
