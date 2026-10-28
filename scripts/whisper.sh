#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# whisper: prints its text argument in lower case (AC-1).
printf '%s\n' "${1-}" | tr '[:upper:]' '[:lower:]'
