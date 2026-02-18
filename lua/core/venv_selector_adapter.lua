local python_env = require("core.python_env")

python_env.set_provider({
  python = function()
    local selector = package.loaded["venv-selector"]
    if selector and type(selector.python) == "function" then
      return selector.python()
    end
    return nil
  end,
  venv = function()
    local selector = package.loaded["venv-selector"]
    if selector and type(selector.venv) == "function" then
      return selector.venv()
    end
    return nil
  end,
})
