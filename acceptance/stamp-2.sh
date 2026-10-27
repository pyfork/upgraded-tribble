#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-27
# Locked acceptance test for plans/stamp-plan.md, Slice 2.
# Proves AC-4, AC-5 of specs/features/stamp.md against scripts/stamp.sh.
# Run from the repo root: bash acceptance/stamp-2.sh
# Exits 0 only if every check passes.
set -u
target="scripts/stamp.sh"
usage="usage: bash scripts/stamp.sh <title> <YYYY-MM-DD>"
fails=0

refused() { # refused <AC id> [args...]: nothing on stdout, the usage line on stderr, exit 2
  local id="$1"; shift
  local out err rc
  out="$(bash "$target" "$@" 2>"${TMPDIR:-/tmp}/stamp-err.$$")"; rc=$?
  err="$(cat "${TMPDIR:-/tmp}/stamp-err.$$")"; rm -f "${TMPDIR:-/tmp}/stamp-err.$$"
  if [ "$rc" -eq 2 ] && [ -z "$out" ] && [ "$err" = "$usage" ]; then
    echo "PASS $id: exit 2, usage on stderr"
  else
    echo "FAIL $id: want exit 2, no stdout, stderr '$usage'; got exit $rc, stdout '$out', stderr '$err'"
    fails=$((fails + 1))
  fi
}

# CHECK 1: a date not written YYYY-MM-DD, or none, is refused (AC-4, AC-5)
refused "AC-4 (date 21-10-2026)" "weekly" "21-10-2026"
refused "AC-5 (no date)" "weekly"

[ "$fails" -eq 0 ] && echo "All stamp slice 2 acceptance checks passed."
[ "$fails" -eq 0 ]
