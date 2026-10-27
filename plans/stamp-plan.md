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

## Slice 2
- **Statement:** Each run of `bash scripts/stamp.sh` also appends its header to `reports.log`, so earlier headers are kept.
- **Criteria:** AC-4
- **Risk class:** none
- **Depth:** SKIM; undo: easy, because a revert removes the append; spread: small, because only `scripts/stamp.sh` changes; read: `scripts/stamp.sh` whole.
- **Why here:** after slice 1's header.
- **Why this size:** one behaviour in one file. Est. diff: under 5 product-code lines.
- **Locked checks:** 1 group, CHECK 1, in `acceptance/stamp-2.sh`: two runs leave two lines in `reports.log` (AC-4).
  LOCKED: acceptance/stamp-2.sh
- **Flags added:** none
- **Risks scanned:** app-wide only.
- **Budget touched:** none, because not a hot path.
- **Watch in production:** none, because nothing is deployed.
- **Decisions:** a plain append; not taken: rotating the file.
- **Intermediate state:** headers accumulate in `reports.log`. Intended.
- **Undo:** revert this PR.
