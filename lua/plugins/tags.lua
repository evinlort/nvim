return {
  { "ludovicchabant/vim-gutentags",
    config = function()
      vim.g.gutentags_ctags_executable = 'ctags' -- Используем Universal Ctags
      vim.g.gutentags_project_root = { '.git', '.hg', '.svn', 'pyproject.toml' }
      vim.g.gutentags_cache_dir = vim.fn.stdpath('cache') .. '/tags'
      vim.g.gutentags_generate_on_new = true
      vim.g.gutentags_generate_on_missing = true
      vim.g.gutentags_generate_on_write = true
      vim.g.gutentags_background_update = true
    end
  },
}
