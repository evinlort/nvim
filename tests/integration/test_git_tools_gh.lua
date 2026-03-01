local git_tools = require("plugins.git-tools")
local subject = git_tools._test

local function fail(message)
  io.stderr:write("FAIL: " .. message .. "\n")
  os.exit(1)
end

local function run_git(args)
  vim.fn.system(args)
  if vim.v.shell_error ~= 0 then
    fail("git command failed: " .. table.concat(args, " "))
  end
end

if vim.fn.exists(":Git") == 0 then
  fail("fugitive :Git command is unavailable in test runtimepath")
end

local repo = vim.fn.tempname()
vim.fn.mkdir(repo, "p")
vim.fn.mkdir(repo .. "/src", "p")
vim.fn.writefile({ "line one", "line two" }, repo .. "/src/file.lua")

run_git({ "git", "-C", repo, "init" })
run_git({ "git", "-C", repo, "config", "user.name", "Test User" })
run_git({ "git", "-C", repo, "config", "user.email", "test@example.com" })
run_git({ "git", "-C", repo, "add", "src/file.lua" })
run_git({ "git", "-C", repo, "commit", "-m", "init" })

vim.cmd("cd " .. vim.fn.fnameescape(repo))
vim.cmd("edit " .. vim.fn.fnameescape(repo .. "/src/file.lua"))

local ok, err = pcall(subject.gh_line_or_file_history, 1, 1)
if not ok then
  if tostring(err):find("-C is not supported", 1, true) then
    fail("received previous fugitive error: " .. tostring(err))
  end
  fail("unexpected error: " .. tostring(err))
end

if tostring(vim.v.errmsg):find("-C is not supported", 1, true) then
  fail("vim.v.errmsg still contains fugitive -C error")
end

print("OK: <leader>gh logic runs without fugitive -C error")
os.exit(0)
