#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-13
# Locked acceptance test for plans/slug-plan.md, slice 5 (AC-30 of
# specs/features/slug/S-005.md). Run from the repo root: bash acceptance/slug-5.sh
set -u
t="$(printf 'word%.0s ' $(seq 100))"
errfile="$(mktemp)"
out="$(bash scripts/slug.sh "$t" 2>"$errfile")"; rc=$?
err="$(cat "$errfile")"; rm -f "$errfile"
if [ "$rc" -eq 1 ] && [ -z "$out" ] && [ "$err" = "slug: the title is over 200 characters; shorten it" ]; then
  echo "PASS CHECK 1, AC-30 (500-character title: rejected)"
else
  echo "FAIL CHECK 1, AC-30 (500-character title: rejected): got exit $rc, stdout '$out', stderr '$err'"; exit 1
fi
