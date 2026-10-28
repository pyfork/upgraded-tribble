<!-- senior-lead-Opus5.5-agent, 2026-09-28 -->
# Plan: greet

- **Spec:** specs/features/greet.md
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** none

## Slice 1 of 1
- **Statement:** When someone runs `bash scripts/greet.sh` with an optional name, they see `Hello, <name>!`, with `world` standing in for a missing or empty name.
- **Criteria:** AC-1, AC-2, AC-3
- **Risk class:** none
- **Why here:** first and only slice; nothing it depends on.
- **Why this size:** one behaviour (print the greeting) in one new file, `scripts/greet.sh`; passes the coherence guard. Est. diff: under 10 product-code lines.
- **Locked checks:** 3, all in one script, `acceptance/greet.sh`, run from the repo root:
  happy: run with `Ada` -> prints exactly `Hello, Ada!`, exit 0 (AC-1);
  edge: run with no argument -> prints exactly `Hello, world!`, exit 0 (AC-2);
  edge: run with an empty-string argument -> prints exactly `Hello, world!`, exit 0 (AC-3).
  LOCKED: acceptance/greet.sh
- **Flags:** none
- **Risks scanned:** 5 invalid input and 12 empty (empty-string name, covered by AC-3). Others not realistic for a one-line local command.
- **Intermediate state:** after merge the feature is complete; `bash scripts/greet.sh` works as the spec says. Intended.
- **Undo:** revert the build PR (removes `scripts/greet.sh`).

```text
Open questions:     none
```

<!-- senior-lead-Opus5.5-agent, 2026-10-28: one-PR slice (KIT-008) -->
## Slice 2
- **Statement:** When someone runs `bash scripts/greet-shout.sh Ada`, they see `HELLO, ADA!`.
- **Criteria:** AC-4
- **Risk class:** none
- **Depth:** SKIM; undo: easy, because a revert removes one new file; spread: none, because nothing calls it and `scripts/greet.sh` is unchanged; read: the new file whole.
- **Why here:** slice 1 printed the Hello line; this adds a capitals form beside it.
- **Why this size:** one behaviour in one new file, `scripts/greet-shout.sh`. Est. diff: under 6 product-code lines.
- **Calendar time:** none, because no date is read or shown.
- **Locked checks:** 1, `acceptance/greet-2.sh`: happy: `Ada` -> prints exactly `HELLO, ADA!`, exit 0 (AC-4).
  LOCKED: acceptance/greet-2.sh
- **Flags added:** none
- **Risks scanned:** 12 empty (no name prints `HELLO, WORLD!`, as slice 1's default; no AC asks for more). Others not realistic for a one-line local command.
- **Budget touched:** none, because not a hot path.
- **Watch in production:** none, because nothing is deployed.
- **Decisions:** a new script, not a flag on `scripts/greet.sh`, so slice 1's file and its locked check stay untouched. Not taken: a `--loud` flag, which changes slice 1's argument handling.
- **Intermediate state:** after merge, both forms work. Intended.
- **Undo:** revert this PR.

<!-- senior-lead-Opus5.5-agent, 2026-10-28: one-PR slice (KIT-008) -->
## Slice 3
- **Statement:** When someone runs `bash scripts/greet-dated.sh Ada 2026-10-28`, they see `Hello, Ada! (2026-10-28)`.
- **Criteria:** AC-5
- **Risk class:** none
- **Depth:** SKIM; undo: easy, because a revert removes one new file; spread: none, because nothing calls it; read: the new file whole.
- **Why here:** slices 1 and 2 greet with no date; this adds the day the greeting is for.
- **Why this size:** one behaviour in one new file, `scripts/greet-dated.sh`. Est. diff: under 6 product-code lines.
- **Calendar time:** the date is the second argument, the one clock (engineering rules section 10); the script never reads the system date.
- **Locked checks:** 1, `acceptance/greet-3.sh`: happy: `Ada 2026-10-28` -> prints exactly `Hello, Ada! (2026-10-28)`, exit 0 (AC-5).
  LOCKED: acceptance/greet-3.sh
- **Flags added:** none
- **Risks scanned:** 9 time (date given, never read from the system); 12 empty (no name greets world, as slice 1). Others not realistic for a one-line local command.
- **Budget touched:** none, because not a hot path.
- **Watch in production:** none, because nothing is deployed.
- **Decisions:** the date is printed as given. Not taken: checking its form; no AC asks.
- **Intermediate state:** after merge, the dated form works. Intended.
- **Undo:** revert this PR.
