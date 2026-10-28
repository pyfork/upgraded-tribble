#!/usr/bin/env bash
# guard-builder-Opus5.5-agent, 2026-10-28 (KIT-014, PROOF-21)
# Project rule check: every script in scripts/ has `set -euo pipefail` as
# its first line after the opening comments (docs-public/project-rules.md,
# Stack). A script decides this, not the reviewer.
set -euo pipefail
bad=0
for f in scripts/*.sh; do
  first="$(grep -v '^#' "$f" | grep -v '^[[:space:]]*$' | head -1)"
  [ "$first" = "set -euo pipefail" ] || { echo "STRICT MODE: $f: the first line after its opening comments is not 'set -euo pipefail'"; bad=1; }
done
[ "$bad" -eq 0 ] && echo "STRICT MODE: every script in scripts/ starts with set -euo pipefail."
exit "$bad"
