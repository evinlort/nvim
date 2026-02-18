local M = {}

local provider = nil

local default_names = { ".venv", "venv", ".env" }

function M.set_provider(new_provider)
  provider = new_provider
end

local function normalize_path(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function ensure_list(names)
  if type(names) == "string" then
    return { names }
  end
  return names
end

local function provider_call(fn)
  if type(fn) == "function" then
    local ok, result = pcall(fn)
    if ok and result and result ~= "" then
      return result
    end
  end
  return nil
end

local function provider_python(source)
  if source then
    return provider_call(source.python)
  end
  return nil
end

local function provider_venv(source)
  if source then
    local path = provider_call(source.venv)
    if path then
      return vim.fs.normalize(path)
    end
  end
  return nil
end

function M.find_venv_path(startpath, names)
  local search_names = ensure_list(names or default_names)
  local start = startpath or vim.fn.getcwd()
  local matches = vim.fs.find(search_names, { upward = true, path = start, type = "directory" })
  for _, dir in ipairs(matches) do
    local venv_dir = normalize_path(dir)
    local python_path = vim.fs.joinpath(venv_dir, "bin", "python")
    if vim.fn.executable(python_path) == 1 then
      return venv_dir
    end
  end
  return nil
end

function M.get_venv_path(startpath, names, opts)
  local source = provider
  if opts and opts.provider then
    source = opts.provider
  end
  local venv_path = provider_venv(source)
  if venv_path then
    return venv_path
  end
  return M.find_venv_path(startpath, names)
end

function M.get_python_path(startpath, names, opts)
  local source = provider
  if opts and opts.provider then
    source = opts.provider
  end
  local python_path = provider_python(source)
  if python_path then
    return python_path
  end

  local venv_dir = M.find_venv_path(startpath, names)
  if venv_dir then
    local venv_python_path = vim.fs.joinpath(venv_dir, "bin", "python")
    if vim.fn.executable(venv_python_path) == 1 then
      return venv_python_path
    end
  end

  return vim.fn.exepath("python3")
end

function M.get_ipython_path(startpath, names)
  local venv_path = M.get_venv_path(startpath, names)
  if venv_path then
    local ipython_path = vim.fs.joinpath(venv_path, "bin", "ipython")
    if vim.fn.executable(ipython_path) == 1 then
      return ipython_path
    end
  end

  local ipython_path = vim.fn.exepath("ipython")
  if ipython_path ~= "" then
    return ipython_path
  end
  return "ipython"
end

function M.get_repl_path(startpath, names)
  local ipython_path = M.get_ipython_path(startpath, names)
  if vim.fn.executable(ipython_path) == 1 then
    return ipython_path
  end
  return vim.fn.exepath("python3")
end

return M
