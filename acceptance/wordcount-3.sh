#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-15
# Locked acceptance test for plans/wordcount-plan.md, slice 3.
# Proves AC-10 of specs/features/wordcount/S-003.md against scripts/wordcount.sh.
# Run from the repo root: bash acceptance/wordcount-3.sh
# Exits 0 only if every check passes.
set -u
target="scripts/wordcount.sh"
fails=0
nl='
'
usage='usage: bash scripts/wordcount.sh "<text>"'
usage_pipe='   or: <command> | bash scripts/wordcount.sh'

check() { # check <name> <want stdout> <want stderr> <want exit> [args...]
  # Both streams are compared byte for byte. $(...) drops trailing newlines,
  # so each capture ends with a sentinel "x" that is then cut off.
  # Standard input is /dev/null, so a build that reads it cannot hang.
  local name="$1" want_out="$2" want_err="$3" want_rc="$4"; shift 4
  local out err rc errfile
  errfile="$(mktemp)"
  out="$(bash "$target" "$@" </dev/null 2>"$errfile"; rc=$?; printf x; exit "$rc")"; rc=$?
  out="${out%x}"
  err="$(cat "$errfile"; printf x)"; err="${err%x}"
  rm -f "$errfile"
  if [ "$rc" -eq "$want_rc" ] && [ "$out" = "$want_out" ] && [ "$err" = "$want_err" ]; then
    echo "PASS $name: exit $rc"
  else
    echo "FAIL $name: want exit $want_rc, stdout $(printf '%q' "$want_out"), stderr $(printf '%q' "$want_err");" \
      "got exit $rc, stdout $(printf '%q' "$out"), stderr $(printf '%q' "$err")"
    fails=$((fails + 1))
  fi
}

# CHECK 1: more than one argument, usage shows both forms (AC-10)
check "AC-10 (two arguments)" "" "wordcount: more than one argument given; put the text in quotes${nl}${usage}${nl}${usage_pipe}${nl}" 2 hello world
check "AC-10 (three arguments)" "" "wordcount: more than one argument given; put the text in quotes${nl}${usage}${nl}${usage_pipe}${nl}" 2 a b c

[ "$fails" -eq 0 ] && echo "All wordcount slice 3 acceptance checks passed."
[ "$fails" -eq 0 ]
