local M = {}

function M.setup()
  -- local dap_install = require "dap-install"
  -- dap_install.config("codelldb", {})

  local dap = require("dap")
  local install_root_dir = vim.fn.stdpath("data") .. "/mason"
  local extension_path = install_root_dir .. "/packages/codelldb/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = codelldb_path,
      args = { "--port", "${port}" },

      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      args = function()
        local inputArgs = vim.fn.input("Arguments: ")
        if inputArgs == "" then
          return {}
        end
        -- Split the input string into individual arguments
        local argsArray = {}
        for word in string.gmatch(inputArgs, "%S+") do
          table.insert(argsArray, word)
        end
        return argsArray
      end,
      cwd = function()
        return vim.fn.input("Current Working Directory: ", vim.fn.getcwd().. "/", "file")
    end,
      stopOnEntry = true,
    },
  }

  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp
end

return M
