-- Completion
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
  },
})

-- LSP capabilities for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Treesitter (optional, but recommended)
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
})

-- nixd with NixOS options completion via your flake
local flakePath = "/home/rob/dotfiles"

vim.lsp.config('nixd', {
  capabilities = capabilities,
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake "' .. flakePath .. '").nixosConfigurations.thinkpad.options',
        },
      },
    },
  },
})
vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('pyright', {
  capabilities = capabilities,
})

vim.lsp.config('vtsls', {
  capabilities = capabilities,
})

vim.lsp.config('jdtls', {
  capabilities = capabilities,
})

for _, server in ipairs({ 'nixd', 'lua_ls', 'pyright', 'vtsls', 'jdtls' }) do
  vim.lsp.enable(server)
end

local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    lua = { 'stylua' },
    python = { 'black' },
    java = { 'google-java-format' },
  },
})

local lint = require('lint')
lint.linters_by_ft = {
  javascript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  python = { 'ruff' },
}

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
  callback = function()
    lint.try_lint()
  end,
})

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>f', function()
  conform.format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })
