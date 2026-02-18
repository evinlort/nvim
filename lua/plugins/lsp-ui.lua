return {
  {
    "glepnir/lspsaga.nvim",
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "LSP: hover doc" },
      { "<leader>rn", "<cmd>Lspsaga rename<CR>", desc = "LSP: rename" },
      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "LSP: code action" },
      { "gd", "<cmd>Lspsaga finder def+ref<CR>", desc = "LSP: найти определения/ссылки" },
    },
    config = function()
      require("lspsaga").setup({
        code_action = {
          keys = {
            quit = "q", -- клавиша для закрытия
          },
          auto_close = true, -- автоматически закрывать после выбора действия
        },
        finder = {
          keys = {
            shuttle = '[w',  -- Переключение окон
            toggle_or_open = 'o',  -- Открыть/переключить
            vsplit = 's',  -- Вертикальный сплит
            split = 'i',  -- Горизонтальный сплит
            tabe = 't',  -- Новая вкладка
            quit = 'q',
          },
        },
        lightbulb = {
          virtual_text = false
        }
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" }
  },
}
