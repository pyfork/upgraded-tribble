#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# slug: prints the title as a lowercase ASCII slug (specs/features/slug/S-001.md, AC-1, AC-2, AC-4, AC-5);
# rejects input that can't make one (S-002.md, AC-6 to AC-11);
# with SLUG_CUT=1, cuts a slug over 20 characters at a word boundary (S-003.md, AC-12 to AC-22).
set -euo pipefail
export LC_ALL=C
usage='usage: bash scripts/slug.sh "<title>"'
max=20
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
if [ "${SLUG_CUT:-}" = "1" ] && [ "${#slug}" -gt 20 ]; then
  cut="${slug:0:20}"
  # Drop a word the 20th character falls inside, unless it is the only word
  if [ "${slug:20:1}" != "-" ]; then
    case "$cut" in *-*) cut="${cut%-*}" ;; esac
  fi
  printf '%s\n' "$cut"
  echo "slug: cut to fit 20 characters; use a shorter title to choose the words" >&2
  exit 0
fi
printf '%s\n' "$slug"
