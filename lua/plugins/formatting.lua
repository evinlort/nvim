return {
  -- Linting/formatting
  { "nvimtools/none-ls.nvim",                 -- Repo (string)
    keys = {
      {
        "<leader>fo",
        function()
          vim.lsp.buf.format({ name = "null-ls" })
        end,
        desc = "Форматировать файл (PEP8)",
      },
    },
    config = function()
      require("null-ls").setup({
        sources = {
          -- require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.formatting.black.with({
            extra_args = { "--line-length=100" }, -- PEP8: максимальная длина строки
          }),
        },
      })
    end,
  },
}
