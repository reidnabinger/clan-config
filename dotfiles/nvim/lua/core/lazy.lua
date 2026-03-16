-- lazy.nvim bootstrap and configuration
-- Minimal plugin manager setup

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with utilitarian defaults
require('lazy').setup({
  -- Import all plugin specs from lua/plugins/
  spec = {
    { import = 'plugins' },
  },

  -- UI configuration
  ui = {
    border = 'rounded',
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },

  -- Performance settings
  performance = {
    rtp = {
      -- Disable some rtp plugins we don't need
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',  -- We'll use treesitter for this
        'netrwPlugin', -- Keep netrw for file browsing
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },

  -- Development settings
  dev = {
    path = '~/projects',  -- Local plugin development path
  },

  -- Check for updates but don't notify
  checker = {
    enabled = true,
    notify = false,
  },

  -- Install missing plugins on startup
  install = {
    missing = true,
    colorscheme = { 'habamax' },  -- Fallback colorscheme
  },

  -- Don't auto-reload when config changes (manual control)
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- Keymaps for lazy.nvim
vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { desc = 'Open Lazy plugin manager' })
vim.keymap.set('n', '<leader>lu', ':Lazy update<CR>', { desc = 'Update plugins' })
vim.keymap.set('n', '<leader>ls', ':Lazy sync<CR>', { desc = 'Sync plugins' })
vim.keymap.set('n', '<leader>lc', ':Lazy clean<CR>', { desc = 'Clean unused plugins' })
