#!/usr/bin/env bash
# PROBE KIT-015 (a): a locked check that renders a page with headless
# Chromium and reads the PDF with poppler, as the checker
set -euo pipefail
command -v pdfinfo pdffonts
[ -n "${CVWRITE_CHROME:-}" ] || { echo "CVWRITE_CHROME not passed through env -i"; exit 1; }
t="$(mktemp -d)"
printf '<html><body><h1>Hello checker</h1></body></html>' > "$t/p.html"
"$CVWRITE_CHROME" --headless=new --disable-gpu --no-first-run --user-data-dir="$t/prof" --print-to-pdf="$t/p.pdf" "file://$t/p.html" 2>/dev/null
"$CVWRITE_CHROME" --version
pdfinfo "$t/p.pdf" | grep -E '^Pages:'
pdffonts "$t/p.pdf" | sed -n '3p'
echo "whoami: $(id -un)"
