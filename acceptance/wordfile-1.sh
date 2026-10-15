#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-16
# Locked acceptance test for plans/wordfile-plan.md, slice 1.
# Proves AC-1 to AC-4 of specs/features/wordfile/S-001.md against scripts/wordfile.sh.
# Run from the repo root: bash acceptance/wordfile-1.sh
# Exits 0 only if every check passes.
set -u
target="$(pwd)/scripts/wordfile.sh"
fails=0
work="$(mktemp -d)"; outside="$(mktemp -d)"
trap 'rm -rf "$work" "$outside"' EXIT
mkdir "$work/in" "$work/in/sub"
printf 'one two  three' > "$work/in/notes.txt"
printf 'secret words here' > "$work/outside.txt"
printf 'x' > "$outside/far.txt"
ln -s "$outside/far.txt" "$work/in/link.txt"

check() { # check <name> <want stdout> <want stderr> <want exit> <path>
  local name="$1" want_out="$2" want_err="$3" want_rc="$4" path="$5" out err rc
  out="$(cd "$work/in" && bash "$target" "$path" 2>"$work/err"; rc=$?; printf x; exit "$rc")"; rc=$?
  out="${out%x}"; err="$(cat "$work/err"; printf x)"; err="${err%x}"
  if [ "$rc" -eq "$want_rc" ] && [ "$out" = "$want_out" ] && [ "$err" = "$want_err" ]; then
    echo "PASS $name: exit $rc"
  else
    echo "FAIL $name: want exit $want_rc, stdout $(printf '%q' "$want_out"), stderr $(printf '%q' "$want_err"); got exit $rc, stdout $(printf '%q' "$out"), stderr $(printf '%q' "$err")"
    fails=$((fails + 1))
  fi
}
nl='
'
refused() { printf 'wordfile: %s: not a file in this directory\n' "$1"; }

# CHECK 1: a file inside is counted (AC-1)
check "AC-1 (file inside)" "3${nl}" "" 0 "notes.txt"
# CHECK 2: paths outside are refused (AC-2, AC-3)
for p in /etc/hosts ../outside.txt ./sub/../../outside.txt link.txt; do
  check "AC-2/3 ($p)" "" "$(refused "$p")" 2 "$p"
done
# CHECK 3: not a regular file (AC-4)
for p in sub missing.txt; do
  check "AC-4 ($p)" "" "$(refused "$p")" 2 "$p"
done

[ "$fails" -eq 0 ]
