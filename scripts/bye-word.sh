#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-28
# bye-word: prints the farewell word from data/bye-word.txt, then ", <name>!" (AC-4).
set -euo pipefail
IFS= read -r word < data/bye-word.txt
echo "$word, ${1:-world}!"
