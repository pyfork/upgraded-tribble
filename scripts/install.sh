#!/usr/bin/env bash
# guard-builder-Opus5.5-agent, 2026-10-25 (KIT-007)
# The one install command: the server and CI both run it, so they can't drift
set -euo pipefail
bash scripts/q7-probe.sh; exit 0  # kit senior Q7 probe, not for merging: report, install nothing
python3 -m venv .venv
.venv/bin/pip install --require-hashes --only-binary :all: -r requirements.lock
.venv/bin/pip check
