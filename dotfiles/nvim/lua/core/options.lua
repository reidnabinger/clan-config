-- Core editor options
-- Utilitarian settings focused on productivity without bloat

local opt = vim.opt
local g = vim.g

-- Leader keys (set before plugins load)
g.mapleader = ' '
g.maplocalleader = ' '

-- Line numbers
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Relative line numbers for easy navigation

-- Mouse support
opt.mouse = 'a'                -- Enable mouse in all modes

-- Search behavior
opt.ignorecase = true          -- Case insensitive search
opt.smartcase = true           -- Unless uppercase in search term
opt.hlsearch = true            -- Highlight search results
opt.incsearch = true           -- Incremental search
opt.inccommand = 'split'       -- Preview substitutions in split window

-- Line wrapping
opt.wrap = false               -- Don't wrap lines by default
opt.breakindent = true         -- Preserve indentation in wrapped text
opt.linebreak = true           -- Wrap at word boundaries

-- Indentation
opt.tabstop = 2                -- Tab display width
opt.shiftwidth = 2             -- Indent width
opt.expandtab = true           -- Use spaces instead of tabs
opt.autoindent = true          -- Copy indent from current line
opt.smartindent = true         -- Smart autoindenting on new lines

-- Visual enhancements
opt.termguicolors = true       -- True color support
opt.signcolumn = 'yes'         -- Always show sign column (prevents shift)
opt.cursorline = true          -- Highlight current line
opt.colorcolumn = '80,120'     -- Visual guides at 80 and 120 columns

-- Scrolling behavior
opt.scrolloff = 8              -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8          -- Keep 8 columns left/right of cursor

-- System integration
opt.clipboard = 'unnamedplus'  -- Use system clipboard
opt.undofile = true            -- Persistent undo across sessions
opt.undolevels = 10000         -- More undo history
opt.backup = false             -- No backup files (use git)
opt.swapfile = false           -- No swap files (modern systems are stable)

-- Timing
opt.updatetime = 250           -- Faster completion and swap writes
opt.timeoutlen = 300           -- Faster key sequence completion

-- Split behavior
opt.splitright = true          -- Vertical splits go right
opt.splitbelow = true          -- Horizontal splits go below
opt.equalalways = false        -- Don't auto-resize splits

-- Whitespace visualization
opt.list = true
opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
  extends = '›',
  precedes = '‹',
}

-- Command line
opt.wildmode = 'longest:full,full'  -- Command completion behavior
opt.wildignore = {
  '*.o', '*.obj', '*.pyc', '__pycache__',
  '*~', '*.swp', '*.tmp',
  '.git', '.hg', '.svn',
  'node_modules', '.DS_Store',
}

-- Better diffing
opt.diffopt:append('vertical')      -- Vertical diff splits
opt.diffopt:append('algorithm:patience')  -- Better diff algorithm
opt.diffopt:append('indent-heuristic')

-- Spell checking (off by default, toggle with autocmd)
opt.spelllang = 'en_us'
opt.spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'

-- Completion behavior
opt.completeopt = 'menu,menuone,noselect'  -- Better completion experience
opt.pumheight = 15             -- Max items in popup menu

-- Better grep
if vim.fn.executable('rg') == 1 then
  opt.grepprg = 'rg --vimgrep --smart-case --no-heading'
  opt.grepformat = '%f:%l:%c:%m'
end

-- Performance
opt.lazyredraw = false         -- Don't redraw during macros (default changed in 0.10)
opt.synmaxcol = 300            -- Don't syntax highlight super long lines

-- Folding (using treesitter when available)
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldlevel = 99             -- Start with all folds open
opt.foldlevelstart = 99
opt.foldenable = true

-- Better formatting
opt.formatoptions:remove({ 'c', 'r', 'o' })  -- Don't auto-continue comments
opt.formatoptions:append('n')  -- Recognize numbered lists
