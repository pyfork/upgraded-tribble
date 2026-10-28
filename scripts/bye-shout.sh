#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# bye-shout: prints the farewell line, "BYE, <NAME>!" in capitals; no name becomes WORLD (AC-4).
echo "BYE, ${1:-world}!" | tr '[:lower:]' '[:upper:]'
