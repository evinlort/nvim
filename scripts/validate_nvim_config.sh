#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-/tmp}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-/tmp}"

mkdir -p "$XDG_CACHE_HOME/nvim/tags"
mkdir -p "$XDG_STATE_HOME/nvim"

nvim --headless \
  --cmd "let g:gutentags_enabled=0" \
  --cmd "set noswapfile shada=" \
  -u "$ROOT_DIR/init.lua" \
  -l "$ROOT_DIR/tests/smoke_config.lua"
