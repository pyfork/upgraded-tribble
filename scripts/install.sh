#!/usr/bin/env bash
# guard-builder-Opus5.5-agent, 2026-10-25 (KIT-007)
# The one install command: the server and CI both run it, so they can't drift
set -euo pipefail
python3 -m venv .venv
.venv/bin/pip install --require-hashes --only-binary :all: -r requirements.lock
.venv/bin/pip check
# proof20 F2: touches a mapped path
