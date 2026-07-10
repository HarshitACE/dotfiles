local M = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")
  local widgets = require("dap.ui.widgets")

  map("n", "<leader>dR", function() dap.run_to_cursor() end, "Run to cursor")
  map("n", "<leader>dE", function()
    dapui.eval(vim.fn.input("[Expression] > "))
  end, "Evaluate input")
  map("n", "<leader>dC", function()
    dap.set_breakpoint(vim.fn.input("[Condition] > "))
  end, "Conditional breakpoint")
  map("n", "<leader>dU", function() dapui.toggle() end, "Toggle DAP UI")
  map("n", "<leader>db", function() dap.step_back() end, "Step back")
  map("n", "<leader>dc", function() dap.continue() end, "Continue")
  map("n", "<leader>dd", function() dap.disconnect() end, "Disconnect")
  map("n", "<leader>de", function() dapui.eval() end, "Evaluate")
  map("v", "<leader>de", function() dapui.eval() end, "Evaluate")
  map("n", "<leader>dg", function() dap.session() end, "Get session")
  map("n", "<leader>dh", function() widgets.hover() end, "Hover variables")
  map("n", "<leader>dS", function() widgets.scopes() end, "Scopes")
  map("n", "<leader>di", function() dap.step_into() end, "Step into")
  map("n", "<leader>do", function() dap.step_over() end, "Step over")
  map("n", "<leader>dp", function() dap.pause.toggle() end, "Pause")
  map("n", "<leader>dq", function() dap.close() end, "Quit debug")
  map("n", "<leader>dr", function() dap.repl.toggle() end, "Toggle REPL")
  map("n", "<leader>ds", function() dap.continue() end, "Start / continue")
  map("n", "<leader>dt", function() dap.toggle_breakpoint() end, "Toggle breakpoint")
  map("n", "<leader>dx", function() dap.terminate() end, "Terminate")
  map("n", "<leader>du", function() dap.step_out() end, "Step out")
end

return M
