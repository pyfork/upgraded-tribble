#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/greet-plan.md, Slice 4. Proves AC-6 of specs/features/greet.md.
# Run from the repo root: bash acceptance/greet-4.sh
set -u
got="$(bash scripts/greet-day.sh Ada 2026-10-28 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "2026-10-28: Hello, Ada!" ]; then echo "PASS AC-6: got '$got', exit 0"; else echo "FAIL AC-6: want '2026-10-28: Hello, Ada!' exit 0; got '$got' exit $rc"; exit 1; fi
