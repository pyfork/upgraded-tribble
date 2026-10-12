#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# Locked acceptance test for plans/slug-plan.md, slice 1.
# Proves AC-1, AC-2, AC-3 of specs/features/slug/S-001.md against scripts/slug.sh.
# Run from the repo root: bash acceptance/slug-1.sh
# Exits 0 only if every check passes.
set -u
target="scripts/slug.sh"
fails=0

check() { # check <AC id> <expected output> <title>
  local id="$1" want="$2" title="$3"
  local got rc
  got="$(bash "$target" "$title" 2>/dev/null)"; rc=$?
  if [ "$rc" -eq 0 ] && [ "$got" = "$want" ]; then
    echo "PASS $id: got '$got', exit $rc"
  else
    echo "FAIL $id: want '$want' exit 0; got '$got' exit $rc"
    fails=$((fails + 1))
  fi
}

check "AC-1 (plain title)" "hello-world" "Hello World!"
check "AC-2 (non-ASCII bytes are separators)" "caf-au-lait" "  Café, au lait!  "
check "AC-3 (long title, uncut)" "a-long-title-with-many-words-in-it" "A long title with many words in it"

[ "$fails" -eq 0 ] && echo "All slug slice 1 acceptance checks passed."
[ "$fails" -eq 0 ]
