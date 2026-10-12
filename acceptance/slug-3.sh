#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-12
# Locked acceptance test for plans/slug-plan.md, slice 3.
# CHECK 1 to 3 prove this slice's work (AC-12 to AC-14, AC-17, AC-18, AC-22
# of specs/features/slug/S-003.md) against scripts/slug.sh; they fail before it.
# REGRESSION A to C already pass before this slice. They guard behaviour the
# cut could break (AC-15, AC-16, AC-19 to AC-21; AC-11 from slice 2) and carry
# AC-9's three-argument form from the tech review of #40.
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

# CHECK 1: a slug over 20 characters is cut at a word boundary, with the notice
check "CHECK 1, AC-12, AC-17 (41 characters: cut after a whole word, 20)" 1 "ten-tips-for-writing${nl}" "${notice}${nl}" 0 "$long"
check "CHECK 1, AC-13, AC-17 (20th character inside a word: that word dropped, 17)" 1 "how-to-name-files-we${nl}" "${notice}${nl}" 0 'How to Name Files Well Today'
check "CHECK 1, AC-22, AC-17 (20th character is a -: no - at the end, 19)" 1 "aaaa-bbbb-cccc-dddd${nl}" "${notice}${nl}" 0 'Aaaa Bbbb Cccc Dddd Eeee'
# CHECK 2: a first word over 20 characters is cut at 20, with the notice
check "CHECK 2, AC-14, AC-17 (first word over 20: its first 20 characters)" 1 "supercalifragilistic${nl}" "${notice}${nl}" 0 'Supercalifragilisticexpialidocious Day'
# CHECK 3: both streams in one place, slug first, notice second
check_merged "CHECK 3, AC-18 (one stream: slug first, notice second)" 1 "ten-tips-for-writing${nl}${notice}${nl}" "$long"

# REGRESSION A: the flag off means no cut and no notice
check "REGRESSION A, AC-15, AC-20 (SLUG_CUT unset: whole slug, stderr empty)" - "${whole}${nl}" "" 0 "$long"
check "REGRESSION A, AC-15, AC-20 (SLUG_CUT=0: whole slug, stderr empty)" 0 "${whole}${nl}" "" 0 "$long"
check "REGRESSION A, AC-15, AC-20 (SLUG_CUT=true: whole slug, stderr empty)" true "${whole}${nl}" "" 0 "$long"
# REGRESSION B: nothing to cut means the slug unchanged and stderr empty
check "REGRESSION B, AC-16, AC-19 (SLUG_CUT=1, 20 characters)" 1 "ten-tips-for-writing${nl}" "" 0 'Ten Tips for Writing'
check "REGRESSION B, AC-19 (SLUG_CUT=1, 22-character title, 20-character slug)" 1 "ten-tips-for-writing${nl}" "" 0 'Ten Tips, for Writing!'
check "REGRESSION B, AC-11 (good title, SLUG_CUT unset)" - "hello-world${nl}" "" 0 'Hello World!'
# REGRESSION C: slice 2's errors unchanged
check "REGRESSION C, AC-21, AC-8 (SLUG_CUT=1, no argument)" 1 "" "slug: no title given${nl}${usage}${nl}" 2
check "REGRESSION C, AC-21, AC-9 (SLUG_CUT=1, unquoted title)" 1 "" "slug: more than one argument given; put the title in quotes${nl}${usage}${nl}" 2 Hello World
check "REGRESSION C, AC-6, AC-9 (three arguments, from the tech review of #40)" - "" "slug: more than one argument given; put the title in quotes${nl}${usage}${nl}" 2 a b c
check "REGRESSION C, AC-21, AC-10 (SLUG_CUT=1, no letter or digit)" 1 "" "slug: the title needs at least one letter or digit (A-Z, a-z, 0-9)${nl}" 1 '!!!'

[ "$fails" -eq 0 ] && echo "All slug slice 3 acceptance checks passed."
[ "$fails" -eq 0 ]
