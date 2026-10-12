#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# Locked acceptance test for plans/slug-plan.md, slice 3.
# Proves AC-12 to AC-14, AC-17 and AC-18 of specs/features/slug/S-003.md
# against scripts/slug.sh.
# REGRESSION cases already pass before this slice. They guard behaviour the
# cut could break: AC-15, AC-16 and AC-19 to AC-21, plus AC-11 and AC-9 from
# earlier slices (tech review of #40, rows 1 and 2).
# Run from the repo root: bash acceptance/slug-3.sh
# Exits 0 only if every check passes.
set -u
target="scripts/slug.sh"
fails=0
nl='
'
usage='usage: bash scripts/slug.sh "<title>"'
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
whole='ten-tips-for-writing-better-shell-scripts'

# The cut and its notice: these fail before this slice
check "AC-12, AC-17 (41 characters: cut at a word boundary to 20)" 1 "ten-tips-for-writing${nl}" "${notice}${nl}" 0 "$long"
check "AC-13, AC-17 (28 characters: the word cut through is dropped, 17)" 1 "how-to-name-files${nl}" "${notice}${nl}" 0 'How to Name Files Well Today'
check "AC-14, AC-17 (first word over 20: its first 20 characters)" 1 "supercalifragilistic${nl}" "${notice}${nl}" 0 'Supercalifragilisticexpialidocious Day'
check_merged "AC-18 (one stream: slug first, notice second)" 1 "ten-tips-for-writing${nl}${notice}${nl}" "$long"

# REGRESSION: these pass before this slice
check "AC-15, AC-20 REGRESSION (SLUG_CUT unset: whole slug, stderr empty)" - "${whole}${nl}" "" 0 "$long"
check "AC-15, AC-20 REGRESSION (SLUG_CUT=0: whole slug, stderr empty)" 0 "${whole}${nl}" "" 0 "$long"
check "AC-15, AC-20 REGRESSION (SLUG_CUT=true: whole slug, stderr empty)" true "${whole}${nl}" "" 0 "$long"
check "AC-16, AC-19 REGRESSION (SLUG_CUT=1, 20 characters: unchanged, stderr empty)" 1 "ten-tips-for-writing${nl}" "" 0 'Ten Tips for Writing'
check "AC-19 REGRESSION (SLUG_CUT=1, 22-character title, 20-character slug)" 1 "ten-tips-for-writing${nl}" "" 0 'Ten Tips, for Writing!'
check "AC-11 REGRESSION (good title: stderr empty)" - "hello-world${nl}" "" 0 'Hello World!'
check "AC-6, AC-9 REGRESSION (three arguments)" - "" "slug: more than one argument given; put the title in quotes${nl}${usage}${nl}" 2 a b c
check "AC-21 REGRESSION (SLUG_CUT=1, no argument: AC-8)" 1 "" "slug: no title given${nl}${usage}${nl}" 2
check "AC-21 REGRESSION (SLUG_CUT=1, unquoted title: AC-9)" 1 "" "slug: more than one argument given; put the title in quotes${nl}${usage}${nl}" 2 Hello World
check "AC-21 REGRESSION (SLUG_CUT=1, no letter or digit: AC-10)" 1 "" "slug: the title needs at least one letter or digit (A-Z, a-z, 0-9)${nl}" 1 '!!!'

[ "$fails" -eq 0 ] && echo "All slug slice 3 acceptance checks passed."
[ "$fails" -eq 0 ]
