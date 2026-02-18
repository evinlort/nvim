return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      require("core.venv_selector_adapter")
    end,
    config = function()
      require("venv-selector").setup({
        name = { "*venv*" },  -- Имена venv
        parents = 2,  -- Глубина поиска
        auto_refresh = true,
      })
    end,
    event = "VeryLazy",
  },
}
