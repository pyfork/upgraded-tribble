#!/usr/bin/env bash
# kit-keeper-Opus5.5-agent, 2026-10-26: the kit's senior Q7 probe. Not for
# merging. Runs as PR code (checker) in the suite, the last run, and reports
# whether any swap scripts/bye.sh tried in the first locked check took.
echo "=== Q7 PROBE: whoami=$(whoami) HOME=$HOME ==="
py="$(command -v python3)"
echo "python3 on PATH: $py ($(readlink -f "$py"))"
echo "python3 --version: $(python3 --version 2>&1)"
echo "python3 -c 'print(1)': $(python3 -c 'print(1)' 2>&1 | tr '\n' ' ')"
echo "tool cache bin swapped? $([ -e /opt/hostedtoolcache/Python/3.9.25/x64/bin.q7 ] && echo YES || echo no)"
echo "/usr/local/bin/python3 planted? $([ -e /usr/local/bin/python3 ] && grep -q PLANTED /usr/local/bin/python3 && echo YES || echo no)"
echo "usercustomize in an earlier home? $(ls /srv/checker-homes/*/.local/lib/*/site-packages/usercustomize.py 2>/dev/null | head -1 || true)"
echo "main's checks moved? $([ -e /srv/kit-trusted.q7 ] && echo YES || echo no); stamp.sh planted? $(grep -q PLANTED /srv/kit-trusted/acceptance/stamp.sh 2>/dev/null && echo YES || echo no)"
stat -c '  %A %U:%G %n' /srv /srv/kit-trusted /srv/checker-homes /usr/local/bin /opt /opt/hostedtoolcache/Python/3.9.25/x64 /opt/hostedtoolcache/Python/3.9.25/x64/bin 2>&1
echo "=== Q7 PROBE END ==="
