local M = {}

local function resolve_startpath(root_dir, bufnr)
  if root_dir and root_dir ~= "" then
    return root_dir
  end
  local bufname = vim.api.nvim_buf_get_name(bufnr or 0)
  if bufname ~= "" then
    return vim.fs.dirname(bufname)
  end
  return nil
end

local function resolve_root_dir(root_dir, bufnr)
  if root_dir and root_dir ~= "" then
    return root_dir
  end
  local startpath = resolve_startpath(nil, bufnr)
  if not startpath then
    return nil
  end
  local root_marker = vim.fs.find({ "pyproject.toml", ".git" }, { upward = true, path = startpath })[1]
  if root_marker then
    return vim.fs.dirname(root_marker)
  end
  return nil
end

local function resolve_extra_paths(root_dir, bufnr)
  local resolved_root = resolve_root_dir(root_dir, bufnr)
  if not resolved_root then
    return {}
  end
  local src_path = vim.fs.joinpath(resolved_root, "src")
  if vim.fn.isdirectory(src_path) == 1 then
    return { src_path }
  end
  return {}
end

local function resolve_python_path(python_env, root_dir, bufnr)
  local startpath = resolve_startpath(root_dir, bufnr)
  if startpath then
    return python_env.get_python_path(startpath)
  end
  return vim.fn.exepath("python3")
end

local function debug_python_roots(roots)
  local python_env = require("core.python_env")
  local resolved = {}
  for _, root_dir in ipairs(roots or {}) do
    resolved[root_dir] = {
      pythonPath = resolve_python_path(python_env, root_dir),
      extraPaths = resolve_extra_paths(root_dir),
    }
  end
  return resolved
end

M.resolve_startpath = resolve_startpath
M.resolve_root_dir = resolve_root_dir
M.resolve_extra_paths = resolve_extra_paths
M.resolve_python_path = resolve_python_path
M.debug_python_roots = debug_python_roots

return M
