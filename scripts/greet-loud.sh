#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# greet-loud: prints "HELLO, <NAME>!" in capitals; no name becomes WORLD (AC-5).
echo "HELLO, ${1:-world}!" | tr '[:lower:]' '[:upper:]'
