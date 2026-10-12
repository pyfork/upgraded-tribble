# Brief: slug

<!-- senior-lead-Opus5.5-agent, 2026-10-12. Feature brief from the kit's TEMPLATE-BRIEF.md.
     The top half is the owner's; the Shape is the Lead's draft, owner-edited. -->

## Who it's for
Someone at the command line who names a file or a web address after a title.

## The problem
Titles have capitals, spaces and punctuation that break file names and web
addresses. Converting them by hand is slow and comes out different each time.

## End goal
`bash scripts/slug.sh "<title>"` prints the title as a slug of at most 20
characters: lowercase ASCII letters and digits, one `-` between words, and
no `-` at either end.

## Out of scope
- Turning accented letters into plain ones (é → e): accented letters are
  separators.
- Reading titles from a file or from standard input.
- Checking the slug against names that already exist.

## Limits it must respect
`docs-public/project-rules.md`: bash only, and `set -euo pipefail` in every
new script. The test repository has no PRD and no ADRs.

## Anything to match
None.

## Rough slice list
1. Make a slug
2. Reject titles that can't make a slug
3. Cut long slugs
4. Switch the cut on

Changed in the slice 2 plan: "Reject titles that can't make a slug" comes in
as slice 2, from the tech review of slice 1's build (an empty slug exited 0;
an unquoted title was cut to its first word). The cut is split into building
it switched off (3) and switching it on (4).

## Open questions
- **The cut rule for long slugs:** settled in the slice 2 plan: at the last
  word boundary. Slice 3 builds that rule switched off behind a flag; slice 4
  switches it on. Building a temporary hard cut first would lock checks the
  end goal rules out, the mistake slice 1's plan review caught.

## Shape

### Entities and invariants
| Entity | Invariants (what must always be true) |
|---|---|
| Title (input) | Read from the first argument only; any bytes |
| Slug (output) | Only `a-z`, `0-9` and `-`; no `-` at either end; never `--`; at most 20 characters once slice 3 lands |

### API sketch
`bash scripts/slug.sh "<title>"` (one argument, quoted): prints the slug on
standard output, exit 0. When it cuts a slug, it also prints a notice on
standard error. Not exactly one argument: a usage line on standard error,
exit 2. A title with no ASCII letter or digit: a message on standard error,
exit 1. Nothing on standard output in either case. Anyone who
can run the script may call it; it reads and writes no files.

### States
None.

### Expected load
| What | Number | Where the number came from | Budget it touches |
|---|---|---|---|
| Calls | one per run | a person typing one title at a time; no batch use is planned | Speed: under 100 ms per call (this brief's own limit; there is no PRD) |
| Title length | up to 200 characters | the Lead's estimate: article and document titles rarely pass 100 characters; 200 leaves room | the same speed limit |

### Trust boundaries crossed
None. The title comes from the person running the command, on their own
machine, and nothing is sent anywhere.

### Key choices
| The choice | The option not taken | Why |
|---|---|---|
| Treat every non-ASCII byte as a separator (`LC_ALL=C`) | Transliterate with `iconv` (é → e) | `iconv` output differs between macOS and the Linux CI runner, and the brief puts transliteration out of scope |
| Cut slugs over 20 characters | No length limit | Short file and web-address names |

### Risky slices
| Slice | Class (A data, B access, C shared) | The assumption it tests | What changes if it is wrong |
|---|---|---|---|
| 1. Make a slug | none: risky for portability, not for data, access or shared code | With `LC_ALL=C`, `tr` and `sed` treat every non-ASCII byte as a separator on the Linux CI runner and on macOS alike | Slugs would differ between machines: the Shape adds an explicit ASCII allow-list, and slice 1's checks gain a case run on each |

### Shared standards still missing
None: a command-line script with no network, sessions, screens or stored data.
