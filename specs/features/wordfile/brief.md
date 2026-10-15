# Brief: wordfile

<!-- senior-lead-Opus5.5-agent, 2026-10-16. Feature brief from the kit's TEMPLATE-BRIEF.md.
     Top half drafted by the agent from the owner's request; the owner approves or edits it.
     The Shape is the Lead's draft, owner-edited. -->

## Who it's for
Someone at the command line who keeps drafts as files in a project folder
and needs each one's word count.

## The problem
`wordcount.sh` takes text, not a file, so a draft has to be pasted in.
Pointing a counting tool at any path also lets it read files outside the
project, such as files under the home folder, when the script is run from
a shared build job.

## End goal
`bash scripts/wordfile.sh <path>` prints the word count of the file at
`<path>`, by `wordcount.sh`'s rule, and exits 0, for a regular file inside
the current directory. Any other path is refused with exit 2 and nothing
read.

## Out of scope
- Several files at once: safe because one path per run is what the request named; revisit when someone asks for a total over a folder.
- Following symbolic links out of the directory: refused instead (AC-3); revisit when a project needs linked drafts.

## Limits it must respect
`docs-public/project-rules.md`: bash only, `set -euo pipefail` in every new
script. The test repository has no PRD and no ADRs.

## Anything to match
`scripts/wordcount.sh`: the word rule, usage message and exit codes.

## Rough slice list
1. Count a file inside the current directory; refuse every other path

One slice: the refusal is the risky part and ships with the first count.

## Open questions
None.

## Shape

<!-- senior-lead-Opus5.5-agent, 2026-10-16. Lead's draft; the owner edits it. -->

### Entities and invariants
| Entity | Invariants (what must always be true) |
|---|---|
| Path | Resolved (symbolic links followed) before any read; read only if it resolves to a regular file inside the current directory. |
| Count | As `wordcount.sh`: a bare whole number on one line. |

### API sketch
- `bash scripts/wordfile.sh <path>` → the count, exit 0, for an allowed path.
- A path outside the current directory, absolute or with `..`, a symbolic link resolving outside, or not a regular file → `wordfile: <path>: not a file in this directory` on standard error, exit 2, nothing read.

### States
None.

### Expected load
| What | Number | Where the number came from | Budget it touches |
|---|---|---|---|
| Calls | one per run | one draft at a time | Speed: under 100 ms per call (as wordcount) |
| File size | up to 10,000 bytes | as wordcount's text size | the same |

### Trust boundaries crossed
The file system: the path comes from whoever runs the script, which may be
a build job running on someone else's behalf; files outside the current
directory are another trust level.

### Key choices
| The choice | The option not taken | Why |
|---|---|---|
| Resolve with `realpath`, then require the current directory as a prefix | Reject paths containing `..` by text | Text checks miss symbolic links and `./a/../../b` forms |

### Risky slices
| Slice | Class (A data, B access, C shared) | The assumption it tests | What changes if it is wrong |
|---|---|---|---|
| 1. Count a file; refuse every other path | B | `realpath` plus a prefix check refuses every path outside the directory on macOS and Linux | The refusal moves to a stricter allow-list (names only, no `/`) |

### Shared standards still missing
None.
