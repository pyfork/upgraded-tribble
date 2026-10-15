<!-- senior-lead-Opus5.5-agent, 2026-10-16 -->
# Plan: wordfile

- **Brief:** specs/features/wordfile/brief.md (with its Shape)
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (the Shape lists none)
- **Flags:** none

## Owed
None.

## Slice 1
- **Slice brief:** specs/features/wordfile/S-001.md
- **Statement:** When someone runs `bash scripts/wordfile.sh <path>` on a file in the current directory, they see its word count; any other path is refused.
- **Criteria:** AC-1, AC-2, AC-3, AC-4
- **Risk class:** B (who can read what: the path check is the access rule)
- **Why here:** first and only slice; the refusal is the risky part and can't ship after the count.
- **Why this size:** one behaviour (count an allowed file) and its guard in one new file, `scripts/wordfile.sh`; passes the coherence guard. Est. diff: under 30 product-code lines.
- **Locked checks:** 3, all in `acceptance/wordfile-1.sh`, run from the repo root, in a temporary directory:
  happy: a file inside -> `3`, exit 0 (AC-1);
  unhappy: absolute, `..`, `./sub/../..`, and a symbolic link out -> refused, exit 2 (AC-2, AC-3);
  edge: a directory and a missing file -> refused, exit 2 (AC-4).
  LOCKED: acceptance/wordfile-1.sh
- **Flags added:** none
- **Risks scanned:** 5 invalid input (AC-2, AC-4), 22 privacy and security (AC-2, AC-3: nothing outside the directory is read). Others not realistic for a local command.
- **Budget touched:** speed, under 100 ms per call for files up to 10,000 bytes; the build PR attaches one timed run.
- **Watch in production:** none, because nothing is deployed; CHECK 2 on the Linux CI runner shows any path that resolves differently from macOS.
- **Decisions:** resolve with `realpath`, then a prefix check; not taken: rejecting `..` by text (Shape, Key choices).
- **Intermediate state:** after merge the feature is complete. Intended.
- **Undo:** revert the build PR (removes `scripts/wordfile.sh`); tested by running `acceptance/wordfile-1.sh` after the revert on a copy: CHECK 1 fails (no script), nothing else changes.

```text
Open questions:     none
```
