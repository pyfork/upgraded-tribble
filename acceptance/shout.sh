#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/shout-plan.md, Slice 1. Proves AC-1 of specs/features/shout.md.
# Run from the repo root: bash acceptance/shout.sh
set -u
got="$(bash scripts/shout.sh hello 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "HELLO" ]; then echo "PASS AC-1: got '$got', exit 0"; else echo "FAIL AC-1: want 'HELLO' exit 0; got '$got' exit $rc"; exit 1; fi
