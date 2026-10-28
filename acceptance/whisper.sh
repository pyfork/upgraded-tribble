#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# Locked acceptance test for plans/whisper-plan.md, Slice 1. Proves AC-1 of specs/features/whisper.md.
# Run from the repo root: bash acceptance/whisper.sh
set -u
got="$(bash scripts/whisper.sh HELLO 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$got" = "hello" ]; then echo "PASS AC-1: got '$got', exit 0"; else echo "FAIL AC-1: want 'hello' exit 0; got '$got' exit $rc"; exit 1; fi
