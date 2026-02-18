return {
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        triggers = { "<leader>" },
        win = {
          border = "single",
          height = { min = 5, max = 15 },
          width = { min = 20, max = 50 },
        },
        layout = { align = "center" },
        show_keys = true,
      })
    end,
  },
}
