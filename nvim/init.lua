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
vim.lsp.enable('nixd')
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format buffer" })
