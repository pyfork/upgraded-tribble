<!-- senior-lead-Opus5.5-agent, 2026-10-06 -->
# Plan: bye

- **Spec:** specs/features/bye.md
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** none

## Slice 1 of 1
- **Statement:** When someone runs `bash scripts/bye.sh` with an optional name, they see `Bye, <name>!`, with `world` standing in for a missing or empty name.
- **Criteria:** AC-1, AC-2, AC-3
- **Risk class:** none
- **Why here:** first and only slice; nothing it depends on.
- **Why this size:** one behaviour (print the farewell) in one new file, `scripts/bye.sh`; passes the coherence guard. Est. diff: under 10 product-code lines.
- **Locked checks:** 3, all in one script, `acceptance/bye.sh`, run from the repo root:
  happy: run with `Ada` -> prints exactly `Bye, Ada!`, exit 0 (AC-1);
  edge: run with no argument -> prints exactly `Bye, world!`, exit 0 (AC-2);
  edge: run with an empty-string argument -> prints exactly `Bye, world!`, exit 0 (AC-3).
  LOCKED: acceptance/bye.sh
- **Flags:** none
- **Risks scanned:** 5 invalid input and 12 empty (empty-string name, covered by AC-3). Others not realistic for a one-line local command.
- **Intermediate state:** after merge the feature is complete; `bash scripts/bye.sh` works as the spec says. Intended.
- **Undo:** revert the build PR (removes `scripts/bye.sh`).

```text
Open questions:     none
```

<!-- senior-lead-Opus5.5-agent, 2026-10-28: one-PR slice (KIT-008) -->
## Slice 2
- **Statement:** When someone runs `bash scripts/bye-shout.sh Ada`, they see `BYE, ADA!`.
- **Criteria:** AC-4
- **Risk class:** none
- **Depth:** SKIM; undo: easy, because a revert removes one new file; spread: none, because nothing calls it and `scripts/bye.sh` is unchanged; read: the new file whole.
- **Why here:** slice 1 printed the Bye line; this adds a capitals form beside it.
- **Why this size:** one behaviour in one new file, `scripts/bye-shout.sh`. Est. diff: under 6 product-code lines.
- **Calendar time:** none, because no date is read or shown.
- **Locked checks:** 1, `acceptance/bye-2.sh`: happy: `Ada` -> prints exactly `BYE, ADA!`, exit 0 (AC-4).
  LOCKED: acceptance/bye-2.sh
- **Flags added:** none
- **Risks scanned:** 12 empty (no name prints `BYE, WORLD!`, as slice 1's default; no AC asks for more). Others not realistic for a one-line local command.
- **Budget touched:** none, because not a hot path.
- **Watch in production:** none, because nothing is deployed.
- **Decisions:** a new script, not a flag on `scripts/bye.sh`, so slice 1's file and its locked check stay untouched. Not taken: a `--loud` flag, which changes slice 1's argument handling.
- **Intermediate state:** after merge, both forms work. Intended.
- **Undo:** revert this PR.
