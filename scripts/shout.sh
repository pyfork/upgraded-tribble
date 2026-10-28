#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# shout: prints its text argument in capitals (AC-1).
printf '%s\n' "${1-}" | tr '[:lower:]' '[:upper:]'
