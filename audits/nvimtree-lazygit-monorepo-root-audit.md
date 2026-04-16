# NvimTree + LazyGit Monorepo Root Audit

Date: 2026-04-16

## 1. Verdict

FAIL

The implementation does not fully fix the monorepo root issue. The explicit-root path works after manually selecting a root with `gr`, and LazyGit priority is correct when `vim.t.active_project_root` is already set. However, startup mode `nvim proj2` is still wrong: NvimTree opens rooted at `proj2`, while LazyGit resolves the parent cwd because no active root is initialized.

No files were modified during the audit phase. `bash tests/run.sh` passed.

## 2. Critical Issues

### `nvim proj2` Does Not Initialize an Explicit Active Root

Observed in a live headless probe from a parent directory where `proj2` is a git repo:

```text
MODE=nvim proj2 sibling repo
cwd=/tmp/...                -- parent
tabcwd=/tmp/...             -- parent
buf=/tmp/.../NvimTree_1
active=nil
tree=/tmp/.../proj2
lg=/tmp/...                 -- wrong; should be proj2
```

Root cause:

- `lua/core/project_root.lua:97` resolves LazyGit by active root, then current buffer git root, then tab cwd.
- During directory hijack startup, the current buffer is the synthetic NvimTree buffer, not a real file under `proj2`.
- `lua/plugins/explorer.lua:45` opens NvimTree for the directory without setting `vim.t.active_project_root`.

### NvimTree Buffer Names Can Make Current-File Root Resolution Wrong

`lua/core/project_root.lua:103` treats `vim.api.nvim_buf_get_name(0)` as a real file path. For an NvimTree buffer named like `/parent/NvimTree_1`, `git_root_for_path()` can resolve the parent repo or fall through to the parent cwd. That is not the selected tree root.

## 3. Logic Risks

### NvimTree Root Is Not Restored Per Tab

Active root is tab-local, but NvimTree's displayed root is not restored per tab.

Observed:

```text
tab1 active = proj1, tree = proj1
tab2 active = proj2, tree = proj2
back to tab1: active = proj1, tree = proj2
LazyGit = proj1
```

LazyGit stays correct because `vim.t.active_project_root` is tab-local, but the tree UI can show another tab's root after tab switching. This conflicts with the selected-root mental model.

### Global Tree Root Change With Tab-Local State

`lua/core/project_root.lua:65` changes the NvimTree root globally when setting a tab-local root. This creates the multi-tab mismatch above.

### Test Coverage Misses Real Startup Behavior

The unit tests cover pure resolver behavior but do not exercise the actual NvimTree directory-hijack startup path.

Relevant coverage gap: `tests/unit/project_root_spec.lua:61`.

## 4. Edge Cases Missed

- `nvim proj2` from a parent directory.
- LazyGit launched while focus is inside NvimTree and no explicit root exists.
- Multiple tabs with different active roots and NvimTree open.
- `TabEnter` behavior after a tree root was changed in another tab.
- Special buffers: NvimTree, terminal, help, and quickfix should not be treated as current files for git-root resolution.

## 5. Suggested Improvements

- Initialize `vim.t.active_project_root` from the startup directory argument when NvimTree hijacks a directory. This makes `nvim .` and `nvim proj2` explicit instead of relying on fallback cwd.
- In `resolve_for_lazygit()`, skip current-file git-root resolution for non-file buffers, especially `NvimTree`.
- Add tests for startup-root initialization and special-buffer LazyGit fallback.
- Add a small `TabEnter` sync so NvimTree root follows the current tab's active root when one exists.

## 6. Exact Patch Plan

Because a critical issue exists, the recommended patch plan is:

1. Add `notify = false` support to `set_active()` so startup initialization does not spam notifications.
2. Add a startup helper in `lua/core/project_root.lua`:
   - read `vim.fn.argv(0)`
   - resolve it to an absolute path before any `tcd`
   - if it is a directory, call `set_active(path, { update_tree = false, notify = false })`
3. Call that helper from `lua/plugins/explorer.lua` after `nvim-tree.setup()` or on `VimEnter`, so `nvim .` and `nvim proj2` both get a tab-local active root.
4. Harden `resolve_for_lazygit()`:
   - only use current-buffer git root when `vim.bo.buftype == ""`
   - optionally require the buffer name to point to a readable file or directory
   - do not use synthetic NvimTree buffer names as file paths
5. Add tests:
   - startup directory root initialization for `.` and `proj2`
   - LazyGit from an NvimTree buffer does not derive root from `NvimTree_1`
   - two tabs with different active roots keep LazyGit resolution separate
6. Add optional `TabEnter` sync:
   - on `TabEnter`, if `get_active()` exists and NvimTree is available/open, call `api.tree.change_root(active)` without changing cwd or notifying
