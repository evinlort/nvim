return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",  -- Спокойный тёмный вариант (или "latte" для светлого)
        background = { light = "latte", dark = "mocha" },
        transparent_background = false,
        color_overrides = {
          mocha = {
            base = "#333333",      -- Фон как в Desert
            text = "#ffffff",      -- Текст как в Desert
            sky = "#87ceeb",       -- Комментарии
            peach = "#ffa0a0",     -- Константы
            yellow = "#e6db74",    -- Строки
            lavender = "#40ffff",  -- Идентификаторы
            -- Добавьте больше по необходимости, напр. green = "#8fb28f" для Statement
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
      vim.cmd([[highlight LineNr guifg=#909080]])                    -- Lines number color
      vim.cmd([[highlight GitSignsCurrentLineBlame guifg=#07a3b8]])  -- inline Git blame foreground
      vim.cmd([[highlight GitSignsCurrentLineBlame guibg=#3a3d3b]])  -- inline Git blame background
    end,
  },
}
