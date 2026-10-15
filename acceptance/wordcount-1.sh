#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-14
# Locked acceptance test for plans/wordcount-plan.md, slice 1.
# Proves AC-1 to AC-4 of specs/features/wordcount/S-001.md against scripts/wordcount.sh.
# Run from the repo root: bash acceptance/wordcount-1.sh
# Exits 0 only if every check passes.
set -u
target="scripts/wordcount.sh"
fails=0
nl='
'
tab="$(printf '\t')"
cr="$(printf '\r')"
ff="$(printf '\f')"

check() { # check <name> <want stdout> <want stderr> <want exit> [args...]
  # Both streams are compared byte for byte. $(...) drops trailing newlines,
  # so each capture ends with a sentinel "x" that is then cut off.
  local name="$1" want_out="$2" want_err="$3" want_rc="$4"; shift 4
  local out err rc errfile
  errfile="$(mktemp)"
  out="$(bash "$target" "$@" 2>"$errfile"; rc=$?; printf x; exit "$rc")"; rc=$?
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

# CHECK 1: counting words (AC-1, AC-2, AC-4)
check "AC-1 (mixed separators)" "5${nl}" "" 0 "the quick  brown${tab}fox${nl}jumps"
check "AC-2 (separators at ends and repeated)" "2${nl}" "" 0 "  hello   world  "
check "AC-4 (carriage return is part of a word)" "1${nl}" "" 0 "a${cr}b"
check "AC-4 (form feed is part of a word)" "1${nl}" "" 0 "a${ff}b"
check "AC-4 (apostrophe)" "1${nl}" "" 0 "don't"
check "AC-4 (non-ASCII)" "2${nl}" "" 0 "日本語 テキスト"

# CHECK 2: zero words (AC-3)
check "AC-3 (empty text)" "0${nl}" "" 0 ""
check "AC-3 (separators only)" "0${nl}" "" 0 "  ${tab}${nl} "

# CHECK 3 (AC-5: two arguments, two-line message) retired in the slice 3
# plan: slice 3 adds the piped form to the usage message, and AC-10
# (acceptance/wordcount-3.sh) replaces it. senior-lead-Opus5.5-agent, 2026-10-15

[ "$fails" -eq 0 ] && echo "All wordcount slice 1 acceptance checks passed."
[ "$fails" -eq 0 ]
