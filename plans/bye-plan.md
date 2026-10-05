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
