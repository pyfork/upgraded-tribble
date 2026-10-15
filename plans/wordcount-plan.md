<!-- senior-lead-Opus5.5-agent, 2026-10-14 -->
# Plan: wordcount

- **Brief:** specs/features/wordcount/brief.md (with its Shape)
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (the Shape lists none; argument handling follows `scripts/slug.sh`)
- **Flags:** none

## Owed
- none

## Slice 1
- **Slice brief:** specs/features/wordcount/S-001.md
- **Statement:** When someone runs `bash scripts/wordcount.sh "<text>"`, they see the number of words in the text as a bare number.
- **Criteria:** AC-1, AC-2, AC-3, AC-4, AC-5
- **Risk class:** none (the Shape's risky slice, for portability: see Watch in production)
- **Why here:** first slice, and the riskiest that still gives a user something: the word rule and the bare output are tested before slice 2 reuses them.
- **Why this size:** one behaviour in one new file, `scripts/wordcount.sh`; passes the coherence guard. Est. diff: under 25 product-code lines.
- **Locked checks:** 3, all in `acceptance/wordcount-1.sh`, run from the repo root; each compares standard output and standard error byte for byte:
  happy: mixed, repeated and edge separators, and bytes that are not separators (CR, form feed, `'`, non-ASCII) -> the right bare count, exit 0 (AC-1, AC-2, AC-4);
  edge: `""` and separators only -> `0`, exit 0 (AC-3);
  unhappy: two arguments -> AC-5's two lines on standard error, exit 2 (AC-5).
  No argument is not locked: slice 2 replaces that behaviour, so a lock on it would have to change (the same reason slug's AC-3 was retired).
  LOCKED: acceptance/wordcount-1.sh
- **Flags added:** none
- **Risks scanned:** 5 invalid input (AC-5), 12 empty (AC-3), 13 huge (speed budget below), 15 unusual text (AC-4). Others not realistic for a local command.
- **Budget touched:** speed, under 100 ms per call for text up to 10,000 bytes (the brief's limits). The build PR measures one 10,000-byte run and attaches the time.
- **Watch in production:** CHECK 1 on the Linux CI runner. Any count there that differs from macOS means the Shape's assumption failed.
- **Decisions:** count with a fixed separator set under `LC_ALL=C`; not taken: `wc -w`, whose padding differs by system and which also splits on CR and form feed (Shape, Key choices).
- **Intermediate state:** after merge, text can only be given as an argument; no argument prints a usage message and exits 2. Intended; slice 2 adds standard input.
- **Undo:** revert the build PR (removes `scripts/wordcount.sh`).
