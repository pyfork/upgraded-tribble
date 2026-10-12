#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# Locked acceptance test for plans/slug-plan.md, slice 1.
# Proves AC-1, AC-2, AC-4, AC-5 of specs/features/slug/S-001.md against scripts/slug.sh.
# Re-planned 2026-10-12: AC-3 retired (it pinned a slug longer than the end goal allows);
# AC-5 added (a line break is a separator; found by the tech review of the build PR).
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
check "AC-4 (runs of separators become one -)" "top-10-tips" "Top 10 -- tips!!"
check "AC-5 (a line break is a separator)" "hello-world" "$(printf 'Hello\nWorld')"

[ "$fails" -eq 0 ] && echo "All slug slice 1 acceptance checks passed."
[ "$fails" -eq 0 ]
