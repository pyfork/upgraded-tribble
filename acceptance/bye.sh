#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-06
# Locked acceptance test for plans/bye-plan.md, Slice 1 of 1.
# Proves AC-1, AC-2, AC-3 of specs/features/bye.md against scripts/bye.sh.
# Run from the repo root: bash acceptance/bye.sh
# Exits 0 only if every check passes.
set -u
target="scripts/bye.sh"
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

check "AC-1 (name given)" "Bye, Ada!" "Ada"
check "AC-2 (no argument)" "Bye, world!"
check "AC-3 (empty argument)" "Bye, world!" ""

[ "$fails" -eq 0 ] && echo "All bye acceptance checks passed."
[ "$fails" -eq 0 ]
