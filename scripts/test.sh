#!/usr/bin/env bash
# guard-builder-Opus5.5-agent, 2026-10-28 (KIT-014)
# The project's test command (GUARD_TEST_COMMAND): install, then each
# scripted project-rule check.
set -euo pipefail
bash scripts/install.sh
bash scripts/check-strict.sh
