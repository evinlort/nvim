local M = {}

local function normalize(path)
  if not path or path == "" then
    return nil
  end
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function directory_for_path(path)
  local normalized = normalize(path)
  if not normalized then
    return nil
  end
  if vim.fn.isdirectory(normalized) == 1 then
    return normalized
  end
  return vim.fs.dirname(normalized)
end

function M.git_root_for_path(path)
  local dir = directory_for_path(path)
  if not dir then
    return nil
  end

  local out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
    return nil
  end
  return normalize(out[1])
end

function M.resolve_from_path(path)
  local dir = directory_for_path(path)
  if not dir then
    return nil
  end
  return M.git_root_for_path(dir) or dir
end

function M.get_active()
  local root = normalize(vim.t.active_project_root)
  if root and vim.fn.isdirectory(root) == 1 then
    return root
  end
  return nil
end

function M.set_active(path, opts)
  opts = opts or {}

  local root = M.resolve_from_path(path)
  if not root then
    vim.notify("Could not resolve project root", vim.log.levels.WARN, { title = "Project root" })
    return nil
  end

  vim.t.active_project_root = root

  if opts.tcd ~= false then
    vim.cmd("tcd " .. vim.fn.fnameescape(root))
  end

  if opts.update_tree ~= false then
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      api.tree.change_root(root)
    end
  end

  vim.notify("Active project root: " .. root, vim.log.levels.INFO, { title = "Project root" })
  return root
end

function M.set_active_from_nvim_tree_node()
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    vim.notify("NvimTree API is unavailable", vim.log.levels.WARN, { title = "Project root" })
    return nil
  end

  local node = api.tree.get_node_under_cursor()
  if not node or not node.absolute_path then
    vim.notify("No NvimTree node under cursor", vim.log.levels.WARN, { title = "Project root" })
    return nil
  end

  local path = node.absolute_path
  if node.type ~= "directory" then
    path = vim.fs.dirname(path)
  end

  return M.set_active(path)
end

function M.resolve_for_lazygit()
  local active = M.get_active()
  if active then
    return active
  end

  local current_file = vim.api.nvim_buf_get_name(0)
  local file_root = M.git_root_for_path(current_file)
  if file_root then
    return file_root
  end

  return normalize(vim.fn.getcwd(-1, 0)) or normalize(vim.fn.getcwd())
end

function M.open_lazygit()
  local root = M.resolve_for_lazygit()
  if not root then
    vim.notify("Could not resolve LazyGit root", vim.log.levels.WARN, { title = "LazyGit" })
    return
  end

  require("lazygit").lazygit(root)
end

M._test = {
  directory_for_path = directory_for_path,
  normalize = normalize,
}

return M
