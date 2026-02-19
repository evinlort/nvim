return {
  -- LSP: mason + lspconfig для basedpyright (Python)
  { "mason-org/mason.nvim",
    opts = {
      pip = {
        pip_args = { "--python", vim.fn.exepath("python3") },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },  -- Установка серверов
  { "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = false,
      ensure_installed = { "ruff", "basedpyright" },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },   -- Интеграция с lspconfig
  { "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "mypy",
      },
      auto_update = false,
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
