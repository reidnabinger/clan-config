-- Autocommands
-- Event-driven configurations for enhanced editing experience

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General autocommand group
local general = augroup('General', { clear = true })

-- ============================================================================
-- Visual Feedback
-- ============================================================================

-- Highlight yanked text briefly
autocmd('TextYankPost', {
  group = general,
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

-- ============================================================================
-- File Type Specific Settings
-- ============================================================================

local filetype = augroup('FileTypeSettings', { clear = true })

-- Enable spell checking for text files
autocmd('FileType', {
  group = filetype,
  pattern = { 'gitcommit', 'markdown', 'text', 'tex' },
  desc = 'Enable spell check for text files',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

-- Auto-format shell scripts on save
autocmd('FileType', {
  group = filetype,
  pattern = { 'sh', 'bash', 'zsh' },
  desc = 'Shell script settings',
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- C/C++ specific settings
autocmd('FileType', {
  group = filetype,
  pattern = { 'c', 'cpp', 'h', 'hpp' },
  desc = 'C/C++ settings',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = '// %s'
  end,
})

-- Python specific settings
autocmd('FileType', {
  group = filetype,
  pattern = 'python',
  desc = 'Python settings (PEP 8)',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.colorcolumn = '88,120'  -- Black formatter default
    vim.opt_local.textwidth = 88
  end,
})

-- Help files: Navigate with <CR> and <BS>
autocmd('FileType', {
  group = filetype,
  pattern = 'help',
  desc = 'Help file navigation',
  callback = function()
    vim.keymap.set('n', '<CR>', '<C-]>', { buffer = true, desc = 'Follow link' })
    vim.keymap.set('n', '<BS>', '<C-T>', { buffer = true, desc = 'Go back' })
  end,
})

-- Man pages: Close with q
autocmd('FileType', {
  group = filetype,
  pattern = { 'man', 'help' },
  desc = 'Quick quit for help/man pages',
  callback = function()
    vim.keymap.set('n', 'q', ':quit<CR>', { buffer = true, silent = true })
  end,
})

-- ============================================================================
-- Buffer Management
-- ============================================================================

local buffer = augroup('BufferManagement', { clear = true })

-- Restore cursor position when opening files
autocmd('BufReadPost', {
  group = buffer,
  desc = 'Restore cursor position',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create missing directories on save
autocmd('BufWritePre', {
  group = buffer,
  desc = 'Auto-create missing directories',
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return  -- Skip for special buffers (oil://, fugitive://, etc.)
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Remove trailing whitespace on save
autocmd('BufWritePre', {
  group = buffer,
  desc = 'Remove trailing whitespace',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- ============================================================================
-- Window and UI Management
-- ============================================================================

local ui = augroup('UIManagement', { clear = true })

-- Automatically equalize splits on resize
autocmd('VimResized', {
  group = ui,
  desc = 'Equalize splits on resize',
  callback = function()
    vim.cmd('wincmd =')
  end,
})

-- Disable line numbers in terminal buffers
autocmd('TermOpen', {
  group = ui,
  desc = 'Terminal settings',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.cmd('startinsert')  -- Start in insert mode
  end,
})

-- Close certain filetypes with 'q'
autocmd('FileType', {
  group = ui,
  pattern = {
    'qf',          -- Quickfix
    'help',
    'man',
    'lspinfo',
    'checkhealth',
  },
  desc = 'Close with q',
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- ============================================================================
-- Auto-compile and Linting
-- ============================================================================

local compile = augroup('AutoCompile', { clear = true })

-- Check for external file changes
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = compile,
  desc = 'Check if buffer changed on disk',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
})

-- Reload file if changed externally
autocmd('FileChangedShellPost', {
  group = compile,
  desc = 'Notify when file changed on disk',
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.WARN)
  end,
})

-- ============================================================================
-- Performance Optimizations
-- ============================================================================

local performance = augroup('Performance', { clear = true })

-- Disable some features for large files (>1MB)
autocmd('BufReadPre', {
  group = performance,
  desc = 'Optimize for large files',
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 1024000 then
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.syntax = 'off'
      vim.notify('Large file detected. Some features disabled.', vim.log.levels.INFO)
    end
  end,
})
