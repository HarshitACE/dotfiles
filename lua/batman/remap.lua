vim.g.mapleader = " "

-- Explorer
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- File
vim.keymap.set("n", "<leader>fs", vim.cmd.w)
vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format)

-- Quit
vim.keymap.set("n", "<leader>q", vim.cmd.q)

-- Modes
vim.keymap.set("i", "jk", "<Esc>")

-- Tabs
vim.keymap.set("n", "<leader>tt", vim.cmd.tabnew)
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnext)
vim.keymap.set("n", "<leader>tp", vim.cmd.tabprevious)
vim.keymap.set("n", "<leader>tc", vim.cmd.tabclose)

-- Windows
vim.keymap.set("n", "<leader>ws", vim.cmd.split)
vim.keymap.set("n", "<leader>wv", vim.cmd.vsplit)

-- Vim With Me
vim.keymap.set("n", "<leader>vs", function()
    require("vim-with-me").StartVimWithMe()
end)

vim.keymap.set("n", "<leader>vS", function()
    require("vim-with-me").StopVimWithMe()
end)

-- Clipboard
vim.keymap.set("x", "<leader>cp", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>cy", [["+y]])
vim.keymap.set("n", "<leader>cY", [["+Y]])

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>x", [["_d]])

-- Quickfix
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Location list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Search
vim.keymap.set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Utilities
vim.keymap.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>xr", "<cmd>CellularAutomaton make_it_rain<CR>")

-- Source config
vim.keymap.set("n", "<leader><leader>", "<cmd>source<CR>")

-- Dotfiles
vim.keymap.set(
    "n",
    "<leader>fn",
    "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>"
)
