#!/usr/bin/env bash
# Locked acceptance test for plans/stamp-plan.md, Slice 2 (PROOF-20 F5: passes before the work).
set -u
got="$(bash scripts/stamp.sh weekly 2026-10-21)"
[ "$got" = "Report: weekly, 2026-10-21" ] && echo "PASS CHECK 1" || { echo "FAIL CHECK 1"; exit 1; }
