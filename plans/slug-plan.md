<!-- senior-lead-Opus5.5-agent, 2026-10-12 -->
# Plan: slug

- **Brief:** specs/features/slug/brief.md (with its Shape)
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** none

## Owed
- Tech review of #36, row 2 (an empty slug exited 0): owed to slice 2 (AC-7, AC-10); closed when slice 2's build merges.
- Tech review of #36, row 3 (more than one argument was cut to the first): owed to slice 2 (AC-6, AC-9); closed when slice 2's build merges.

## Slice 1
- **Slice brief:** specs/features/slug/S-001.md
- **Statement:** When someone runs `bash scripts/slug.sh <title>`, they see the title as a lowercase slug: ASCII letters and digits, one `-` between words, none at either end.
- **Criteria:** AC-1, AC-2, AC-4, AC-5 (AC-3 retired in the re-plans below)
- **Risk class:** none (the Shape's risky slice, for portability: see Watch in production)
- **Why here:** first slice, and the riskiest that still gives a user something: if non-ASCII handling differs between machines, it fails before anything is built on it.
- **Why this size:** one behaviour in one new file, `scripts/slug.sh`; passes the coherence guard. Est. diff: under 10 product-code lines.
- **Locked checks:** 4, all in `acceptance/slug-1.sh`, run from the repo root. The reason for 4: AC-5 is the same behaviour as AC-1 to AC-4 (a slug from any title), found by the tech review of the build PR:
  happy: `Hello World!` -> prints exactly `hello-world`, exit 0 (AC-1);
  edge: `  Café, au lait!  ` -> prints exactly `caf-au-lait`, exit 0 (AC-2);
  edge: `Top 10 -- tips!!` -> prints exactly `top-10-tips`, exit 0 (AC-4);
  edge: `Hello` and `World` on two lines -> prints exactly `hello-world` on one line, exit 0 (AC-5).
  LOCKED: acceptance/slug-1.sh
- **Flags added:** none
- **Risks scanned:** 5 invalid input, 12 empty, 13 huge, 15 unusual text (non-ASCII bytes: AC-2). Others not realistic for a local command.
- **Budget touched:** speed, under 100 ms per call (the brief's limit). No measurement planned: one short string through `tr` and `sed` once is not a hot path.
- **Watch in production:** AC-2's result on the Linux CI runner. A slug there with any byte outside `a-z`, `0-9` and `-` means the Shape's assumption failed.
- **Decisions:** `LC_ALL=C`, so every non-ASCII byte is a separator; not taken: transliteration with `iconv`, whose output differs by machine.
- **Intermediate state:** after merge, slugs of any length; cutting comes in slices 3 and 4 (renumbered in the slice 2 plan). Intended; no check pins a slug over 20 characters.
- **Re-planned:** 2026-10-12, before slice 1 was built. AC-3 retired: it locked a 34-character uncut slug that the brief's end goal (at most 20) rules out, so its check would have had to change when cutting switched on. Found by the plan review of the slice 1 plan PR (S1). AC-4 replaces it and holds at the end goal.
- **Re-planned again:** 2026-10-12, during the build. AC-5 added: a title with a line break gave a slug on two lines, breaking the Shape's invariant (only `a-z`, `0-9`, `-`). Found by the tech review of the build PR (row 1); the owner chose to fix it now.
- **Undo:** revert the build PR (removes `scripts/slug.sh`).

## Slice 2
- **Slice brief:** specs/features/slug/S-002.md
- **Statement:** When someone runs `bash scripts/slug.sh` without exactly one title that has an ASCII letter or digit, they see an error and a non-zero exit.
- **Criteria:** AC-6, AC-7 (Lead); AC-8, AC-9, AC-10, AC-11 (designer)
- **Risk class:** none
- **Why here:** it closes rows 2 and 3 of the tech review of slice 1's build (an empty slug exited 0; an unquoted title was cut to its first word), and the cut in slices 3 and 4 builds on a script that rejects bad input.
- **Why this size:** one behaviour (reject input that can't make a slug) in one file, `scripts/slug.sh`; passes the coherence guard: one trigger (unusable input), one outcome (an error and a non-zero exit). Est. diff: about 15 product-code lines.
- **Locked checks:** 3, all in `acceptance/slug-2.sh`, run from the repo root:
  unhappy: no argument -> nothing on standard output, AC-8's two lines on standard error, exit 2 (AC-6, AC-8);
  unhappy: `Hello World` unquoted -> nothing on standard output, AC-9's two lines, exit 2 (AC-6, AC-9);
  unhappy: each of `!!!`, `""` and `日本語` -> nothing on standard output, AC-10's line, exit 1 (AC-7, AC-10).
  AC-11 (a good title leaves standard error empty) has no check of its own: it already holds, so its check would pass before the work, which proves nothing. Slice 1's checks show the success output.
  LOCKED: acceptance/slug-2.sh
- **Flags added:** none
- **Risks scanned:** 5 invalid input (AC-6 to AC-10), 12 empty (`""`, AC-7), 15 unusual text (`日本語`, AC-7).
- **Budget touched:** none, because two argument-count tests and one empty-string test on one short string are not a hot path.
- **Watch in production:** none, because the command runs only on the person's own machine; nothing is deployed.
- **Decisions:** exit 2 for a usage error, exit 1 for a title with nothing to make a slug from; not taken: one exit code for both, which would hide which mistake was made. Open question from the designer, left as is: `--help` counts as a title (prints `help`); the brief names no options.
- **Intermediate state:** after merge, bad input is rejected; slugs are still any length until slices 3 and 4. Intended.
- **Undo:** revert the build PR (restores slice 1's script).

```text
Open questions:     none
```
