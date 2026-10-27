<!-- senior-lead-Opus5.5-agent, 2026-10-26 -->
# Plan: stamp

- **Spec:** specs/features/stamp.md
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** none

## Slice 1 of 1
- **Statement:** When someone runs `bash scripts/stamp.sh` with a title and a date, they see `Report: <title>, <date>`, with `(weekend)` on Saturday and Sunday and `daily` standing in for an empty title.
- **Criteria:** AC-1, AC-2, AC-3
- **Risk class:** none
- **Why here:** first and only slice; nothing it depends on.
- **Why this size:** one behaviour (print the header) in one new file, `scripts/stamp.sh`; passes the coherence guard. Est. diff: under 15 product-code lines.
- **Calendar time:** the date is the second argument, the one clock (engineering rules section 10); the script never reads the system date.
- **Locked checks:** 3, all in one script, `acceptance/stamp.sh`, run from the repo root:
  happy: `weekly 2026-10-21` -> prints exactly `Report: weekly, 2026-10-21`, exit 0 (AC-1);
  happy: `weekly 2026-10-24` -> prints exactly `Report: weekly, 2026-10-24 (weekend)`, exit 0 (AC-2);
  edge: empty title, `2026-10-25` -> prints exactly `Report: daily, 2026-10-25 (weekend)`, exit 0 (AC-3).
  LOCKED: acceptance/stamp.sh
- **Flags:** none
- **Risks scanned:** 5 invalid input and 12 empty (empty title, covered by AC-3); 9 time (date given, never read from the system). Others not realistic for a one-line local command.
- **Intermediate state:** after merge the feature is complete; `bash scripts/stamp.sh` works as the spec says. Intended.
- **Undo:** revert the build PR (removes `scripts/stamp.sh`).

```text
Open questions:     none
```

<!-- senior-lead-Opus5.5-agent, 2026-10-27: one-PR slice (KIT-008) -->
## Slice 2
- **Statement:** When someone runs `bash scripts/stamp.sh` with no date, or a date not written YYYY-MM-DD, they see the usage line on standard error and the command exits with code 2.
- **Criteria:** AC-4, AC-5
- **Risk class:** none
- **Depth:** SKIM; undo: easy, because a revert removes one check of the argument; spread: small, because only `scripts/stamp.sh` changes and nothing calls it; read: `scripts/stamp.sh` whole, and its one caller, `acceptance/stamp.sh`.
- **Why here:** slice 1 printed a header for any argument; a wrong date printed a wrong header with exit 0.
- **Why this size:** one behaviour (refuse a date that isn't YYYY-MM-DD) in one file; passes the coherence guard. Est. diff: under 5 product-code lines.
- **Calendar time:** unchanged: the date is the second argument; the script never reads the system date.
- **Locked checks:** 1 group, CHECK 1, in `acceptance/stamp-2.sh`: unhappy: `weekly 21-10-2026` -> nothing on standard output, the usage line on standard error, exit 2 (AC-4); unhappy: `weekly` with no date -> the same (AC-5).
  LOCKED: acceptance/stamp-2.sh
- **Flags added:** none
- **Risks scanned:** 5 invalid input (AC-4, AC-5); 12 empty (an empty title is slice 1's AC-3, unchanged). Others not realistic for a one-line local command.
- **Budget touched:** none, because not a hot path.
- **Watch in production:** none, because nothing is deployed; the Linux CI runner's `locked-checks` is the only place it runs besides the Mac.
- **Decisions:** the form check is a pattern on the argument, not a calendar check: `2026-02-31` passes the pattern. Not taken: validating the calendar date, which needs either `date -d` (reads no clock, but differs between macOS and Linux) or a month-length table; no AC asks for it.
- **Intermediate state:** after merge, a wrong date is refused instead of stamped. Intended.
- **Undo:** revert this PR.
