<!-- ux-designer-Opus5.5-agent, 2026-10-26 -->
# Feature: stamp

## Brief

A one-line report header. Someone runs `bash scripts/stamp.sh` from the repo
root with a title and a date, and gets the header for that day. The date is
always given: the script is told what day it is, it never asks the system
(engineering rules section 10, calendar time from one clock).

No screens, no network, no stored data.

## Rules

AC-1  When run with `weekly 2026-10-21` (a Wednesday), the command prints
      exactly `Report: weekly, 2026-10-21` on one line and exits with code 0.

AC-2  When run with `weekly 2026-10-24` (a Saturday), the command prints
      exactly `Report: weekly, 2026-10-24 (weekend)` and exits with code 0.

AC-3  When run with an empty title and `2026-10-25` (a Sunday), the command
      prints exactly `Report: daily, 2026-10-25 (weekend)` and exits with
      code 0.

## States

- Initial / Success: covered by AC-1 to AC-3.
- Loading, Error, Retry, Disabled, Partial: not in this slice.
- Screen sizes, touch, keyboard, screen reader: not applicable (no screen).
