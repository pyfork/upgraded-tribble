#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-15
# Locked acceptance test for plans/wordcount-plan.md, slice 2.
# Proves AC-6 to AC-9 of specs/features/wordcount/S-002.md against scripts/wordcount.sh,
# plus REGRESSION A (glob characters as the argument; tech review of #59, row 1).
# Run from the repo root: bash acceptance/wordcount-2.sh
# Exits 0 only if every check passes.
set -u
target="scripts/wordcount.sh"
fails=0
nl='
'
tab="$(printf '\t')"
cr="$(printf '\r')"
ff="$(printf '\f')"

check() { # check <name> <stdin> <want stdout> <want stderr> <want exit> [args...]
  # <stdin> is piped in exactly, byte for byte; "NONE" means /dev/null.
  # Both streams are compared byte for byte. $(...) drops trailing newlines,
  # so each capture ends with a sentinel "x" that is then cut off.
  local name="$1" input="$2" want_out="$3" want_err="$4" want_rc="$5"; shift 5
  local out err rc errfile
  errfile="$(mktemp)"
  if [ "$input" = "NONE" ]; then
    out="$(bash "$target" "$@" 2>"$errfile" </dev/null; rc=$?; printf x; exit "$rc")"; rc=$?
  else
    out="$(printf '%s' "$input" | bash "$target" "$@" 2>"$errfile"; rc=$?; printf x; exit "$rc")"; rc=$?
  fi
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

# CHECK 1: counting words on standard input (AC-6, AC-8)
check "AC-6 (mixed separators, final newline)" "the quick  brown${tab}fox${nl}jumps${nl}" "5${nl}" "" 0
check "AC-6 (mixed separators, no final newline)" "the quick  brown${tab}fox${nl}jumps" "5${nl}" "" 0
check "AC-6 (separators at ends and repeated)" "${nl}  hello   world  ${nl}${nl}" "2${nl}" "" 0
check "AC-8 (carriage return is part of a word)" "a${cr}b${nl}" "1${nl}" "" 0
check "AC-8 (form feed is part of a word)" "a${ff}b" "1${nl}" "" 0
check "AC-8 (apostrophe)" "don't" "1${nl}" "" 0
check "AC-8 (non-ASCII)" "日本語 テキスト${nl}" "2${nl}" "" 0
check "AC-8 (glob character)" "*${nl}" "1${nl}" "" 0
check "AC-8 (backslash is part of a word)" "a\\${nl}b\\${nl}" "2${nl}" "" 0

# CHECK 2: zero words on standard input (AC-7)
check "AC-7 (nothing piped)" "NONE" "0${nl}" "" 0
check "AC-7 (separators only)" "  ${tab}${nl} ${nl}" "0${nl}" "" 0

# REGRESSION A: glob characters as the argument are never expanded.
# Passes before; locked for the tech review of #59, row 1. Run from the
# repo root, where * matches many files: * is the case that guards the
# globbing setting; a? and [ab] match nothing there today.
check "REGRESSION A (*)" "NONE" "1${nl}" "" 0 "*"
check "REGRESSION A (a?)" "NONE" "1${nl}" "" 0 "a?"
check "REGRESSION A ([ab])" "NONE" "1${nl}" "" 0 "[ab]"

# REGRESSION B: an argument wins over piped text (AC-9), even an empty
# one (AC-3). Passes before.
check "REGRESSION B, AC-9 (argument and piped text)" "a b c${nl}" "2${nl}" "" 0 "hello world"
check "REGRESSION B, AC-9 (empty argument and piped text)" "a b c${nl}" "0${nl}" "" 0 ""

[ "$fails" -eq 0 ] && echo "All wordcount slice 2 acceptance checks passed."
[ "$fails" -eq 0 ]
