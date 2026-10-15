#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-15
# wordcount: prints the number of words in the text as a bare number
# (specs/features/wordcount/S-001.md, AC-1 to AC-5). Words are split on
# space, tab and newline only; every other byte is part of a word.
set -euo pipefail
export LC_ALL=C
usage='usage: bash scripts/wordcount.sh "<text>"'
if [ "$#" -eq 0 ]; then
  printf '%s\n%s\n' "wordcount: no text given" "$usage" >&2
  exit 2
fi
if [ "$#" -gt 1 ]; then
  printf '%s\n%s\n' "wordcount: more than one argument given; put the text in quotes" "$usage" >&2
  exit 2
fi
set -f
IFS=$' \t\n'
words=($1)
printf '%s\n' "${#words[@]}"
