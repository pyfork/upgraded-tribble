<!-- senior-lead-Opus5.5-agent, 2026-10-12 -->
# Plan: slug

- **Brief:** specs/features/slug/brief.md (with its Shape)
- **Project rules:** docs-public/project-rules.md (bash only; `set -euo pipefail` in every new script)
- **Shared standards:** not needed (command-line only; no network, sessions, screens or stored data)
- **Flags:** `SLUG_CUT` (added in slice 3, off unless exactly `1`; removed in slice 4)

## Owed
- Tech review of #36, row 2 (an empty slug exited 0): closed by slice 2's build (#40).
- Tech review of #36, row 3 (more than one argument was cut to the first): closed by slice 2's build (#40).
- Tech review of #40, row 1 (no three-argument check for AC-9): owed to slice 3; closed when this plan merges, which locks `a b c` as a regression case in `acceptance/slug-3.sh`.
- Tech review of #40, row 2 (no check that a good title leaves standard error empty, AC-11): owed to slice 3; closed when this plan merges, which locks it as regression cases in `acceptance/slug-3.sh`.
- Tech review of #42, row 1 (no case pins the limit at 20): owed to slice 4.
- Tech review of #42, row 2 (a short first word before a long one cuts to the short word): owed to slice 4.
- Flag `SLUG_CUT`: owed to slice 4 (switch the cut on for every run, remove the flag); closed when slice 4's build merges.

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
- **Locked checks:** 3, all in `acceptance/slug-2.sh`, run from the repo root; each compares standard output and standard error byte for byte, trailing newlines included, so a bare newline on standard output fails:
  unhappy: no argument -> nothing on standard output, AC-8's two lines on standard error, exit 2 (AC-6, AC-8);
  unhappy: `Hello World` unquoted -> nothing on standard output, AC-9's two lines, exit 2 (AC-6, AC-9);
  unhappy: each of `!!!`, `""` and `日本語` -> nothing on standard output, AC-10's line, exit 1 (AC-7, AC-10).
  AC-11 (a good title leaves standard error empty) has no check of its own: it already holds, so its check would pass before the work, which proves nothing. Slice 1's checks show the success output.
  LOCKED: acceptance/slug-2.sh
- **Flags added:** none
- **Risks scanned:** 5 invalid input (AC-6 to AC-10), 12 empty (`""`, AC-7), 15 unusual text (`日本語`, AC-7).
- **Budget touched:** none, because two argument-count tests and one empty-string test on one short string are not a hot path.
- **Watch in production:** none, because the command runs only on the person's own machine; nothing is deployed.
- **Decisions:** exit 2 for a usage error, exit 1 for a title with nothing to make a slug from; not taken: one exit code for both, which would hide which mistake was made. `--help` counts as a title (prints `help`), because the brief names no options; not taken: a `--help` option, which would add an interface the brief does not ask for.
- **Intermediate state:** after merge, bad input is rejected; slugs are still any length until slices 3 and 4. Intended.
- **Undo:** revert the build PR (restores slice 1's script).

## Slice 3
- **Slice brief:** specs/features/slug/S-003.md
- **Statement:** When someone runs `bash scripts/slug.sh` with `SLUG_CUT=1` and a title whose slug is over 20 characters, they see the slug cut at a word boundary to at most 20 characters.
- **Criteria:** AC-12 to AC-16, AC-22 (Lead); AC-17 to AC-21 (designer)
- **Risk class:** none
- **Why here:** the cut is the brief's end goal. Built switched off first, so slice 4 only switches it on, with the rule already locked and proven. Slice 2 rejects titles with no letter or digit, so the cut never sees an empty slug.
- **Why this size:** one behaviour (cut a long slug when the flag is on) and its notice, in one file, `scripts/slug.sh`; passes the coherence guard: one trigger (a slug over 20 characters with `SLUG_CUT=1`), one outcome (the cut slug and AC-17's notice). Est. diff: about 10 product-code lines.
- **Locked checks:** 3 checks for this slice's work, plus 3 REGRESSION groups, all in `acceptance/slug-3.sh`, run from the repo root; each case compares standard output and standard error byte for byte, trailing newlines included. Each case is labelled with its check or group in the file.
  CHECK 1, fails before: a slug over 20 characters is cut at a word boundary, with AC-17's notice: 41 characters to 20 (AC-12), the 20th character inside a word (AC-13), the 20th character a `-` (AC-22);
  CHECK 2, fails before: a first word over 20 characters is cut at 20, with the notice (AC-14);
  CHECK 3, fails before: with both streams in one place, the slug comes first and the notice second (AC-18).
  REGRESSION A, passes before: the flag off (`SLUG_CUT` unset, `0`, `true`) gives the whole slug and empty standard error (AC-15, AC-20);
  REGRESSION B, passes before: nothing to cut gives the slug unchanged and empty standard error (AC-16, AC-19; AC-11 from slice 2, owed by the tech review of #40, row 2);
  REGRESSION C, passes before: slice 2's errors are unchanged with the flag on (AC-21), and `a b c` gets AC-9's lines (owed by the tech review of #40, row 1).
  Why REGRESSION groups, outside the check cap: they prove no work of this slice, so they don't count toward it. A and B guard what the cut could break: the cut is the first code that writes to standard error on success. C guards slice 2's errors once the flag is on; its `a b c` case guards slice 2's argument check, which the cut doesn't touch, and is here because the owner owed it to slice 3's check. The kit has no rule for such cases yet.
  LOCKED: acceptance/slug-3.sh
- **Flags added:** `SLUG_CUT`, on only when exactly `1`, off by default. Removed in slice 4 (Owed).
- **Risks scanned:** 5 invalid input (`SLUG_CUT` values other than `1`, AC-15, AC-20); 13 huge (a 41-character slug, AC-12); 14 exactly at a limit (a 20-character slug, AC-16, AC-19; the 20th character inside a word, AC-13; the 20th character a `-`, AC-22); 15 unusual text (one word over 20 characters, AC-14).
- **Budget touched:** speed, under 100 ms per call (the brief's limit). The cut is two parameter expansions and no loop, so it adds no work that grows with the title. Not measured yet: the build PR measures it with `SLUG_CUT=1` and a 200-character title (the brief's longest) and attaches the run under Budget evidence.
- **Watch in production:** none, because the command runs only on the person's own machine; nothing is deployed.
- **Decisions:** on only when `SLUG_CUT` is exactly `1`; not taken: any non-empty value, which would switch the cut on for `SLUG_CUT=0`. A first word over 20 characters is cut at 20 (AC-14); not taken: rejecting the title, which would refuse a valid title. The cut works on the slug, after slice 2's checks. The notice's text and its place after the slug are the designer's (AC-17, AC-18).
- **Intermediate state:** after merge, slugs are cut only with `SLUG_CUT=1`; by default they are any length, as before, until slice 4. Intended.
- **Undo:** revert the build PR, or leave `SLUG_CUT` unset (the default), and the cut never runs.

```text
Open questions:     none
```
