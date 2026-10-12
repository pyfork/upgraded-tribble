#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# slug: prints the title as a lowercase ASCII slug (specs/features/slug/S-001.md, AC-1, AC-2, AC-4, AC-5);
# rejects input that can't make one (S-002.md, AC-6 to AC-11).
set -euo pipefail
export LC_ALL=C
usage='usage: bash scripts/slug.sh "<title>"'
if [ "$#" -eq 0 ]; then
  printf '%s\n%s\n' "slug: no title given" "$usage" >&2
  exit 2
fi
if [ "$#" -gt 1 ]; then
  printf '%s\n%s\n' "slug: more than one argument given; put the title in quotes" "$usage" >&2
  exit 2
fi
slug="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-')"
slug="${slug#-}"
slug="${slug%-}"
if [ -z "$slug" ]; then
  echo "slug: the title needs at least one letter or digit (A-Z, a-z, 0-9)" >&2
  exit 1
fi
printf '%s\n' "$slug"
