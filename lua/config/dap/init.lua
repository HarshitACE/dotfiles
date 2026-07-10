local M = {}

-- python venv finding
local venv_names = {"venv", ".venv"}
local function find_python_in_dir(dir)
  for _, name in ipairs(venv_names) do
    local python = dir .. "/" .. name .. "/bin/python"
    if vim.fn.executable(python) == 1 then
      return python
    end
  end
end

local function find_python_upwards(start_dir)
  local dir = start_dir
  while dir and dir ~= "" and dir ~= "/" do
    local python = find_python_in_dir(dir)
    if python then
      return python
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
end

local function resolve_python()
  local virtual_env = os.getenv("VIRTUAL_ENV")
  if virtual_env and virtual_env ~= "" then
    local python = virtual_env .. "/bin/python"
    if vim.fn.executable(python) == 1 then
      return python
    end
  end
  local from_file = find_python_upwards(vim.fn.expand("%:p:h"))
  if from_file then
    return from_file
  end
  local from_cwd = find_python_upwards(vim.fn.getcwd())
  if from_cwd then
    return from_cwd
  end
  return "/usr/bin/python"
end

function M.setup()
  if M._setup then
    return
  end
  M._setup = true

  local mason_dap = require("mason-nvim-dap")
  local dap = require("dap")
  local ui = require("dapui")
  local dap_virtual_text = require("nvim-dap-virtual-text")

  dap_virtual_text.setup()

  mason_dap.setup({
    ensure_installed = { "cppdbg", "python" },
    automatic_installation = true,
    handlers = {
      function(config)
        require("mason-nvim-dap").default_setup(config)
      end,
    },
  })

  dap.configurations = {
    c = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        MIMode = "lldb",
      },
      {
        name = "Attach to lldbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "lldb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/lldb",
        cwd = "${workspaceFolder}",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
      },
    },
    python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = resolve_python,
      },
    },
  }

  ui.setup()

  vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

  dap.listeners.before.attach.dapui_config = function()
    ui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    ui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
  end

  require("config.dap.keymaps").setup()
end

return M
