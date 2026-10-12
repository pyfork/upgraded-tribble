#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# Locked acceptance test for plans/slug-plan.md, slice 2.
# Proves AC-6 to AC-10 of specs/features/slug/S-002.md against scripts/slug.sh.
# AC-11 has no check here: it already holds, so a check would pass before the work.
# Run from the repo root: bash acceptance/slug-2.sh
# Exits 0 only if every check passes.
set -u
target="scripts/slug.sh"
fails=0
usage='usage: bash scripts/slug.sh "<title>"'

check() { # check <name> <want stdout> <want stderr> <want exit> [args...]
  local name="$1" want_out="$2" want_err="$3" want_rc="$4"; shift 4
  local out err rc errfile
  errfile="$(mktemp)"
  out="$(bash "$target" "$@" 2>"$errfile")"; rc=$?
  err="$(cat "$errfile")"; rm -f "$errfile"
  if [ "$rc" -eq "$want_rc" ] && [ "$out" = "$want_out" ] && [ "$err" = "$want_err" ]; then
    echo "PASS $name: exit $rc"
  else
    echo "FAIL $name: want exit $want_rc, stdout '$want_out', stderr '$want_err'; got exit $rc, stdout '$out', stderr '$err'"
    fails=$((fails + 1))
  fi
}

check "AC-6, AC-8 (no argument)" "" "slug: no title given
$usage" 2
check "AC-6, AC-9 (more than one argument)" "" "slug: more than one argument given; put the title in quotes
$usage" 2 Hello World
check "AC-7, AC-10 (no ASCII letter or digit)" "" "slug: the title needs at least one letter or digit (A-Z, a-z, 0-9)" 1 '!!!'

[ "$fails" -eq 0 ] && echo "All slug slice 2 acceptance checks passed."
[ "$fails" -eq 0 ]
