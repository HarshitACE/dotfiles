-- Neovim 0.11 resolves server configs from `vim.lsp.config` and starts them via
-- `vim.lsp.enable`. mason-lspconfig v2 enables everything it installed, so this
-- file only registers overrides and must run mason before mason-lspconfig.

-- Neovim 0.11 maps grn/gra/grr/gri/grt by default, which makes `gr` below a
-- pending prefix that waits for 'timeoutlen'.
for _, lhs in ipairs({ 'grn', 'gra', 'grr', 'gri', 'grt' }) do
  pcall(vim.keymap.del, { 'n', 'x' }, lhs)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('batman-lsp-attach', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "gu", function() vim.lsp.buf.incoming_calls() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-s>", function() vim.lsp.buf.signature_help() end, opts)
  end,
})

require('mason').setup({})

-- Advertise nvim-cmp's completion capabilities to every server.
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

local lua_runtime_path = vim.split(package.path, ';')
table.insert(lua_runtime_path, 'lua/?.lua')
table.insert(lua_runtime_path, 'lua/?/init.lua')

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = { version = 'LuaJIT', path = lua_runtime_path },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.stdpath('config') .. '/lua',
        },
      },
    },
  },
})

require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'clangd', 'jsonls', 'yamlls', 'bashls', 'marksman' },
  automatic_enable = {
    -- Needs a Grammarly API key, and errors on every markdown buffer without one.
    exclude = { 'grammarly' },
  },
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})
