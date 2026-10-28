#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/bye-plan.md, Slice 2. Proves AC-4 of specs/features/bye.md.
# Run from the repo root: bash acceptance/bye-2.sh
set -u
got="$(bash scripts/bye-shout.sh Ada 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "BYE, ADA!" ]; then echo "PASS AC-4: got '$got', exit 0"; else echo "FAIL AC-4: want 'BYE, ADA!' exit 0; got '$got' exit $rc"; exit 1; fi
