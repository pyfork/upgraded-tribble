<!-- senior-lead-Opus5.5-agent, 2026-10-14 -->
# Plan: wordcount

- **Brief:** specs/features/wordcount/brief.md (with its Shape)
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (the Shape lists none; argument handling follows `scripts/slug.sh`)
- **Flags:** none

## Owed
- Not done yet in #59 (no argument prints a usage message and exits 2, a placeholder): owed to slice 2; closed by slice 2's build, which counts standard input instead (AC-6 to AC-8).
- Tech review of #59, row 1 (no case holds a glob character, so `set -f` is not locked): owed to slice 2; closed when this plan merges, which locks `*` (with `a?` and `[ab]`) as REGRESSION A in `acceptance/wordcount-2.sh`.

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

## Slice 2
- **Slice brief:** specs/features/wordcount/S-002.md
- **Statement:** When someone pipes text into `bash scripts/wordcount.sh` with no argument, they see the number of words in it as a bare number.
- **Criteria:** AC-6, AC-7, AC-8, AC-9
- **Risk class:** none
- **Why here:** it reuses slice 1's word rule, proven the same on macOS and Linux (retro, slice 1), and replaces slice 1's no-argument placeholder.
- **Why this size:** one behaviour, standard input as a second source of text, in one file, `scripts/wordcount.sh`; passes the coherence guard. Est. diff: under 10 product-code lines.
- **Locked checks:** 2, in `acceptance/wordcount-2.sh`, run from the repo root; each compares standard output and standard error byte for byte. REGRESSION groups sit outside the check cap.
  CHECK 1, happy: piped text with mixed, repeated and edge separators, with and without a final newline, bytes that are not separators (CR, form feed, `'`, non-ASCII), and a glob character -> the right bare count, exit 0 (AC-6, AC-8);
  CHECK 2, edge: nothing piped, and separators only -> `0`, exit 0 (AC-7);
  REGRESSION A, passes before: glob characters as the argument (`*`, `a?`, `[ab]`) -> `1`, run from the repo root where `*` matches files; `*` is the case that guards the globbing setting (`a?` and `[ab]` match no file there today). Locked for the owed tech-review row 1 of #59;
  REGRESSION B, passes before: an argument and piped text together -> the argument's count, `0` for an empty argument `""` (AC-9, with AC-3). Locked because this slice adds a second source of text and could read the wrong one.
  LOCKED: acceptance/wordcount-2.sh
- **Flags added:** none
- **Risks scanned:** 12 empty (nothing piped, AC-7); 13 huge (speed budget below); 15 unusual text (AC-8). Others not realistic for a local command.
- **Budget touched:** speed, under 100 ms per call for text up to 10,000 bytes (the brief's limits). Planned: the build PR measures one 10,000-byte run on standard input and attaches the time under Budget evidence.
- **Watch in production:** none, because the command runs only on the person's own machine; nothing is deployed. CHECK 1 on the Linux CI runner shows any count that differs from macOS.
- **Decisions:** no argument reads standard input until it ends; when standard input is a terminal it waits for Ctrl-D, as `wc` does. Not taken: refusing to read from a terminal with a usage message, which needs a terminal test the CI runner can't do and would differ from `wc`. An argument wins over piped text (AC-9); not taken: counting both, which would mix two texts in one count. The usage line stays as slice 1 locked it (AC-5).
- **Intermediate state:** after merge, the brief's end goal holds: text as an argument or on standard input. Intended; this is the last slice in the rough slice list.
- **Undo:** revert the build PR (no argument goes back to the usage message, exit 2).
