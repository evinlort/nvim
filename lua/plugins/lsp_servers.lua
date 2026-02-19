local keymaps = require("core.lsp_keymaps")
local lsp_utils = require("core.lsp_server_utils")

local plugins = {
  { "neovim/nvim-lspconfig",                 -- Конфиг LSP
    dependencies = { "mason.nvim", "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    keys = keymaps.keys,
    config = function()
      local python_env = require("core.python_env")
      local caps = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config["ruff"] = {
        -- пусть работает рядом с basedpyright
        init_options = { settings = { args = {} } },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = true
          client.server_capabilities.documentRangeFormattingProvider = true
        end,
      }

      vim.lsp.config["basedpyright"] = {
        capabilities = caps,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          python = {},
          basedpyright = {
            analysis = {
              typeCheckingMode = "strict",
              diagnosticSeverityOverrides = {
                reportUnknownMemberType = "none",   -- отключаем конкретную диагностику
                reportUnknownVariableType = "warning", -- по желанию
                reportUnknownParameterType = "warning", -- по желанию
                reportUnknownArgumentType = "information",
              },
              extraPaths = {},
              autoSearchPaths = true,  -- Авто-поиск в src
              useLibraryCodeForTypes = true,
            },
          },
        },
        on_new_config = function(new_config, new_root_dir)
          local root_dir = new_root_dir or new_config.root_dir
          local python_path = lsp_utils.resolve_python_path(python_env, root_dir, 0)
          local extra_paths = lsp_utils.resolve_extra_paths(root_dir, 0)
          new_config.settings = new_config.settings or {}
          new_config.settings.python = new_config.settings.python or {}
          new_config.settings.python.pythonPath = python_path
          new_config.settings.basedpyright = new_config.settings.basedpyright or {}
          new_config.settings.basedpyright.analysis = new_config.settings.basedpyright.analysis or {}
          new_config.settings.basedpyright.analysis.extraPaths = extra_paths
        end,
      }

      vim.lsp.enable("basedpyright")
      vim.lsp.enable("ruff")
    end,
  },
}

plugins._debug_python_roots = lsp_utils.debug_python_roots

return plugins
