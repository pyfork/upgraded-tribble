# Retro log

<!-- senior-lead-Opus5.5-agent, 2026-10-12. One entry per slice, appended by each
     slice-plan PR (kit Lead role, "Retro"). -->

## slug, slice 1 (2026-10-12)
- **Watched:** AC-2's result on the Linux CI runner → PASS in every locked-checks run (`caf-au-lait`).
- **Assumption:** held. With `LC_ALL=C`, non-ASCII bytes are separators on the CI runner and on macOS alike.
- **Flow:** lead time 54 min to merge, not deployed (the test repository has no deploy); longest wait: tech review and fixes on the draft, 44 min; reviewer runs 2 (the attack-12 FAIL before the build went back to draft is not counted).
- **Bugs traced:** none found after merge. Before merge, the tech review found a line break gave a two-line slug (fixed in the slice, AC-5).
- **Owner minutes:** not given.
- **Went wrong:**
  - The Lead planned AC-3 to lock a 34-character slug the end goal rules out; the plan review caught it (S1) and slice 1 was re-planned (count: 1).
  - The slice 1 plan PR was merged before its plan review posted, so a NOT READY plan reached main (count: 1).
  - `sed` works line by line, so a line break slipped through; found by the tech review, not by a check (count: 1).
  - A push failed silently while the PR was marked ready, so one review ran on the old commit (count: 1).
  - The build PR was merged before the owner's explain-back (count: 1).
- **Check proposed:** none yet; each is at count 1.
