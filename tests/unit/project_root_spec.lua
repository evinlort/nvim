local subject = require("core.project_root")

local original_cmd = vim.cmd
local original_notify = vim.notify

local function run_git(args)
  vim.fn.system(args)
  assert.are.equal(0, vim.v.shell_error, "git command failed: " .. table.concat(args, " "))
end

local function make_repo(name)
  local repo = vim.fn.tempname() .. "-" .. name
  vim.fn.mkdir(repo .. "/src", "p")
  vim.fn.writefile({ "line one" }, repo .. "/src/file.lua")
  run_git({ "git", "-C", repo, "init" })
  return repo, repo .. "/src/file.lua"
end

describe("core.project_root", function()
  local cwd

  before_each(function()
    cwd = vim.fn.getcwd()
    vim.t.active_project_root = nil
    vim.notify = function() end
  end)

  after_each(function()
    vim.cmd = original_cmd
    vim.notify = original_notify
    vim.t.active_project_root = nil
    original_cmd("silent! %bwipeout!")
    original_cmd("tcd " .. vim.fn.fnameescape(cwd))
  end)

  it("resolves a selected file or directory to the nearest git root", function()
    local repo, file = make_repo("project-root")

    assert.are.equal(repo, subject.resolve_from_path(repo .. "/src"))
    assert.are.equal(repo, subject.resolve_from_path(file))
  end)

  it("falls back to the selected directory outside git", function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, "p")

    assert.are.equal(dir, subject.resolve_from_path(dir))
  end)

  it("stores active project root tab-locally and uses tcd", function()
    local repo = make_repo("active")

    local root = subject.set_active(repo, { update_tree = false })

    assert.are.equal(repo, root)
    assert.are.equal(repo, vim.t.active_project_root)
    assert.are.equal(repo, vim.fn.getcwd(-1, 0))
    assert.are_not.equal(repo, vim.fn.getcwd(-1, -1))
  end)

  it("prefers explicit active root over current file git root for LazyGit", function()
    local repo1, file1 = make_repo("file")
    local repo2 = make_repo("active")
    original_cmd("edit " .. vim.fn.fnameescape(file1))

    subject.set_active(repo2, { update_tree = false })

    assert.are.equal(repo2, subject.resolve_for_lazygit())
    assert.are_not.equal(repo1, subject.resolve_for_lazygit())
  end)

  it("uses the current file git root when no active root is set", function()
    local repo, file = make_repo("current-file")
    original_cmd("edit " .. vim.fn.fnameescape(file))

    assert.are.equal(repo, subject.resolve_for_lazygit())
  end)

  it("falls back to current tab cwd when no active root or file git root exists", function()
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, "p")
    original_cmd("enew")
    original_cmd("tcd " .. vim.fn.fnameescape(dir))

    assert.are.equal(dir, subject.resolve_for_lazygit())
  end)
end)
