local M = {}

-- <leader>gh: line history if possible, otherwise fallback to file history across renames
local function git_root()
  local out = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
  if vim.v.shell_error ~= 0 or not out[1] or out[1] == "" then
    return nil
  end
  return out[1]
end

local function relpath_from_root(root, abs)
  -- robust relative path: use git itself (works when abs is inside worktree)
  local out = vim.fn.systemlist({ "git", "-C", root, "ls-files", "--full-name", "--", abs })
  if vim.v.shell_error == 0 and out[1] and out[1] ~= "" then
    return out[1]
  end
  -- fallback: naive strip root prefix
  local prefix = root:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
  return abs:gsub("^" .. prefix .. "/?", "")
end

local function gh_line_or_file_history(start_line, end_line)
  local root = git_root()
  if not root then
    vim.notify("Not inside a git repository", vim.log.levels.ERROR)
    return
  end

  local abs = vim.fn.expand("%:p")
  local rel = relpath_from_root(root, abs)
  local rel_escaped = vim.fn.fnameescape(rel)

  local ok = pcall(function()
    vim.cmd(string.format("Git log -L %d,%d:%s", start_line, end_line, rel_escaped))
  end)

  if ok then
    return
  end

  -- fallback: file history across renames (not line-level)
  vim.cmd(string.format("Git log --follow -p -- %s", rel_escaped))
end

M._test = {
  git_root = git_root,
  relpath_from_root = relpath_from_root,
  gh_line_or_file_history = gh_line_or_file_history,
}

M[1] = {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>gb", "<cmd>Git blame<CR>", mode = { "n", "v", "x" }, desc = "Git blame" },
    -- normal mode
    {
      "<leader>gh",
      function()
        local line = vim.fn.line(".")
        gh_line_or_file_history(line, line)
      end,
      mode = "n",
      desc = "Git history (line; fallback file --follow)",
    },
    -- visual mode
    {
      "<leader>gh",
      function()
        local s = vim.fn.line("'<")
        local e = vim.fn.line("'>")
        gh_line_or_file_history(s, e)
      end,
      mode = "v",
      desc = "Git history (range; fallback file --follow)",
    },

    -- {
    --   "<leader>gh",
    --   function()
    --     local file = vim.fn.expand("%")
    --     local line = vim.fn.line(".")
    --     vim.cmd(string.format(
    --       "Git log -L %d,%d:%s",
    --       line,
    --       line,
    --       file
    --     ))
    --   end,
    --   mode = "n",
    --   desc = "Git history of current line",
    -- },
    -- {
    --   "<leader>gh",
    --   function()
    --     local file = vim.fn.expand("%")
    --     local start_line = vim.fn.line("'<")
    --     local end_line = vim.fn.line("'>")
    --
  --       vim.cmd(string.format(
  --         "Git log -L %d,%d:%s",
  --         start_line,
  --         end_line,
  --         file
  --       ))
  --     end,
  --     mode = "v",
  --     desc = "Git history of selected block",
  --   },
  },
}

M[2] = {
  "kdheepak/lazygit.nvim",
  keys = {
    { "<leader>gl", "<cmd>LazyGit<CR>", mode = { "n", "v", "x" }, desc = "Открыть LazyGit" },
  },
}

return M
