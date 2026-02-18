return {
  -- Treesitter: подсветка
  { "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",  -- Команда build (Lua: string)
    config = function()
      require("nvim-treesitter.configs").setup({ ensure_installed = { "python" } })
    end,
  },
}
