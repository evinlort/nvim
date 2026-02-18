vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "/,?",  -- после выхода из поиска
  callback = function()
    vim.defer_fn(function()
      if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
      end
    end, 2000)  -- 2000 мс = 2 секунды
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and vim.v.event.regname == "" then
      vim.fn.setreg("+", vim.fn.getreg('"'))
    end
  end,
})
