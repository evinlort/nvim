return {
  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*",
    keys = {
      {
        "<leader>pf",
        function()
          local ipython_path = require("core.python_env").get_ipython_path()
          vim.cmd('TermExec direction=float cmd="' .. ipython_path .. '"')
        end,
        desc = "Открыть IPython в плавающем окне",
      },
      {
        "<leader>pv",
        function()
          local ipython_path = require("core.python_env").get_ipython_path()
          vim.cmd('ToggleTerm direction=vertical cmd="' .. ipython_path .. '" size=55')
        end,
        desc = "Открыть IPython в плавающем окне",
      },
      {
        "<leader>t",
        function()
          local ipython_path = require("core.python_env").get_ipython_path()
          vim.cmd('ToggleTerm direction=horizontal size=20 cmd="' .. vim.o.shell .. " -c " .. ipython_path .. '"')
        end,
        desc = "Open terminal window with SHELL",
      },
    },
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = {
          border = "rounded",
          width = 80,
          height = 20,
        },
        --shell = vim.o.shell, -- Используем стандартную оболочку ($SHELL)
      })
    end,
  },
}
