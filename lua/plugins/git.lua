-- lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" }, -- <-- критично: грузим при открытии файлов
    keys = {
      { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", mode = { "n", "v", "x" }, desc = "Git: inline preview hunk" },
      { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", mode = "n", desc = "Git: toggle inline blame" },
    },
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 100,
          ignore_whitespace = true,
        },
        current_line_blame_formatter = "<author> <author_time:%d-%m-%y %H:%M># <summary>",
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
        },
        numhl = true,
        linehl = false,
        word_diff = false,
      })
    end,
  },
}

-- return {
--   -- Git signs
--   { "lewis6991/gitsigns.nvim", version = "*",
--     keys = {
--       { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", mode = { "n", "v", "x" }, desc = "Git: inline preview hunk" },
--     },
--     config = function()
--       require("gitsigns").setup({
--         current_line_blame = true,  -- включает blame для текущей строки
--         current_line_blame_opts = {
--           virt_text = true,         -- показ как виртуальный текст
--           virt_text_pos = "eol",    -- позиция: в конце строки (inline после кода)
--           delay = 100,             -- задержка 1 сек для показа
--           ignore_whitespace = true,
--         },
--         current_line_blame_formatter = "<author> <author_time:%d-%m-%y %H:%M># <summary>",  -- формат: автор, дата, сообщение коммита
--         preview_config = {
--           border = "rounded",  -- стиль окна предпросмотра
--           style = "minimal",
--           relative = "cursor",
--         },
--         -- убедимся, что virt_text для hunk включен
--         numhl = true,  -- подсветка номеров строк для изменений
--         linehl = false, -- отключение подсветки всей строки
--         word_diff = false, -- отключение diff внутри строки
--       })
--     end,
--   },
-- }
