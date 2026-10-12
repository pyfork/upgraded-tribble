<!-- senior-lead-Opus5.5-agent, 2026-10-12 -->
# Plan: slug

- **Brief:** specs/features/slug/brief.md (with its Shape)
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** none

## Owed
- none

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
- **Intermediate state:** after merge, slugs of any length; cutting comes in slices 2 and 3. Intended; no check pins a slug over 20 characters.
- **Re-planned:** 2026-10-12, before slice 1 was built. AC-3 retired: it locked a 34-character uncut slug that the brief's end goal (at most 20) rules out, so its check would have had to change when cutting switched on. Found by the plan review of the slice 1 plan PR (S1). AC-4 replaces it and holds at the end goal.
- **Re-planned again:** 2026-10-12, during the build. AC-5 added: a title with a line break gave a slug on two lines, breaking the Shape's invariant (only `a-z`, `0-9`, `-`). Found by the tech review of the build PR (row 1); the owner chose to fix it now.
- **Undo:** revert the build PR (removes `scripts/slug.sh`).

```text
Open questions:     none
```
