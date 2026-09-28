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
