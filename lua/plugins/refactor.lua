return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
    keys = {
      {
        "<leader>rr",
        function()
          require("telescope").extensions.refactoring.refactors()
        end,
        mode = { "n", "x" },
        desc = "Рефакторинг",
      },
      { "<leader>re", ":Refactor extract ", mode = "x", desc = "Извлечь в функцию" },
      {
        "<leader>rv",
        function()
          return require("refactoring").refactor("Extract Variable")
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Извлечь переменную",
      },
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = { python = true },
        show_success_message = true
      })
    end
  },
}
