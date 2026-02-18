local M = {}

M.keys = {
  {
    "gD",
    function()
      vim.cmd("tab split")
      vim.lsp.buf.definition()
    end,
    desc = "LSP: определение в новой вкладке",
  },
  {
    "<C-LeftMouse>",
    '<LeftMouse><cmd>lua require("core.lsp_utils").ctrl_click_lsp_definition()<CR>',
    mode = { "n", "v" },
    noremap = true,
    silent = true,
    desc = "LSP: определение в новой вкладке",
  },
}

return M
