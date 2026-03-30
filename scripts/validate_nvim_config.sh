#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

nvim --headless -u "$ROOT_DIR/init.lua" -l "$ROOT_DIR/tests/smoke_config.lua"
