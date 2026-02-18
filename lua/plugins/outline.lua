return {
  {
    'stevearc/aerial.nvim',
    keys = {
      { "<leader>a", "<cmd>AerialToggle!<CR>", mode = { "n", "x" }, desc = "Toggle Aerial outline" },
    },
    opts = {
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
      filter_kind = { 'Class', 'Method', 'Function' },
      backends = { 'treesitter', 'lsp' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },
}
