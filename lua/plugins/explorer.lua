return {
  -- File explorer
  { "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
      { "<leader>fe", "<cmd>NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
      {
        "<leader>ef",
        function()
          local api = require("nvim-tree.api")
          api.tree.open()
          api.tree.find_file(vim.fn.expand("%:p"))
        end,
        desc = "Открыть NvimTree на текущем файле",
      },
    },
    config = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
	api.config.mappings.default_on_attach(bufnr)
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end
        -- открыть узел в новой вкладке
        map("t", api.node.open.tab, "Открыть в вкладке")
        -- альтернативно: Enter
        map("<CR>", api.node.open.tab, "Открыть в вкладке")
        -- Create a new file
        map("c", api.fs.create, "Создать новый файл")
        -- Rename the file
        map("r", api.fs.rename, "Переименовать файл")
        -- Delete the file
        map("d", api.fs.remove, "Удалить файл")
        -- Open folder by double-click
        map("<2-LeftMouse>", api.node.open.tab, "Открыть папку/файл двойным кликом")
      end

      require("nvim-tree").setup({
        hijack_netrw = true,
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        filters = { dotfiles = false },
        git = {
          enable = true,
          ignore = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = true,
          },
        },
        on_attach = on_attach,
      })
    end,
  },
}
