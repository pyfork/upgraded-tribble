#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# Locked acceptance test for plans/slug-plan.md, slice 4.
# CHECK 1 to 3 prove this slice's work (AC-23 to AC-27, AC-29 of
# specs/features/slug/S-004.md) against scripts/slug.sh; they fail before it.
# REGRESSION D already passes before this slice: a slug of 20 or fewer stays
# silent with or without a leftover SLUG_CUT (AC-28).
# Run from the repo root: bash acceptance/slug-4.sh
# Exits 0 only if every check passes.
set -u
target="scripts/slug.sh"
fails=0
nl='
'
notice='slug: cut to fit 20 characters; use a shorter title to choose the words'
run() { # run <SLUG_CUT value, or - for unset> [args...]
  if [ "$1" = "-" ]; then shift; env -u SLUG_CUT bash "$target" "$@"
  else local v="$1"; shift; env SLUG_CUT="$v" bash "$target" "$@"; fi
}

report() { # report <name> <ok 0|1> <want> <got>
  if [ "$2" -eq 1 ]; then echo "PASS $1"
  else echo "FAIL $1: want $3; got $4"; fails=$((fails + 1)); fi
}

check() { # check <name> <SLUG_CUT> <want stdout> <want stderr> <want exit> [args...]
  # Both streams are compared byte for byte. $(...) drops trailing newlines,
  # so each capture ends with a sentinel "x" that is then cut off.
  local name="$1" cut="$2" want_out="$3" want_err="$4" want_rc="$5"; shift 5
  local out err rc errfile ok=0
  errfile="$(mktemp)"
  out="$(run "$cut" "$@" 2>"$errfile"; rc=$?; printf x; exit "$rc")"; rc=$?
  out="${out%x}"
  err="$(cat "$errfile"; printf x)"; err="${err%x}"
  rm -f "$errfile"
  [ "$rc" -eq "$want_rc" ] && [ "$out" = "$want_out" ] && [ "$err" = "$want_err" ] && ok=1
  report "$name" "$ok" \
    "exit $want_rc, stdout $(printf '%q' "$want_out"), stderr $(printf '%q' "$want_err")" \
    "exit $rc, stdout $(printf '%q' "$out"), stderr $(printf '%q' "$err")"
}

check_merged() { # check_merged <name> <SLUG_CUT> <want both streams, in order> [args...]
  local name="$1" cut="$2" want="$3"; shift 3
  local got ok=0
  got="$(run "$cut" "$@" 2>&1; printf x)"; got="${got%x}"
  [ "$got" = "$want" ] && ok=1
  report "$name" "$ok" "$(printf '%q' "$want")" "$(printf '%q' "$got")"
}

long='Ten Tips for Writing Better Shell Scripts'

# CHECK 1: the cut runs on every run; SLUG_CUT changes nothing
check "CHECK 1, AC-23, AC-17 (SLUG_CUT unset: cut, with the notice)" - "ten-tips-for-writing${nl}" "${notice}${nl}" 0 "$long"
check "CHECK 1, AC-24 (SLUG_CUT=0: the same as unset)" 0 "ten-tips-for-writing${nl}" "${notice}${nl}" 0 "$long"
check "CHECK 1, AC-24 (SLUG_CUT=true: the same as unset)" true "ten-tips-for-writing${nl}" "${notice}${nl}" 0 "$long"
check "CHECK 1, AC-24 (SLUG_CUT=1: the same as unset)" 1 "ten-tips-for-writing${nl}" "${notice}${nl}" 0 "$long"
check_merged "CHECK 1, AC-29 (SLUG_CUT unset, one stream: slug first, notice second)" - "ten-tips-for-writing${nl}${notice}${nl}" "$long"
# CHECK 2: the limit is 20 exactly: a 21-character slug is cut (tech review of #42, row 1)
check "CHECK 2, AC-25, AC-17 (21 characters: cut)" - "ten-tips-for${nl}" "${notice}${nl}" 0 'Ten Tips for Writings'
# CHECK 3: a word cut that keeps under 10 characters keeps the first 20 instead (tech review of #42, row 2)
check "CHECK 3, AC-26, AC-27 (word cut keeps 1: first 20 instead)" - "a-supercalifragilist${nl}" "${notice}${nl}" 0 'a supercalifragilisticexpialidocious'
check "CHECK 3, AC-26 (word cut keeps 9: first 20 instead)" - "abcdefghi-jklmnopqrs${nl}" "${notice}${nl}" 0 'abcdefghi jklmnopqrstuvwxyz'
check "CHECK 3, AC-26 (word cut keeps 10: kept)" - "abcdefghij${nl}" "${notice}${nl}" 0 'abcdefghij klmnopqrstuvwxyz'

# REGRESSION D: nothing to cut means the slug unchanged and stderr empty, whatever SLUG_CUT holds
check "REGRESSION D, AC-28 (SLUG_CUT unset, 20 characters)" - "ten-tips-for-writing${nl}" "" 0 'Ten Tips for Writing'
check "REGRESSION D, AC-28 (SLUG_CUT=0, 22-character title, 20-character slug)" 0 "ten-tips-for-writing${nl}" "" 0 'Ten Tips, for Writing!'
check "REGRESSION D, AC-28 (SLUG_CUT=1, 20 characters)" 1 "ten-tips-for-writing${nl}" "" 0 'Ten Tips for Writing'

[ "$fails" -eq 0 ] && echo "All slug slice 4 acceptance checks passed."
[ "$fails" -eq 0 ]
