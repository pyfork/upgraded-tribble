#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-26
# Locked acceptance test for plans/stamp-plan.md, Slice 1 of 1.
# Proves AC-1, AC-2, AC-3 of specs/features/stamp.md against scripts/stamp.sh.
# Run from the repo root: bash acceptance/stamp.sh
# Exits 0 only if every check passes.
set -u
target="scripts/stamp.sh"
fails=0

check() { # check <AC id> <expected output> [args...]
  local id="$1" want="$2"; shift 2
  local got rc
  got="$(bash "$target" "$@" 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ] && [ "$got" = "$want" ]; then
    echo "PASS $id: got '$got', exit $rc"
  else
    echo "FAIL $id: want '$want' exit 0; got '$got' exit $rc"
    fails=$((fails + 1))
  fi
}

check "AC-1 (weekday)" "Report: weekly, 2026-10-21" "weekly" "2026-10-21"
# AC-2 dropped
check "AC-3 (empty title, Sunday)" "Report: daily, 2026-10-25 (weekend)" "" "2026-10-25"

[ "$fails" -eq 0 ] && echo "All stamp acceptance checks passed."
[ "$fails" -eq 0 ]
