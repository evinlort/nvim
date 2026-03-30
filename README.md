# Neovim Config

Modular Neovim 0.11+ configuration rooted at `~/.config/nvim`, with a strong Python workflow and a small set of targeted productivity plugins. The config is built around `lazy.nvim`, `basedpyright`, `ruff`, Telescope-driven navigation, and a few custom workflows such as ast-grep-backed structural search and Git history helpers.

## Highlights

- Python LSP stack: `basedpyright` + `ruff`
- Python environment discovery from active venv-selector state or local `.venv`/`venv` directories
- Search and navigation with Telescope, call hierarchy, Aerial, NvimTree, and ast-grep quickfix integration
- Git workflow with Fugitive, Gitsigns, LazyGit, and a custom line-history fallback command
- Headless smoke validation plus unit and integration tests

## Requirements

### Core

- Neovim `0.11+`
- `git`
- `python3`
- Python package installer such as `pipx` or `python3-pip`
- C build tools such as `gcc` and `make` for Treesitter parser builds

### Recommended CLI tools

- `ripgrep` for Telescope live grep
- `ast-grep` for `:AstGrep` and related keymaps
- `ctags` for `vim-gutentags`
- `ipython` for the terminal REPL mappings
- `lazygit` for the LazyGit plugin

### Language tools

This config expects the following Python tooling to be available through Mason or your local environment:

- `basedpyright`
- `ruff`
- `mypy`

`basedpyright-langserver` is required for Python LSP. The config warns at runtime if it is not on `PATH`.

## Installation

### Install system packages

At minimum, install:

- Neovim `0.11+`
- `git`
- `python3`
- `pipx` or `python3-pip`
- `gcc`
- `make`

Recommended additions for the full workflow:

- `ripgrep`
- `ast-grep`
- Universal `ctags`
- `ipython`
- `lazygit`
- `npm`

### Suggested install methods

For Ubuntu or Debian, a practical baseline is:

```bash
sudo apt install git python3 python3-pip python3-venv gcc make ripgrep universal-ctags npm
sudo snap install nvim --classic
sudo snap install astral-uv --classic
sudo snap install lazygit --classic
```

Then install the Python-side tools expected by this config:

```bash
pipx install basedpyright
pipx install ruff
pipx install mypy
pipx install ipython
```

Alternative installs:

- `ast-grep`: `cargo install ast-grep` or `npm install -g @ast-grep/cli`
- `lazygit`: upstream release tarball if your distro package is too old
- Neovim: AppImage or upstream package if your distro repository does not provide `0.11+`

If you use `pipx`, ensure its bin directory is on `PATH`:

```bash
pipx ensurepath
```

Clone directly into Neovim's config directory:

```bash
git clone git@github.com:evinlort/nvim.git ~/.config/nvim
```

Start Neovim once to let `lazy.nvim` bootstrap itself. Then install plugins:

```vim
:Lazy sync
```

## Project Layout

```text
.
├── init.lua
├── lazy-lock.json
├── lua
│   ├── core
│   ├── plugins
│   └── snippets
├── scripts
│   └── validate_nvim_config.sh
└── tests
    ├── integration
    ├── minimal_init.lua
    ├── run.sh
    ├── smoke_config.lua
    └── unit
```

### Core modules

- `lua/core/options.lua`: editor defaults such as `listchars`, line numbers, mouse, and tags path
- `lua/core/leader.lua`: leader key setup
- `lua/core/autocmds.lua`: search highlight cleanup and yank-to-clipboard behavior
- `lua/core/diagnostic_config.lua`: global diagnostic window behavior
- `lua/core/python_env.lua`: Python, IPython, and venv resolution
- `lua/core/lsp_server_utils.lua`: Python root markers, `src/` discovery, and LSP path helpers
- `lua/core/lazy.lua`: lazy.nvim bootstrap and plugin aggregation

### Plugin modules

Plugin specs live under `lua/plugins/*.lua` and are aggregated by `lua/plugins/init.lua`. The repository keeps plugin behavior separated by concern rather than by plugin manager feature.

## Load Order

`init.lua` loads the config in this order:

1. `core.python_host`
2. disable `netrw`
3. `core.options`
4. `core.leader`
5. `core.autocmds`
6. `core.diagnostic_config`
7. `core.lazy`

That means Python host resolution and `netrw` shutdown happen before plugin setup.

## Python Workflow

### LSP

Python LSP is configured in `lua/plugins/lsp_servers.lua` using Neovim 0.11's `vim.lsp.config(...)` / `vim.lsp.enable(...)` API.

- `basedpyright`
  - strict type checking
  - uses shared root markers from `lua/core/lsp_server_utils.lua`
  - disables formatting so Ruff owns formatting
  - resolves `pythonPath` from the current project or active venv
  - adds `<root>/src` to `extraPaths` when present
- `ruff`
  - runs alongside `basedpyright`
  - keeps formatting enabled

Python root detection currently checks:

- `pyproject.toml`
- `setup.py`
- `setup.cfg`
- `requirements.txt`
- `Pipfile`
- `.git`

### Python environment resolution

`lua/core/python_env.lua` is the single source of truth for Python paths.

Resolution order:

1. active provider from `venv-selector.nvim`
2. upward search for `.venv`, `venv`, or `.env`
3. system `python3`

The same resolver is used for:

- `basedpyright` `pythonPath`
- terminal IPython commands

### Formatting and linting

- `<leader>fo` formats Python through the `ruff` LSP client
- `mypy` is installed through Mason tooling, but the lint plugin intentionally does not run it automatically to avoid overlap with `basedpyright`

## Search and Navigation

### Telescope

Configured in `lua/plugins/search.lua`.

Built-in mappings:

- `<leader><space>`: find files
- `<leader>ff`: find files
- `<leader>fg`: live grep
- `<leader>fb`: open buffers

Inside Telescope, `<C-t>` opens the selected item in a new tab.

### Call hierarchy

`telescope-hierarchy.nvim` is loaded into Telescope for deeper LSP navigation.

- `<leader>si`: incoming calls
- `<leader>so`: outgoing calls

### Structural search with ast-grep

This config includes a lightweight ast-grep workflow in `lua/plugins/search.lua`.

Commands:

- `:AstGrep` prompts for a structural pattern and sends results to quickfix
- `:AstGrep {pattern}` runs directly
- `:AstGrepSymbol` searches the word under cursor
- `:AstGrepSymbolPrompt` opens the prompt prefilled with the word under cursor

Keymaps:

- `<leader>sa`: ast-grep search for the word under cursor
- `<leader>sp`: ast-grep prompt prefilled from the word under cursor

Behavior:

- language is inferred from the current buffer filetype
- project root uses the same root resolution helper as Python LSP
- results are collected into quickfix and opened with `:copen`
- unsupported filetypes or missing `ast-grep` show a warning instead of failing silently

### Outline and file tree

- `<leader>a`: toggle Aerial outline
- `<leader>e`: toggle NvimTree
- `<leader>fe`: toggle NvimTree
- `<leader>ef`: reveal current file in NvimTree

## LSP and Editing Keymaps

Leader key is `\`.

### LSP UI

- `K`: hover docs through Lspsaga
- `gd`: combined definitions and references finder
- `gD`: go to definition in a new tab
- `<C-LeftMouse>`: definition jump, opens a new tab if target is another file
- `<leader>rn`: rename
- `<leader>ca`: code action

### Formatting

- `<leader>fo`: format Python file or visual selection with Ruff

### Refactor

- `<leader>rr`: Telescope refactor picker
- `<leader>re`: extract function
- `<leader>rv`: extract variable

### Comments and minimap

- `gcc`: comment current line
- `<leader>cc`: comment line or visual selection
- `<leader>mo`: toggle minimap
- `<leader>mm`: open minimap
- `<leader>mc`: close minimap
- `<leader>mf`: focus or unfocus minimap

## Git Workflow

### Plugins

- `vim-fugitive`
- `gitsigns.nvim`
- `lazygit.nvim`

### Keymaps

- `<leader>gb`: `Git blame`
- `<leader>gh`: line history in normal mode, range history in visual mode, with fallback to file history when line history fails
- `<leader>gp`: inline hunk preview
- `<leader>gB`: toggle current-line blame
- `<leader>gl`: open LazyGit

The custom Fugitive helper in `lua/plugins/git-tools.lua` avoids `git -C` in the generated Fugitive command and falls back to `git log --follow -p -- <file>` when `-L` fails.

## Terminal and REPL

Configured with `toggleterm.nvim`.

- `<leader>pf`: IPython in a floating terminal
- `<leader>pv`: IPython in a vertical terminal
- `<leader>t`: horizontal terminal using the current shell
- `<C-\>`: ToggleTerm default mapping

Terminal commands use the same Python environment resolver as the LSP stack, so project-local IPython is preferred when available.

## Testing and Validation

### Smoke validation

Runs Neovim headlessly and verifies:

- the config loads without Lua errors
- `telescope` can be required
- `lspconfig` can be required
- the Telescope hierarchy extension loads
- `:AstGrep` is registered

Command:

```bash
bash scripts/validate_nvim_config.sh
```

Forced failure check:

```bash
NVIM_SMOKE_FORCE_FAIL=1 bash scripts/validate_nvim_config.sh
```

### Unit and integration tests

The main test entrypoint is:

```bash
bash tests/run.sh
```

It runs:

- Plenary unit tests from `tests/unit`
- integration coverage from `tests/integration/test_git_tools_gh.lua`

If your plugins are not in the default lazy.nvim data directory, set:

- `PLENARY_PATH`
- `FUGITIVE_PATH`

before running the test script.

## External Tooling Notes

- `lazy-lock.json` is committed and should be kept up to date when plugin versions change
- `ast-grep` is a manual external dependency; it is not installed by Mason here
- `mypy` is installed through Mason tooling but not wired into on-save diagnostics
- `venv-selector.nvim` depends on Neovim 0.11 LSP APIs, so older Neovim versions are not supported

## Maintenance

Common maintenance commands:

```vim
:Lazy sync
:Mason
:checkhealth
```

For documentation or behavior changes that touch commands, keymaps, or startup logic, run both:

```bash
bash scripts/validate_nvim_config.sh
bash tests/run.sh
```
