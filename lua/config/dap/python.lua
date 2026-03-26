local M = {}

function M.setup()
  local dap = require("dap")

  -- Detect the Python interpreter to use
  local function get_python_path()
    local cwd = vim.fn.getcwd()
    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
      return cwd .. "/venv/bin/python"
    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
      return cwd .. "/.venv/bin/python"
    elseif vim.fn.executable(cwd .. "/env/bin/python") == 1 then
      return cwd .. "/env/bin/python"
    else
      -- fallback to system python3
      return vim.fn.exepath("python3") or "/usr/bin/python3"
    end
  end

  dap.adapters.python = {
    type = "executable",
    command = get_python_path(),
    args = { "-m", "debugpy.adapter" },
  }

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = get_python_path,
    },
    {
      type = "python",
      request = "launch",
      name = "Launch file with args",
      program = "${file}",
      pythonPath = get_python_path,
      args = function()
        local input = vim.fn.input("Args: ")
        return vim.fn.split(input, " ", true)
      end,
    },
    {
      type = "python",
      request = "launch",
      name = "Debug pytest with args",
      module = "pytest",  -- run pytest as a module
      args = function()
        local input = vim.fn.input("Pytest args: ")
        return vim.fn.split(input, " ", true)
      end,
      pythonPath = get_python_path,
    },
  }

  --  dap.configurations = {
  --    python = {
  --      {
  --        -- The first three options are required by nvim-dap
  --        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
  --        request = "launch",
  --        name = "Launch file",

  --        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

  --        program = "${file}", -- This configuration will launch the current file if used.
  --        pythonPath = get_python_path
  --      },
  --    },
  --  }
end

return M
