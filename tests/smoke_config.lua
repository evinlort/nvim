local function fail(message)
  vim.api.nvim_echo({ { message, "ErrorMsg" } }, true, {})
  vim.cmd("cquit 1")
end

if vim.env.NVIM_SMOKE_FORCE_FAIL == "1" then
  fail("Forced smoke failure")
end

local ok, telescope = pcall(require, "telescope")
if not ok then
  fail("Failed to require telescope")
end

ok = pcall(require, "lspconfig")
if not ok then
  fail("Failed to require lspconfig")
end

local load_ok = pcall(telescope.load_extension, "hierarchy")
if not load_ok then
  fail("Failed to load telescope hierarchy extension")
end

ok = pcall(require, "telescope._extensions.hierarchy")
if not ok then
  fail("Failed to require telescope hierarchy extension module")
end

if vim.fn.exists(":AstGrep") ~= 2 then
  fail("AstGrep command is not registered")
end

vim.cmd("quitall")
