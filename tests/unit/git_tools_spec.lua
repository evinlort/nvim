local git_tools = require("plugins.git-tools")
local subject = git_tools._test

local original_cmd = vim.cmd
local original_notify = vim.notify

local function run_git(args)
  vim.fn.system(args)
  assert.are.equal(0, vim.v.shell_error, "git command failed: " .. table.concat(args, " "))
end

local function make_repo()
  local repo = vim.fn.tempname()
  vim.fn.mkdir(repo, "p")
  vim.fn.mkdir(repo .. "/src", "p")
  vim.fn.writefile({ "line one", "line two" }, repo .. "/src/file.lua")

  run_git({ "git", "-C", repo, "init" })
  run_git({ "git", "-C", repo, "config", "user.name", "Test User" })
  run_git({ "git", "-C", repo, "config", "user.email", "test@example.com" })
  run_git({ "git", "-C", repo, "add", "src/file.lua" })
  run_git({ "git", "-C", repo, "commit", "-m", "init" })

  return repo, repo .. "/src/file.lua"
end

describe("plugins.git-tools", function()
  local cwd

  before_each(function()
    cwd = vim.fn.getcwd()
  end)

  after_each(function()
    vim.cmd = original_cmd
    vim.notify = original_notify
    original_cmd("silent! %bwipeout!")
    original_cmd("cd " .. vim.fn.fnameescape(cwd))
  end)

  it("builds line-history Fugitive command without -C", function()
    local repo, file = make_repo()
    original_cmd("cd " .. vim.fn.fnameescape(repo))
    original_cmd("edit " .. vim.fn.fnameescape(file))

    local commands = {}
    vim.cmd = function(command)
      table.insert(commands, command)
    end

    subject.gh_line_or_file_history(1, 1)

    assert.are.equal(1, #commands)
    assert.is_truthy(commands[1]:find("^Git log %-L 1,1:", 1))
    assert.is_nil(commands[1]:find("Git %-C ", 1))
  end)

  it("falls back to file history without -C when line history fails", function()
    local repo, file = make_repo()
    original_cmd("cd " .. vim.fn.fnameescape(repo))
    original_cmd("edit " .. vim.fn.fnameescape(file))

    local commands = {}
    vim.cmd = function(command)
      table.insert(commands, command)
      if command:find("^Git log %-L", 1) then
        error("simulated line-history failure")
      end
    end

    subject.gh_line_or_file_history(1, 1)

    assert.are.equal(2, #commands)
    assert.is_truthy(commands[2]:find("^Git log %-%-follow %-p %-%- ", 1))
    assert.is_nil(commands[2]:find("Git %-C ", 1))
  end)

  it("notifies and exits outside git repositories", function()
    local temp_dir = vim.fn.tempname()
    vim.fn.mkdir(temp_dir, "p")
    original_cmd("cd " .. vim.fn.fnameescape(temp_dir))

    local notified = {}
    vim.notify = function(message, level)
      table.insert(notified, { message = message, level = level })
    end
    vim.cmd = function()
      error("vim.cmd must not be called when outside a git repo")
    end

    subject.gh_line_or_file_history(1, 1)

    assert.are.equal(1, #notified)
    assert.are.equal("Not inside a git repository", notified[1].message)
  end)
end)
