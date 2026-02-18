return {
  { "nvim-lua/plenary.nvim" },
  -- Telescope: поиск
  { "nvim-telescope/telescope.nvim",
    tag = "0.1.8",  -- Версия (Lua: tag string)
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-t>"] = actions.select_tab,  -- insert-mode
            },
            n = {
              ["<C-t>"] = actions.select_tab,  -- normal-mode в списке Telescope
            },
          },
        },
      })
    end,
  },
}
