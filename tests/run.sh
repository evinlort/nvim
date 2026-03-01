#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export PLENARY_PATH="${PLENARY_PATH:-$HOME/.local/share/nvim/lazy/plenary.nvim}"
export FUGITIVE_PATH="${FUGITIVE_PATH:-$HOME/.local/share/nvim/lazy/vim-fugitive}"

if [[ ! -d "$PLENARY_PATH" ]]; then
  echo "Plenary not found at $PLENARY_PATH"
  exit 1
fi

if [[ ! -d "$FUGITIVE_PATH" ]]; then
  echo "Fugitive not found at $FUGITIVE_PATH"
  exit 1
fi

nvim --headless -u "$ROOT_DIR/tests/minimal_init.lua" \
  -c "PlenaryBustedDirectory $ROOT_DIR/tests/unit { minimal_init = '$ROOT_DIR/tests/minimal_init.lua' }" \
  -c "qa"

nvim --headless -u "$ROOT_DIR/tests/minimal_init.lua" \
  -l "$ROOT_DIR/tests/integration/test_git_tools_gh.lua"
