return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    config = function()
      require("luasnip.loaders.from_lua").load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })
    end,
  },
  -- Автодополнение (cmp)
  { "hrsh7th/nvim-cmp",                      -- Основной cmp
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path"
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        sources = {
          { name = 'luasnip' },
          { name = 'nvim_lsp' },  -- LSP для автодополнения (basedpyright)
          { name = 'buffer' },    -- Слова из текущего буфера
          { name = 'path' },      -- Файловые пути
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(), -- Вызов автодополнения
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Подтверждение выбора
          -- ['<Tab>'] = cmp.mapping.select_next_item(), -- Переключение на следующий элемент
          -- ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Переключение на предыдущий элемент
          ['<Down>'] = cmp.mapping.select_next_item(), -- Переключение на следующий элемент
          ['<Up>'] = cmp.mapping.select_prev_item(), -- Переключение на предыдущий элемент

        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- Поддержка сниппетов
          end,
        },
      }
    end
  },
}
