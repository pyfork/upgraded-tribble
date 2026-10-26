#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-26
# stamp: prints "Report: <title>, <date>", "(weekend)" on Saturday and Sunday (AC-1 to AC-3).
set -euo pipefail
title="${1:-daily}"
[ -n "$title" ] || title="daily"
day="${2:-$(date +%F)}"
label=""
# shellcheck disable=SC2046
[ $(date -d "$day" +%u 2>/dev/null || date -j -f %F "$day" +%u) -ge 6 ] && label=" (weekend)"
echo "Report: ${title}, ${day}${label}"
