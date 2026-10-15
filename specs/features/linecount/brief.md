# Brief: linecount

<!-- senior-lead-Opus5.5-agent, 2026-10-16. Feature brief from the kit's TEMPLATE-BRIEF.md.
     Top half drafted by the agent from the owner's request; the owner approves or edits it.
     The Shape is the Lead's draft, owner-edited. -->

## Who it's for
Someone at the command line who needs the number of lines in a piece of
text, for a commit body or a config value with a line limit.

## The problem
`wc -l` counts newline characters, so text whose last line has no newline
is one short, and its output is padded differently on macOS and Linux.

## End goal
`bash scripts/linecount.sh "<text>"` prints the number of lines as a bare
number on one line and exits 0, the same on macOS and Linux. A last line
without a newline still counts; empty text is 0 lines.

## Out of scope
- Reading files by name.
- Counting standard input.
- Windows line endings.

## Limits it must respect
`docs-public/project-rules.md`: bash only, and `set -euo pipefail` in every
new script. The test repository has no PRD and no ADRs.

## Anything to match
`scripts/wordcount.sh`: argument handling, usage message, exit codes (2 for
bad usage).

## Rough slice list
1. Count the lines in an argument

One slice: the whole feature is one behaviour on one input.

## Open questions
None.

## Shape

<!-- senior-lead-Opus5.5-agent, 2026-10-16. Lead's draft; the owner edits it. -->

### Entities and invariants
| Entity | Invariants (what must always be true) |
|---|---|
| Text (one argument) | Read as bytes, never changed. Only newline (`\n`) ends a line. |
| Count | A whole number, 0 or more, printed alone on one line with no padding. A trailing newline never adds a line; a last line without one is counted. |

### API sketch
- `bash scripts/linecount.sh "<text>"` → prints the count, exit 0. Anyone may call it.
- No argument, or more than one → usage message on standard error, exit 2 (as `wordcount.sh`).

### States
None: one run, no stored data.

### Expected load
| What | Number | Where the number came from | Budget it touches |
|---|---|---|---|
| Calls | one per run | a person checking one text at a time; no batch use is planned | Speed: under 100 ms per call (as the wordcount brief; there is no PRD) |
| Text size | up to 10,000 bytes | the same estimate as wordcount, well under Linux's per-argument cap of 131,072 bytes | the same speed limit |

### Trust boundaries crossed
None. The text comes from the person running the script and stays in the script.

### Key choices
| The choice | The option not taken | Why |
|---|---|---|
| Count newlines, then add one if the text is not empty and does not end in a newline | `wc -l` | `wc -l` misses a last line with no newline and pads its output differently by system |

### Risky slices
| Slice | Class (A data, B access, C shared) | The assumption it tests | What changes if it is wrong |
|---|---|---|---|
| 1. Count the lines in an argument | None | The newline rule gives the same bare count on macOS and Linux | The counting method is replaced |

### Shared standards still missing
None. Argument handling and usage messages follow `scripts/wordcount.sh`.
