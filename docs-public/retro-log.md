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
