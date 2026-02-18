local M = {}

-- Ctrl+ЛКМ: к определению. Новая вкладка только если другой файл.
function M.ctrl_click_lsp_definition()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx)
    if err then
      vim.notify("LSP ошибка: " .. (err.message or tostring(err)), vim.log.levels.ERROR)
      return
    end
    if not result or (vim.tbl_islist(result) and #result == 0) then
      vim.notify("Определение не найдено", vim.log.levels.WARN)
      vim.cmd("tag " .. vim.fn.expand("<cword>"))
      return
    end

    local loc = vim.tbl_islist(result) and result[1] or result
    local uri = loc.uri or loc.targetUri
    local range = loc.range or loc.targetRange
    local target = vim.uri_to_fname(uri)
    local current = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
    local target_abs = vim.fn.fnamemodify(target, ":p")

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local enc = client and client.offset_encoding or "utf-16"

    if target_abs ~= current then
      vim.cmd("tabnew " .. vim.fn.fnameescape(target))
      vim.lsp.util.jump_to_location(loc, enc)
    else
      vim.lsp.util.jump_to_location(loc, enc)
    end
  end)
end

return M
