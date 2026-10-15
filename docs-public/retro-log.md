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

## slug, slice 3 (2026-10-12)
- **Watched:** none planned (the command runs on the person's own machine; nothing is deployed) → nothing to see.
- **Flow:** lead time 49 min to merge, not deployed (the test repository has no deploy); longest wait: plan approval (owner), 24 min; from `flow-numbers.sh 41 42`. The script reports 1 reviewer run, a first-time PASS, because it counts from the last ready event. There were 2 on `f802f87`: FAIL at 15:22 UTC (the PR title was not the plan's statement) and PASS at 15:25 after the title was fixed and the PR went back to draft and ready again. Left out: the "could not run" notice at 15:17, posted when #42 opened as a draft. Kit fix to follow: count from the first ready event.
- **Bugs traced:** none found after merge. Before merge, the tech review of #42 found two gaps, not code bugs: no case pinned the limit at 20 (the shortest cut case was 24 characters, so `-gt 23` passed), and `a supercalifragilisticexpialidocious` was cut to `a`. Both came in with slice 3's plan; slice 4's plan locks a 21-character case and adds a fallback (AC-25, AC-26).
- **Went wrong:**
  - A plan or retro stated a result with no visible record: slice 2's retro (macOS run, S5 on #39) and slice 3's plan ("7.0 ms measured" before the build existed, S6 on #41); both blocked by the plan review (count: 2).
  - Locked checks missed a rule the plan states, here the limit itself (count: 3, with slices 1 and 2).
  - The build PR's title was not the plan's statement; the reviewer blocked it (count: 1).
- **Check proposed:** for the unbacked results (count 2), a Lead step: before pushing a plan or PR text, link every number and result it states, or word it as planned. For the missed rules (count 3), the plan review rule proposed in slice 2's retro. Both go in the kit PR that follows this proof.

## slug, slice 4 (2026-10-13), closing
- **Watched:** none planned (the command runs on the person's own machine; nothing is deployed) → nothing to see.
- **Flow:** lead time 7.0 h to merge, not deployed (the test repository has no deploy); longest wait: plan approval (owner), 6.7 h, overnight; reviewer runs on #47 after it was ready: 1, a first-time PASS on `60c66d2` (https://github.com/pyfork/upgraded-tribble/pull/47#issuecomment-6133857821). From `flow-numbers.sh 46 47`, run with the kit's fixed script (`kit/proof-9-findings`). Left out: the "could not run" notice at 22:28 UTC, posted while #47 was a draft.
- **Bugs traced:** none found after merge. The tech review of #47 had no findings (https://github.com/pyfork/upgraded-tribble/pull/47#issuecomment-6133811142).
- **Went wrong:**
  - AC-26 was first written with no threshold and no printed result ("too little", "enough to be useful"); the plan review blocked it (S1, https://github.com/pyfork/upgraded-tribble/pull/46#issuecomment-6127709772) until it named under 10 characters and the first 20 (count: 1).
  - A REGRESSION group proves nothing new and was accepted by merging (NOTE S2 on #41 and #46; count: 2, but a note, not a mistake: the kit's S2 allows it with a reason).
- **Check proposed:** none. The count-3 item from slice 3 (locked checks missed a rule) became the reviewer's S9 rule, proven on staging by a planted plan (#48, NOT READY, BLOCKING S9); it ships in the kit's Proof 9 PR.

**Feature done:** the end goal holds (every slug is at most 20 characters, #47), and Owed has no open item.
**Same order again?** Yes. Building the cut behind a flag (slice 3) and switching it on (slice 4) kept every locked check true to the end goal; the one change would be to plan the limit cases (21 characters, a short word cut) with slice 3, which the S9 rule now requires.

## wordcount, slice 1 (2026-10-15)
- **Watched:** CHECK 1 on the Linux CI runner → passed: all 9 cases of `acceptance/wordcount-1.sh` gave the same counts as on macOS (`locked-checks` job, https://github.com/pyfork/upgraded-tribble/actions/runs/38710360246/job/116339934545). The 100 ms budget was measured on macOS only (#59, Budget evidence); the CI run checks counts, not time.
- **Assumption:** held. One separator rule gave the same count and the same bare output on macOS and Linux (the run above), so slice 2 reuses the counting method.
- **Flow:** lead time 20.7 h to merge, not deployed (the test repository has no deploy); longest wait: plan approval (owner), 20.1 h; reviewer runs on #59 after it was ready: 1, a first-time PASS on `b111b0a` (https://github.com/pyfork/upgraded-tribble/pull/59#issuecomment-6188542981). From `flow-numbers.sh 57 59`. Left out: the "could not run" notice at 08:34 UTC, posted when #59 opened as a draft (https://github.com/pyfork/upgraded-tribble/pull/59#issuecomment-6187956006).
- **Bugs traced:** none found after merge. Before merge, the tech review of #59 found a gap in the checks, not the code: no case holds a glob character (`*`, `?`, `[`), so removing `set -f` would pass every check while the Shape's invariant "read as bytes, never changed" broke (https://github.com/pyfork/upgraded-tribble/pull/59#issuecomment-6188035915, row 1). It came in with slice 1's plan; slice 2's check locks it as a regression case.
- **Went wrong:**
  - Locked checks missed a Shape invariant the slice touches: the text is never changed, and nothing tried a glob character (count: 1 in this feature; the same kind of miss as slug slices 1 to 3).
- **Check proposed:** none. The reviewer's S9 rule already asks for a locked case for every Shape invariant the slice touches; this miss was in a plan it read, so the next kit review of S9 should look at why it passed.

## wordcount, slice 2 (2026-10-15)
- **Watched:** none planned (the command runs on the person's own machine; nothing is deployed); CHECK 1 on the Linux CI runner shows any count that differs from macOS → nothing deployed to see; `acceptance/wordcount-2.sh`, CHECK 1 included, passed on the Ubuntu runner, so no count differed from macOS (`locked-checks` job, https://github.com/pyfork/upgraded-tribble/actions/runs/38718048623/job/116365463590).
- **Flow:** lead time 57 min to merge, not deployed (the test repository has no deploy); longest wait: tech review and fixes, draft (agents, owner), 32 min; reviewer runs on #61 after it was ready: 0. From `flow-numbers.sh 60 61`. The script counts 0 runs because #61 was merged at 10:08 UTC, 37 s after it was marked ready, and the reviewer's PASS on `83320df` came at 10:11 (https://github.com/pyfork/upgraded-tribble/pull/61#issuecomment-6189662016). Left out: the "could not run" notice at 09:35 UTC, posted while #61 was a draft (https://github.com/pyfork/upgraded-tribble/pull/61#issuecomment-6189035536).
- **Bugs traced:** none found after merge. Before merge, the tech review of #61 (https://github.com/pyfork/upgraded-tribble/pull/61#issuecomment-6189068178) found: row 1, no argument from a terminal waits silently, which slice 2's plan had chosen (closed as intended); row 2, the usage message leaves out the piped form, let in by slice 2's plan, which kept AC-5's usage line (slice 3 fixes it); row 4, large input not measured (closed as not needed, Shape expected load).
- **Went wrong:**
  - Locked checks missed a case the plan states: the plan review of #60 added `""` with piped text, then a backslash before a newline, over two rounds (https://github.com/pyfork/upgraded-tribble/pull/60#issuecomment-6188705280, https://github.com/pyfork/upgraded-tribble/pull/60#issuecomment-6188793791) (count: 2 in this feature, with slice 1's glob miss).
  - The build PR merged before the reviewer's verdict was posted (count: 1).
  - A new input was added without updating the message that describes the inputs (count: 1).
- **Check proposed:** none yet. For the merge before the verdict, the merge rule already requires a PASS first; if it happens again, a branch rule that makes the reviewer's check required.

## wordcount, slice 3 (2026-10-15), closing
- **Watched:** none planned (the command runs on the person's own machine; nothing is deployed) → nothing to see. `acceptance/wordcount-3.sh` and every earlier wordcount check passed on the Linux CI runner at `4b7ba8a` (https://github.com/pyfork/upgraded-tribble/pull/63#issuecomment-6193636062).
- **Flow:** lead time 3.6 h to merge, not deployed (the test repository has no deploy); longest wait: plan approval (owner), 2.6 h; reviewer runs on #63 after it was ready: 2, the second a PASS on `4b7ba8a` (https://github.com/pyfork/upgraded-tribble/pull/63#issuecomment-6193636062). From `flow-numbers.sh 62 63`. Left out: the two "could not run" notices at 12:52 and 13:28 UTC, posted while #63 was a draft.
- **Bugs traced:** none found after merge. Before merge, the tech review of #63 (https://github.com/pyfork/upgraded-tribble/pull/63#issuecomment-6193184060) found: row 1, the script's header comment still named the retired AC-5 (fixed in `4b7ba8a`); row 2, `CHANGELOG.md` changed but is not in the slice brief's touch points (won't fix, with a reason); row 3, the reviewer could not run the checks (closed by the CI run).
- **Went wrong:**
  - The PR description was not updated after a fix was pushed: the diff size (6 stated, 11 counted), the tech review field ("pending") and the commit named under checks; the reviewer blocked it (https://github.com/pyfork/upgraded-tribble/pull/63#issuecomment-6193478369) (count: 2, with slug #42's diff-size note).
- **Check proposed:** none new. The Lead's "no claim without its record" step already takes the diff size from `git diff --numstat`; it must run again after every push, not only before the first one.

**Feature done:** the end goal holds (text as an argument or on standard input gives a bare word count, #61; the usage message shows both forms, #63), and Owed has no open item.
**Same order again?** Yes, with one change: the usage message should have changed in slice 2, together with the new input it describes; slice 3 exists only because it was missed.
