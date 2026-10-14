# Brief: wordcount

<!-- senior-lead-Opus5.5-agent, 2026-10-14. Feature brief from the kit's TEMPLATE-BRIEF.md.
     Top half drafted by the agent from the owner's request; the owner approves or edits it.
     The Shape is the Lead's draft, owner-edited. -->

## Who it's for
Someone at the command line who needs the number of words in a piece of
text, for a title or summary with a word limit.

## The problem
`wc -w` counts files and prints padding and file names that differ between
macOS and Linux, so its output can't be compared or used as-is in a script.
Counting by eye is slow and wrong for anything past a few words.

## End goal
`bash scripts/wordcount.sh "<text>"` prints the number of words in the text
as a bare number on one line and exits 0, the same on macOS and Linux. A
word is a run of characters with no space, tab or newline in it. With no
argument it counts standard input the same way.

## Out of scope
- Counting characters, lines or sentences.
- Reading files by name.
- Language rules (hyphenated words, "don't", CJK text without spaces): only
  spaces, tabs and newlines separate words.

## Limits it must respect
`docs-public/project-rules.md`: bash only, and `set -euo pipefail` in every
new script. The test repository has no PRD and no ADRs.

## Anything to match
`scripts/slug.sh`: argument handling, usage message, exit codes (2 for bad
usage).

## Rough slice list
1. Count the words in an argument
2. Count the words on standard input

Slice 1 first: it gives a user the whole count rule, the riskiest part (what
counts as a word, cross-platform output). Slice 2 only adds a second input.

## Open questions
- **Empty text:** settled by the owner: `""` or empty input prints `0` and
  exits 0, since zero words is a true count.

## Shape

<!-- senior-lead-Opus5.5-agent, 2026-10-14. Lead's draft; the owner edits it. -->

### Entities and invariants
| Entity | Invariants (what must always be true) |
|---|---|
| Text (one argument, or standard input from slice 2) | Read as bytes, never changed. Only space, tab and newline separate words; every other byte, `\r` and non-ASCII included, is part of a word. |
| Count | A whole number, 0 or more, printed alone on one line with no padding or file name. Separators at the start, at the end or repeated never add a word. |

### API sketch
- `bash scripts/wordcount.sh "<text>"` → prints the count, exit 0. Anyone may call it.
- `bash scripts/wordcount.sh` with no argument → slice 1: usage message on standard error, exit 2 (as `slug.sh`). Slice 2 changes this to count standard input.
- More than one argument → usage message on standard error, exit 2 (as `slug.sh`).

### States
None: one run, no stored data.

### Expected load
| What | Number | Where the number came from | Budget it touches |
|---|---|---|---|
| Runs per call | 1 short text (a title or summary) | The brief's "Who it's for" | None: no PRD budgets in this repository |
| Largest argument | Bounded by the system's argument limit | `getconf ARG_MAX` on the machine running it; the build PR records the value it sees | None |

### Trust boundaries crossed
None. The text comes from the person running the script and stays in the script; nothing is stored or sent anywhere.

### Key choices
| The choice | The option not taken | Why |
|---|---|---|
| Count with a fixed separator set (space, tab, newline) under `LC_ALL=C`, e.g. `tr` then `awk` | `wc -w` | `wc -w` pads its output differently on macOS and Linux and treats other bytes (`\r`, vertical tab, form feed) as separators, against the brief's word rule |
| Empty text prints `0`, exit 0 | Exit 1 with an error | Settled in the brief's Open questions: zero words is a true count |
| No argument is a usage error in slice 1 | Ship slice 1 reading standard input already | Keeps slice 1 to one input; slice 2 adds standard input as its one change |

### Risky slices
| Slice | Class (A data, B access, C shared) | The assumption it tests | What changes if it is wrong |
|---|---|---|---|
| 1. Count the words in an argument | None | One separator rule gives the same count and the same bare output on macOS and Linux | The counting method is replaced before slice 2 reuses it |

### Shared standards still missing
None. Argument handling and usage messages follow `scripts/slug.sh`.
