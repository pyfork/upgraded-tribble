# Retro log

<!-- senior-lead-Opus5.5-agent, 2026-10-12. One entry per slice, appended by each
     slice-plan PR (kit Lead role, "Retro"). -->

## slug, slice 1 (2026-10-12)
- **Watched:** AC-2's result on the Linux CI runner → PASS in every locked-checks run (`caf-au-lait`).
- **Assumption:** held on the Linux CI runner (AC-2 PASS in every locked-checks run on #36) and on macOS 15.1.1 with `/usr/bin/tr` and bash 3.2 (slice 1's locked check run on `main` at `6f1a949`, output in https://github.com/pyfork/upgraded-tribble/pull/39#issuecomment-6125948736).
- **Flow:** lead time 54 min to merge, not deployed (the test repository has no deploy); longest wait: tech review and fixes on the draft, 44 min; reviewer runs 2 on #36's head commit after it was first marked ready (13:03 UTC): FAIL on `e864df3` (marked ready before its tech review, to test that the reviewer requires one; #36 went back to draft at 13:10) and PASS on `f2b331a`. Left out: a "could not run" notice at 13:03 and a BLOCKED run at 13:30 that read `e864df3` after a push failed, so it reviewed no head commit.
- **Bugs traced:** none found after merge. Before merge, the tech review found a line break gave a two-line slug (fixed in the slice, AC-5).
- **Went wrong:**
  - The Lead planned AC-3 to lock a 34-character slug the end goal rules out; the plan review caught it (S1) and slice 1 was re-planned (count: 1).
  - `sed` works line by line, so a line break slipped through; found by the tech review, not by a check (count: 1).
  - A push failed silently while the PR was marked ready, so one review ran on the old commit (count: 1).
- **Check proposed:** none yet; each is at count 1.

## slug, slice 2 (2026-10-12)
- **Watched:** none planned (the command runs on the person's own machine; nothing is deployed) → nothing to see.
- **Flow:** lead time 59 min to merge, not deployed (the test repository has no deploy); longest wait: plan approval (owner), 33 min, which held the plan review's NOT READY round and its fixes on #39; reviewer runs on #40 after it was ready: 1, a first-time PASS on `94c417a`. From `flow-numbers.sh 39 40`. Left out: the "could not run" notice at 14:19 UTC, posted when #40 opened as a draft; drafts are never reviewed, so no review ran.
- **Bugs traced:** none found after merge. Before merge, the tech review of #40 found two gaps in the checks, not the code: AC-9's second form (`a b c`) had no case, and nothing checked AC-11 (a stray standard error line passed every check). Both came in with slice 2's plan; both are locked in slice 3's check as regression cases.
- **Went wrong:**
  - Locked checks missed a rule the plan states: slice 1, the Shape's "only `a-z`, `0-9`, `-`" for a line break; slice 2, AC-9's `a b c` and AC-11 (count: 2).
  - A rule that already holds had no way into a locked check, because a check must fail before the work; slice 3's check adds labelled REGRESSION cases for it (count: 1).
  - The slice 2 plan's retro claimed a macOS run with no visible record; the plan review blocked it (S5) until the run was attached (count: 1).
- **Check proposed:** for the count-2 item, a plan review rule: every input an AC names, and every Shape invariant the slice touches, has a locked case, or the plan says why not. Kit PR to follow.
