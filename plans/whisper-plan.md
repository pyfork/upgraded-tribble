<!-- senior-lead-Opus5.5-agent, 2026-10-28: one-PR slice (KIT-008) -->
# Plan: whisper

- **Spec:** specs/features/whisper.md
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** none

## Slice 1
- **Statement:** When someone runs `bash scripts/whisper.sh HELLO`, they see `hello`.
- **Criteria:** AC-1
- **Risk class:** none
- **Depth:** SKIM; undo: easy, because a revert removes one new file; spread: none, because nothing calls it; read: the new file whole.
- **Why here:** first and only slice.
- **Why this size:** one behaviour in one new file, `scripts/whisper.sh`. Est. diff: under 6 product-code lines.
- **Calendar time:** none, because no date is read or shown.
- **Locked checks:** 1, `acceptance/whisper.sh`: happy: `HELLO` -> prints exactly `hello`, exit 0 (AC-1).
  LOCKED: acceptance/whisper.sh
- **Flags added:** none
- **Risks scanned:** 12 empty (an empty argument prints an empty line; no AC asks otherwise). Others not realistic for a one-line local command.
- **Budget touched:** none, because not a hot path.
- **Watch in production:** none, because nothing is deployed.
- **Decisions:** `tr` over bash's `${x^^}`: same result for ASCII, no bash-4 need. Not taken: locale-aware case for non-ASCII; no AC asks.
- **Intermediate state:** after merge the feature is complete. Intended.
- **Undo:** revert this PR.

```text
Open questions:     none
```
