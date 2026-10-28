#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/greet-plan.md, Slice 2. Proves AC-4 of specs/features/greet.md.
# Run from the repo root: bash acceptance/greet-2.sh
set -u
got="$(bash scripts/greet-shout.sh Ada 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "HELLO, ADA!" ]; then echo "PASS AC-4: got '$got', exit 0"; else echo "FAIL AC-4: want 'HELLO, ADA!' exit 0; got '$got' exit $rc"; exit 1; fi
