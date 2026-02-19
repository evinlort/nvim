local function is_python_buffer()
  return vim.bo.filetype == "python"
end

local function ruff_filter(client)
  return client.name == "ruff"
end

local function format_python_buffer()
  if not is_python_buffer() then
    return
  end

  vim.lsp.buf.format({
    async = true,
    bufnr = 0,
    filter = ruff_filter,
  })
end

local function format_python_range()
  if not is_python_buffer() then
    return
  end

  vim.lsp.buf.format({
    async = true,
    filter = ruff_filter,
    range = {
      ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
      ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
    },
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>fo",
        format_python_buffer,
        mode = "n",
        desc = "Format file (Ruff)",
      },
      {
        "<leader>fo",
        format_python_range,
        mode = "v",
        desc = "Format selected lines (Ruff)",
      },
    },
  },
}
