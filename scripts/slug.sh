#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# slug: prints the title as a lowercase ASCII slug (specs/features/slug/S-001.md, AC-1, AC-2, AC-4, AC-5).
set -euo pipefail
export LC_ALL=C
slug="$(printf '%s' "${1:-}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-')"
slug="${slug#-}"
slug="${slug%-}"
printf '%s\n' "$slug"
