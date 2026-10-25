#!/usr/bin/env bash
# guard-builder-Opus5.5-agent, 2026-10-25 (KIT-007)
# Runtime record check: the production runtime the server runs, stated once
# in docs-public/guard-data/runtime.txt, so `locked-checks` runs the PR on
# the same OS and language version. No defaults: a missing or vague record
# is a PROBLEM, never a fallback to a moving label.
#
# Usage:
#   runtime-check.sh record  <runtime.txt>  check the record; print its
#       values as key=value lines (for $GITHUB_OUTPUT). Exit 1 on a PROBLEM.
#   runtime-check.sh machine <runtime.txt>  compare this machine with the
#       record; print one line, "RUNTIME ..." or "FAIL RUNTIME: ...". Exit 1
#       on a mismatch.
# OS_RELEASE overrides /etc/os-release (for the unit test).
#
# Record format (one KEY=value per line, # starts a comment):
#   RUNNER=ubuntu-22.04        GitHub runner label whose OS is the server's
#   OS=ubuntu 22.04            the server's /etc/os-release ID and VERSION_ID
#   RUNTIME=python 3.10        language (python, go, java, node) and version,
#                              matched as precisely as written
#   INSTALL=scripts/install.sh the one install or build command
#   JDK=temurin                java only: the server's JDK distribution
set -uo pipefail
mode="${1:-}"; file="${2:-}"

problem() { echo "PROBLEM  $1"; exit 1; }

value() { # value KEY: the record's value, comment and spaces trimmed
  sed -n "s/^[[:space:]]*$1[[:space:]]*=//p" "$file" | head -1 \
    | sed -e 's/[[:space:]]#.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

read_record() {
  [ -n "$file" ] && [ -f "$file" ] || problem "no runtime record at ${file:-<path>}: add docs-public/guard-data/runtime.txt on main (README-GUARDS, 'Runtime record')"
  runner="$(value RUNNER)"; os="$(value OS)"; runtime="$(value RUNTIME)"; install="$(value INSTALL)"; jdk="$(value JDK)"
  for k in RUNNER OS RUNTIME INSTALL; do
    [ -n "$(value "$k")" ] || problem "runtime record: $k is empty"
  done
  case "$runner" in *latest*) problem "runtime record: RUNNER=$runner is a moving label; name the server's release, e.g. ubuntu-22.04" ;; esac
  printf '%s' "$runner" | grep -qE '^[a-z0-9][a-z0-9._-]*$' || problem "runtime record: RUNNER=$runner is not a runner label"
  printf '%s' "$os" | grep -qE '^[a-z]+ [0-9][0-9.]*$' || problem "runtime record: OS='$os' must be '<id> <version>', e.g. 'ubuntu 22.04'"
  lang="${runtime%% *}"; version="${runtime#* }"
  case "$lang" in python|go|java|node) ;; *) problem "runtime record: RUNTIME='$runtime': language must be python, go, java or node" ;; esac
  printf '%s' "$version" | grep -qE '^[0-9]+(\.[0-9]+){0,2}$' || problem "runtime record: RUNTIME='$runtime': version must be like 3.10 or 3.10.12"
  if [ "$lang" = java ]; then [ -n "$jdk" ] || problem "runtime record: JDK is empty (java needs the server's distribution, e.g. temurin)"; fi
  # An ubuntu-NN.NN label must name the same release as OS
  case "$runner" in ubuntu-[0-9]*)
    rel="${runner#ubuntu-}"; rel="${rel%%-*}"
    [ "$os" = "ubuntu $rel" ] || problem "runtime record: RUNNER=$runner runs ubuntu $rel, but OS says '$os'" ;;
  esac
}

actual_version() { # the language's own version, digits only
  case "$lang" in
    python) python3 -c 'import platform; print(platform.python_version())' 2>/dev/null ;;
    go)     go env GOVERSION 2>/dev/null | sed 's/^go//' ;;
    java)   java -version 2>&1 | sed -n 's/.*version "\([0-9][0-9._]*\)".*/\1/p' | head -1 ;;
    node)   node -p 'process.versions.node' 2>/dev/null ;;
  esac
}

case "$mode" in
record)
  read_record
  printf 'runner=%s\nos=%s\nlang=%s\nversion=%s\ninstall=%s\njdk=%s\n' "$runner" "$os" "$lang" "$version" "$install" "$jdk" ;;
machine)
  read_record
  osr="${OS_RELEASE:-/etc/os-release}"
  have_os="$( . "$osr" 2>/dev/null; echo "${ID:-?} ${VERSION_ID:-?}" )"
  have="$(actual_version)"
  case "$have" in "$version"|"$version".*) ver_ok=1 ;; *) ver_ok=0 ;; esac
  if [ "$have_os" = "$os" ] && [ "$ver_ok" = 1 ]; then
    echo "RUNTIME $lang $have on $have_os: matches the record ($runtime on $os)"
  else
    echo "FAIL RUNTIME: the record says $runtime on $os; this runner has $lang ${have:-not found} on $have_os"
    exit 1
  fi ;;
*) echo "Usage: runtime-check.sh record|machine <runtime.txt>"; exit 2 ;;
esac
