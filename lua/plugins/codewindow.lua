return {
  {
    "gorbit99/codewindow.nvim",
    lazy = false,
    enabled = false,
    keys = {
      {
        "<leader>mo",
        function()
          local codewindow = require("codewindow")
          local buf = vim.fn.bufnr("CodeWindow")
          if buf ~= -1 and vim.fn.bufwinnr(buf) ~= -1 then
            pcall(codewindow.close_minimap)
            return
          end
          for _, b in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_name(b) == "CodeWindow" then
              pcall(vim.api.nvim_buf_delete, b, { force = true })
            end
          end
          codewindow.open_minimap()
        end,
        desc = "Toggle Minimap",
      },
      { "<leader>mc", function() require("codewindow").close_minimap() end, desc = "Close Minimap" },
      { "<leader>mf", function() require("codewindow").toggle_focus() end, desc = "Focus Minimap" },
    },
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({
        use_treesitter = true,
        use_lsp = true,
        minimap_width = 20,
        auto_enable = false,
      })
    end,
  },
}
