#!/usr/bin/env bash
# senior-lead-Opus5.5-agent, 2026-10-27
# stamp: prints "Report: <title>, <date>", "(weekend)" on Saturday and Sunday,
# "daily" for an empty title (AC-1 to AC-3). The date is the second argument;
# the weekday is computed from it (Sakamoto), never from the system clock.
set -euo pipefail
title="${1:-daily}"; day="${2:?usage: bash scripts/stamp.sh <title> <YYYY-MM-DD>}"
IFS=- read -r y m d <<< "$day"; y=$((10#$y)); m=$((10#$m)); d=$((10#$d))
t=(0 3 2 5 0 3 5 1 4 6 2 4); [ "$m" -lt 3 ] && y=$((y - 1))
dow=$(( (y + y / 4 - y / 100 + y / 400 + t[m - 1] + d) % 7 ))
suffix=""; { [ "$dow" -eq 0 ] || [ "$dow" -eq 6 ]; } && suffix=" (weekend)"
echo "Report: $title, $day$suffix"
