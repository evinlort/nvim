local M = {}

local function warn(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.WARN)
  end)
end

local function is_executable(path)
  return path ~= "" and vim.fn.executable(path) == 1
end

local function set_python_host(path)
  if is_executable(path) then
    vim.g.python3_host_prog = path
    return true
  end
  return false
end

local env_host = vim.env.NVIM_PYTHON3_HOST_PROG or vim.env.PYTHON3_HOST_PROG
if env_host and env_host ~= "" then
  if set_python_host(env_host) then
    return M
  end
  warn("NVIM_PYTHON3_HOST_PROG is set but not executable: " .. env_host)
end

local py312 = vim.fn.exepath("python3.12")
if set_python_host(py312) then
  return M
end

local py3 = vim.fn.exepath("python3")
if set_python_host(py3) then
  return M
end

warn("No python3 host found. Set NVIM_PYTHON3_HOST_PROG or g:python3_host_prog.")

return M
