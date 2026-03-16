return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'mason.nvim',
    'mason-lspconfig.nvim',
  },
}
