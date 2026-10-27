#!/usr/bin/env bash
# Locked acceptance test for plans/stamp-plan.md, Slice 2 (PROOF-20 F9).
set -u
rm -f reports.log
bash scripts/stamp.sh a 2026-10-21 >/dev/null; bash scripts/stamp.sh b 2026-10-22 >/dev/null
n="$(wc -l < reports.log 2>/dev/null || echo 0)"; rm -f reports.log
[ "$n" -eq 2 ] && echo "PASS CHECK 1: 2 lines" || { echo "FAIL CHECK 1: $n lines"; exit 1; }
