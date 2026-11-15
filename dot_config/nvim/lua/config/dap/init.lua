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

local function prompt_program(subdir)
  return function()
    local default = vim.fn.getcwd() .. "/" .. (subdir or "")
    return vim.fn.input("Path to executable: ", default, "file")
  end
end

local function prompt_args()
  return vim.split(vim.fn.input("Args: "), " +", { trimempty = true })
end

local function python_configurations()
  return {
    {
      type = "python",
      request = "launch",
      name = "Python: Launch file",
      program = "${file}",
      pythonPath = resolve_python,
      console = "integratedTerminal",
    },
    {
      type = "python",
      request = "launch",
      name = "Python: Launch file (args)",
      program = "${file}",
      args = prompt_args,
      pythonPath = resolve_python,
      console = "integratedTerminal",
    },
    {
      type = "python",
      request = "launch",
      name = "Python: Launch module",
      module = function()
        return vim.fn.input("Module: ")
      end,
      pythonPath = resolve_python,
      console = "integratedTerminal",
    },
    {
      type = "python",
      request = "attach",
      name = "Python: Attach to debugpy :5678",
      connect = { host = "127.0.0.1", port = 5678 },
    },
  }
end

local function native_configurations()
  return {
    {
      name = "LLDB (MI): Launch file",
      type = "cppdbg",
      request = "launch",
      program = prompt_program(),
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      MIMode = "lldb",
    },
    {
      name = "LLDB (MI): Attach to lldbserver :1234",
      type = "cppdbg",
      request = "launch",
      MIMode = "lldb",
      miDebuggerServerAddress = "localhost:1234",
      miDebuggerPath = "/usr/bin/lldb",
      cwd = "${workspaceFolder}",
      program = prompt_program(),
    },
  }
end

local function rust_configurations()
  return {
    {
      name = "Rust: Debug cargo binary",
      type = "codelldb",
      request = "launch",
      program = prompt_program("target/debug/"),
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      console = "integratedTerminal",
    },
    {
      name = "Rust: Debug cargo binary (args)",
      type = "codelldb",
      request = "launch",
      program = prompt_program("target/debug/"),
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = prompt_args,
      console = "integratedTerminal",
    },
  }
end

-- mason-nvim-dap ships no mapping for the `js` source, so vscode-js-debug gets
-- an installed binary but no adapter and no configurations. Register both here.
local js_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "svelte",
}

local function setup_js_adapters(dap)
  local command = vim.fn.exepath("js-debug-adapter")
  if command == "" then
    return false
  end

  for _, name in ipairs({ "pwa-node", "pwa-chrome", "node-terminal" }) do
    dap.adapters[name] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = { command = command, args = { "${port}" } },
    }
  end

  -- launch.json files in the wild use the short names for the same adapters.
  dap.adapters.node = dap.adapters["pwa-node"]
  dap.adapters.chrome = dap.adapters["pwa-chrome"]

  return true
end

local function js_configurations()
  local skip_files = { "<node_internals>/**", "**/node_modules/**" }

  return {
    {
      type = "pwa-node",
      request = "launch",
      name = "Node: Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = skip_files,
    },
    -- Node cannot run TypeScript on its own, so go through tsx for those files.
    {
      type = "pwa-node",
      request = "launch",
      name = "Node: Launch file via tsx",
      runtimeExecutable = "npx",
      runtimeArgs = { "tsx" },
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = skip_files,
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Node: Run npm script",
      runtimeExecutable = "npm",
      runtimeArgs = function()
        return { "run", vim.fn.input("npm script: ", "dev") }
      end,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = skip_files,
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Node: Attach to process",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = skip_files,
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Chrome: Launch against dev server",
      url = function()
        return vim.fn.input("URL: ", "http://localhost:5173")
      end,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
  }
end

-- Assigning dap.configurations wholesale throws away everything
-- mason-nvim-dap registered for the installed adapters, so append instead.
local function extend_configurations(dap, by_filetype)
  for filetype, configurations in pairs(by_filetype) do
    dap.configurations[filetype] =
      vim.list_extend(dap.configurations[filetype] or {}, configurations)
  end
end

local function define_signs()
  vim.fn.sign_define("DapBreakpoint", { text = "🐞", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "🔶", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "DiagnosticSignHint" })
  vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DiagnosticSignInfo", linehl = "Visual" })
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
    ensure_installed = { "cppdbg", "codelldb", "python", "coreclr", "delve", "js" },
    automatic_installation = true,
    handlers = {
      function(config)
        mason_dap.default_setup(config)
      end,
      -- The bundled python config resolves the interpreter once, at startup.
      -- These re-resolve per session so per-project venvs are picked up.
      python = function(config)
        config.configurations = python_configurations()
        mason_dap.default_setup(config)
      end,
      delve = function(config)
        config.adapters = {
          type = "server",
          port = "${port}",
          executable = {
            command = vim.fn.exepath("dlv"),
            -- Mason ships a dlv built against a newer Go than the local
            -- toolchain, and it refuses to start on that mismatch.
            args = { "dap", "-l", "127.0.0.1:${port}", "--check-go-version=false" },
          },
        }
        mason_dap.default_setup(config)
      end,
    },
  })

  local by_filetype = {
    c = native_configurations(),
    cpp = native_configurations(),
    rust = rust_configurations(),
  }

  if setup_js_adapters(dap) then
    for _, filetype in ipairs(js_filetypes) do
      by_filetype[filetype] = js_configurations()
    end

    -- nvim-dap reads .vscode/launch.json on demand and maps entries by `type`,
    -- which needs to know about the adapters mason-nvim-dap does not cover.
    local vscode = require("dap.ext.vscode")
    vscode.type_to_filetypes = vim.tbl_extend("keep", vscode.type_to_filetypes, {
      ["pwa-node"] = js_filetypes,
      ["pwa-chrome"] = js_filetypes,
      ["node-terminal"] = js_filetypes,
      node = js_filetypes,
      chrome = js_filetypes,
    })
  end

  extend_configurations(dap, by_filetype)

  ui.setup({
    controls = { enabled = true, element = "repl" },
    floating = { border = "rounded" },
    layouts = {
      {
        position = "left",
        size = 40,
        elements = {
          { id = "scopes", size = 0.4 },
          { id = "watches", size = 0.2 },
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.15 },
        },
      },
      {
        position = "bottom",
        size = 10,
        elements = {
          { id = "repl", size = 0.6 },
          { id = "console", size = 0.4 },
        },
      },
    },
  })

  define_signs()

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
