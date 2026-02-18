vim.diagnostic.config({
  float = {
    border = "rounded",      -- рамка: "single", "double", "rounded", "solid", "shadow"
    source = true,       -- показывать источник (напр. "basedpyright")
    header = "Troubles:", -- заголовок окна
    prefix = "● ",            -- символ перед сообщениями
    focusable = false,       -- окно не перехватывает курсор
  },
  virtual_text = false,      -- отключить inline-текст в коде
  signs = true,              -- значки в колонке слева
  underline = true,          -- подчёркивать ошибки
  update_in_insert = false,
})
