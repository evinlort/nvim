return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",     -- необязательно, но красивее
    },
    ft = { "markdown" },
    opts = {
      heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      code = { style = "full" },
      checkbox = { enabled = true },
      -- можно отключить latex если не нужен
      latex = { enabled = false },
    },
  },
}
