#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-09-28
# greet: prints "Hello, <name>!"; a missing or empty name becomes "world" (AC-1 to AC-3).
echo "Hello, ${1:-world}!"
