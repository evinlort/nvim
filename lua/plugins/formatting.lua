return {
  -- Linting/formatting
  { "nvimtools/none-ls.nvim",                 -- Repo (string)
    event = { "BufReadPre", "BufNewFile" },
    ft = { "python" },
    keys = {
      {
        "<leader>fo",
        function()
          vim.lsp.buf.format({
            bufnr = 0,
            timeout_ms = 10000,
            filter = function(client)
              if not client:supports_method("textDocument/formatting") then
                return false
              end

              return client.name == "null-ls" or client.name == "none-ls"
            end,
          })
        end,
        desc = "Форматировать файл (PEP8)",
      },
    },
    config = function()
      require("null-ls").setup({
        sources = {
          -- require("null-ls").builtins.formatting.black,
          require("null-ls").builtins.formatting.black.with({
            prefer_local = ".venv/bin",
            extra_args = { "--line-length=88" }, -- PEP8: максимальная длина строки
          }),
        },
      })
    end,
  },
}
