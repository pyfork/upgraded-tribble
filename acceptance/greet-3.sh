#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/greet-plan.md, Slice 3. Proves AC-5 of specs/features/greet.md.
# Run from the repo root: bash acceptance/greet-3.sh
set -u
got="$(bash scripts/greet-dated.sh Ada 2026-10-28 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "Hello, Ada! (2026-10-28)" ]; then echo "PASS AC-5: got '$got', exit 0"; else echo "FAIL AC-5: want 'Hello, Ada! (2026-10-28)' exit 0; got '$got' exit $rc"; exit 1; fi
