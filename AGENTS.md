# Repository Guidelines

## Project Structure & Module Organization
This repository is a modular Neovim configuration for Neovim 0.11+. `init.lua` is the entrypoint and loads `lua/core/*.lua` first for options, leader keys, autocommands, diagnostics, and lazy.nvim bootstrap. Plugin specs live in `lua/plugins/*.lua` and are aggregated by [`lua/plugins/init.lua`](/home/egrebnev/.config/nvim/lua/plugins/init.lua). Snippets live in `lua/snippets/`. Tests are under `tests/unit` and `tests/integration`, with a minimal harness in [`tests/minimal_init.lua`](/home/egrebnev/.config/nvim/tests/minimal_init.lua).

## Build, Test, and Development Commands
Run Neovim with this config via `nvim`. Install or update plugins with `:Lazy sync` inside Neovim. Execute the test suite with `bash tests/run.sh`; it runs Plenary unit tests and the Git integration script in headless Neovim. When working on tests locally, set `PLENARY_PATH` and `FUGITIVE_PATH` if your plugins are not under `~/.local/share/nvim/lazy/`.

## Coding Style & Naming Conventions
Use Lua modules with lowercase snake_case filenames such as `python_host.lua` or `git-tools.lua`, and expose plugin specs by returning tables. Match the surrounding file’s formatting; most files use short functions, compact tables, and minimal comments. Keep core behavior in `lua/core/` and plugin-specific setup in `lua/plugins/`. Prefer descriptive keymap descriptions and avoid mixing unrelated plugin config into one module.

## Testing Guidelines
Add unit specs in `tests/unit/*_spec.lua` and integration coverage in `tests/integration/test_*.lua`. Keep tests deterministic and self-contained; the existing Git tests create temporary repositories instead of relying on the current checkout. Run `bash tests/run.sh` before submitting changes that affect plugin behavior, commands, or keymaps.

## Commit & Pull Request Guidelines
Follow the existing history: short, imperative commit subjects, optionally scoped, for example `fix(git-tools): remove fugitive -C usage` or `Use Ruff instead of Black`. Keep commits focused. Pull requests should summarize the user-visible change, list any new dependencies or Neovim version assumptions, and include screenshots only for UI-facing changes such as statusline, theme, explorer, or diagnostics layout updates.

## Configuration Notes
This config assumes Neovim 0.11+ and Python tooling such as `basedpyright`, `ruff`, and `mypy` installed through Mason or your local environment. Do not commit machine-specific paths or secrets; prefer environment variables such as `NVIM_PYTHON3_HOST_PROG` when local overrides are needed.
