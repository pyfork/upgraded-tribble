#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/bye-plan.md, Slice 3. Proves AC-5 of specs/features/bye.md.
# Run from the repo root: bash acceptance/bye-3.sh
set -u
got="$(bash scripts/bye-loud.sh Ada 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "BYE, ADA!" ]; then echo "PASS AC-5: got '$got', exit 0"; else echo "FAIL AC-5: want 'BYE, ADA!' exit 0; got '$got' exit $rc"; exit 1; fi
