-- Core key mappings
-- Utilitarian keybinds focused on efficiency

local keymap = vim.keymap.set
local opts = { silent = true }

-- ============================================================================
-- Normal Mode
-- ============================================================================

-- File operations
keymap('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
keymap('n', '<leader>q', ':q<CR>', { desc = 'Quit' })
keymap('n', '<leader>x', ':x<CR>', { desc = 'Save and quit' })
keymap('n', '<leader>Q', ':qa!<CR>', { desc = 'Quit all without saving' })

-- Search and replace
keymap('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlight' })
keymap('n', '<leader>s', ':%s/<C-r><C-w>/', { desc = 'Substitute word under cursor' })

-- Window navigation (Ctrl+hjkl)
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to below split' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to above split' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

-- Window management
keymap('n', '<leader>|', ':vsplit<CR>', { desc = 'Vertical split' })
keymap('n', '<leader>-', ':split<CR>', { desc = 'Horizontal split' })
keymap('n', '<leader>=', '<C-w>=', { desc = 'Equalize split sizes' })

-- Resize windows with arrow keys
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Buffer navigation
keymap('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
keymap('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })
keymap('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
keymap('n', '<leader>bl', ':buffers<CR>', { desc = 'List buffers' })

-- Tab navigation
keymap('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
keymap('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close tab' })
keymap('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })
keymap('n', 'gt', ':tabnext<CR>', { desc = 'Next tab' })
keymap('n', 'gT', ':tabprevious<CR>', { desc = 'Previous tab' })

-- Better navigation
keymap('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
keymap('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
keymap('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
keymap('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- Join lines keeping cursor position
keymap('n', 'J', 'mzJ`z', { desc = 'Join lines keeping cursor position' })

-- Better line navigation in wrapped text
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Move down (wrapped)' })
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Move up (wrapped)' })

-- File explorer (Oil.nvim - configured in plugins/oil.lua)
-- <leader>e - Open parent directory
-- <leader>E - Open parent directory (float)
-- -         - Open parent directory (quick access)

-- Quick access to config
keymap('n', '<leader>v', ':edit $MYVIMRC<CR>', { desc = 'Edit init.lua' })
keymap('n', '<leader>V', ':source $MYVIMRC<CR>', { desc = 'Reload config' })

-- ============================================================================
-- Visual Mode
-- ============================================================================

-- Indenting (keeps selection)
keymap('v', '<', '<gv', { desc = 'Indent left and reselect' })
keymap('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Move selected lines up/down
keymap('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Paste without overwriting register
keymap('v', 'p', '"_dP', { desc = 'Paste without yanking replaced text' })

-- Search for selected text
keymap('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { desc = 'Search for selection' })

-- ============================================================================
-- Insert Mode
-- ============================================================================

-- Exit insert mode easily
keymap('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
keymap('i', 'kj', '<Esc>', { desc = 'Exit insert mode' })

-- Better undo breakpoints
keymap('i', ',', ',<C-g>u', opts)
keymap('i', '.', '.<C-g>u', opts)
keymap('i', '!', '!<C-g>u', opts)
keymap('i', '?', '?<C-g>u', opts)

-- ============================================================================
-- Command Mode
-- ============================================================================

-- Navigate command history
keymap('c', '<C-j>', '<Down>', { desc = 'Next command' })
keymap('c', '<C-k>', '<Up>', { desc = 'Previous command' })

-- ============================================================================
-- Terminal Mode
-- ============================================================================

-- Easy escape from terminal
keymap('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
keymap('t', 'jk', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left split from terminal' })
keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to below split from terminal' })
keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to above split from terminal' })
keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right split from terminal' })

-- ============================================================================
-- Operator-pending Mode
-- ============================================================================

-- Inside/around next/last parentheses
keymap('o', 'in(', ':<C-u>normal! f(vi(<CR>', { desc = 'Inside next ()' })
keymap('o', 'il(', ':<C-u>normal! F)vi(<CR>', { desc = 'Inside last ()' })
keymap('o', 'in{', ':<C-u>normal! f{vi{<CR>', { desc = 'Inside next {}' })
keymap('o', 'il{', ':<C-u>normal! F}vi{<CR>', { desc = 'Inside last {}' })

-- ============================================================================
-- Mason LSP Package Manager
-- ============================================================================

keymap('n', '<leader>m', ':Mason<CR>', { desc = 'Open Mason' })
keymap('n', '<leader>mi', ':MasonInstall ', { desc = 'Mason install package' })
keymap('n', '<leader>mu', ':MasonUpdate<CR>', { desc = 'Mason update' })

-- ============================================================================
-- Plugin Keymaps (to be defined when plugins load)
-- ============================================================================
-- These will be set in individual plugin configs:
-- - Telescope: <leader>ff, <leader>fg, <leader>fb, etc.
-- - LSP: gd, gr, K, <leader>ca, etc. (set in lsp/init.lua)
-- - Completion: <C-n>, <C-p>, <CR> (set in plugins/cmp.lua)
