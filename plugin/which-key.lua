local wk = require("which-key")

wk.add({
  -- Harpoon
  { "<leader>a", desc = "Harpoon add file" },

  -- Clipboard
  { "<leader>c", group = "Clipboard" },
  { "<leader>cp", desc = "Paste without yanking", mode = "x" },
  { "<leader>cy", desc = "Yank to system clipboard", mode = { "n", "v" } },
  { "<leader>cY", desc = "Yank line to system clipboard" },

  -- Debugger (DAP)
  { "<leader>d", group = "Debugger" },
  { "<leader>dR", desc = "Run to cursor" },
  { "<leader>dE", desc = "Evaluate input" },
  { "<leader>dC", desc = "Conditional breakpoint" },
  { "<leader>dU", desc = "Toggle DAP UI" },
  { "<leader>db", desc = "Step back" },
  { "<leader>dc", desc = "Continue" },
  { "<leader>dd", desc = "Disconnect" },
  { "<leader>de", desc = "Evaluate", mode = { "n", "v" } },
  { "<leader>dg", desc = "Get session" },
  { "<leader>dh", desc = "Hover variables" },
  { "<leader>dS", desc = "Scopes" },
  { "<leader>di", desc = "Step into" },
  { "<leader>do", desc = "Step over" },
  { "<leader>dp", desc = "Pause" },
  { "<leader>dq", desc = "Quit debug" },
  { "<leader>dr", desc = "Toggle REPL" },
  { "<leader>ds", desc = "Start / continue" },
  { "<leader>dt", desc = "Toggle breakpoint" },
  { "<leader>dx", desc = "Terminate" },
  { "<leader>du", desc = "Step out" },

  -- Explorer
  { "<leader>e", desc = "Explorer" },

  -- File / Find
  { "<leader>f", group = "File" },
  { "<leader>ff", desc = "Find files" },
  { "<leader>fc", desc = "Grep string" },
  { "<leader>fn", desc = "Edit nvim config" },
  { "<leader>fs", desc = "Save file" },

  -- Location list
  { "<leader>j", desc = "Previous location" },
  { "<leader>k", desc = "Next location" },

  -- Outline
  { "<leader>o", desc = "Toggle outline" },

  -- Quit
  { "<leader>q", desc = "Quit" },

  -- Search
  { "<leader>s", group = "Search" },
  { "<leader>ss", desc = "Replace word under cursor" },

  -- Tabs
  { "<leader>t", group = "Tabs" },
  { "<leader>tt", desc = "New tab" },
  { "<leader>tn", desc = "Next tab" },
  { "<leader>tp", desc = "Previous tab" },
  { "<leader>tc", desc = "Close tab" },

  -- LSP / Vim With Me
  { "<leader>v", group = "LSP / Vim With Me" },
  { "<leader>vs", desc = "Start Vim With Me" },
  { "<leader>vS", desc = "Stop Vim With Me" },
  { "<leader>vd", desc = "Diagnostic float" },
  { "<leader>vf", desc = "Format buffer", mode = "n" },
  { "<leader>vf", desc = "Format selection", mode = "v" },
  { "<leader>vws", desc = "Workspace symbol" },
  { "<leader>vca", desc = "Code action" },
  { "<leader>vrr", desc = "References" },
  { "<leader>vrn", desc = "Rename" },

  -- Windows
  { "<leader>w", group = "Windows" },
  { "<leader>ws", desc = "Horizontal split" },
  { "<leader>wv", desc = "Vertical split" },

  -- Delete / utilities
  { "<leader>x", desc = "Delete without yanking", mode = { "n", "v" } },
  { "<leader>xx", desc = "Make file executable" },
  { "<leader>xr", desc = "Make it rain" },

  -- Source config
  { "<leader><leader>", desc = "Source config" },

  -- Quickfix / Telescope / Harpoon
  { "<C-k>", desc = "Next quickfix item" },
  { "<C-j>", desc = "Previous quickfix item" },
  { "<C-p>", desc = "Git files" },
  { "<C-e>", desc = "Toggle harpoon menu" },
  { "<C-h>", desc = "Harpoon file 1" },
  { "<C-t>", desc = "Harpoon file 2" },
  { "<C-n>", desc = "Harpoon file 3" },
  { "<C-s>", desc = "Harpoon file 4" },
  { "<C-S-P>", desc = "Harpoon previous file" },
  { "<C-S-N>", desc = "Harpoon next file" },

  -- LSP
  { "gd", desc = "Go to definition" },
  { "gi", desc = "Go to implementation" },
  { "gu", desc = "Incoming calls" },
  { "gr", desc = "References" },
  { "rn", desc = "Rename" },
  { "K", desc = "Hover documentation" },
  { "[d", desc = "Next diagnostic" },
  { "]d", desc = "Previous diagnostic" },
  { "<C-s>", desc = "Signature help", mode = "i" },

  -- Other plugins
  { "J", desc = "Toggle treesj" },
  { "<C-a>", desc = "Increment with dial" },
  { "<C-x>", desc = "Decrement with dial" },
})
