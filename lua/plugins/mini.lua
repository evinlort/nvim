return {
  {
    "echasnovski/mini.nvim",
    version = false,
    keys = {
      { "<leader>cc", "gcc", mode = "n", remap = true, desc = "Комментировать строку" },
      { "<leader>cc", "gc", mode = "v", remap = true, desc = "Комментировать выделение" },
      { "<leader>mo", function() MiniMap.toggle() end, desc = "Toggle Minimap" },
      { "<leader>mm", function() MiniMap.open() end, desc = "Open Minimap" },
      { "<leader>mc", function() MiniMap.close() end, desc = "Close Minimap" },
      { "<leader>mf", function() MiniMap.toggle_focus() end, desc = "Focus Minimap" },
    },
    config = function()
      require("mini.comment").setup({
        mappings = {
          comment = '',        -- Отключить <gc>
          comment_line = 'gcc',   -- Отключить <gcc>
          textobject = 'gc',
        },
      })
      require("mini.map").setup({
        window = {
          side = "right",
          width = 10,
        },
      })
    end,
  },
}
