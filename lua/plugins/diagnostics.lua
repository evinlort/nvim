return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Buffer Diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
    },
    opts = {
      modes = {
        symbols = {
          mode = "lsp_document_symbols",
          filter = {
            kind = { "Class", "Function", "Method" },  -- Python-структуры
            dedup = false,
            severity = vim.diagnostic.severity.ERROR,
          },
        },
        diagnostics = { auto_open = false },
      },
      --auto_open = true,  -- Автооткрытие при ошибках
      auto_refresh = true,
      win = { position = "bottom", height = 10, relative = "editor", zindex = 50, },  -- Панель снизу
      focus = true,
    },
  },
}
