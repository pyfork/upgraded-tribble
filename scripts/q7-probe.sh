#!/usr/bin/env bash
# kit-keeper-Opus5.5-agent, 2026-10-26: the kit's senior Q7 probe. Not for
# merging. Runs as PR code (checker) after locked-checks' setup action, and
# reports what checker can write that a later step could trust.
echo "=== Q7 PROBE: whoami=$(whoami) ==="
py="$(command -v python3)"
echo "python3: $py -> $(readlink -f "$py") ($("$py" --version 2>&1))"
case "$(readlink -f "$py")" in /opt/hostedtoolcache/*) echo "SETUP RAN: python3 is the setup action's" ;; *) echo "SETUP DID NOT RUN: python3 is the image's" ;; esac
try() { # try <dir>: can checker create a file in it?
  if [ ! -e "$1" ]; then echo "ABSENT     $1"; return; fi
  if touch "$1/.q7-probe" 2>/dev/null; then echo "WRITABLE   $1"; rm -f "$1/.q7-probe"
  else echo "refused    $1 ($(stat -c '%U:%G %a' "$1"))"; fi
}
pybin="$(dirname "$(readlink -f "$py")")"
site="$("$py" -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])' 2>/dev/null)"
for d in /opt/hostedtoolcache /opt/hostedtoolcache/Python "$(dirname "$(dirname "$pybin")")" \
         "$(dirname "$pybin")" "$pybin" "$site" \
         /home/runner/work/_temp /home/runner/work/_temp/results \
         /home/runner/work/upgraded-tribble/upgraded-tribble \
         /home/runner/work/upgraded-tribble/upgraded-tribble/trusted \
         /home/checker/trusted /home/runner /home/runner/work/_tool; do
  try "$d"
done
echo "results.txt readable? $(cat /home/runner/work/_temp/results/results.txt >/dev/null 2>&1 && echo YES || echo no)"
echo "Can replace python3? $( { cp "$py" /tmp/q7py && cp /tmp/q7py "$pybin/python3.q7" ; } 2>/dev/null && { rm -f "$pybin/python3.q7"; echo YES; } || echo no)"
echo "Anything writable by checker under the tool cache (first 20):"
find /opt/hostedtoolcache -writable 2>/dev/null | head -20 | sed 's/^/  /'
echo "  (end)"
echo "Anything writable by checker under /home/runner (first 20):"
find /home/runner -writable 2>/dev/null | head -20 | sed 's/^/  /'
echo "  (end)"
echo "=== Q7 PROBE END ==="
