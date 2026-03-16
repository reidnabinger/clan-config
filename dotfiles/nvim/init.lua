-- ============================================================================
-- Neovim Configuration
-- Utilitarian, elegant, and well-designed
-- ============================================================================
--
-- Structure:
--   lua/core/       - Core Neovim settings
--   lua/plugins/    - Plugin specifications
--   lua/lsp/        - LSP server configurations
--
-- Philosophy:
--   - Use native features when possible
--   - Only add plugins that provide significant value
--   - Keep configuration maintainable and well-documented
--   - Optimize for bash/zsh, C, Python, and Nix development
--
-- ============================================================================

-- Ensure faster startup by disabling some built-in providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- ============================================================================
-- Core Configuration
-- ============================================================================

-- Load core settings (must be first)
require('core.options')        -- Editor options and settings
require('core.keymaps')        -- General key mappings
require('core.autocmds')       -- Autocommands and event handlers
require('core.filetypes')      -- Language-specific configurations

-- ============================================================================
-- Plugin Management
-- ============================================================================

-- Bootstrap and configure lazy.nvim
require('core.lazy')

-- Note: Plugins are automatically loaded from lua/plugins/
-- Individual plugin specs:
--   - colorscheme.lua  : Kanagawa theme
--   - telescope.lua    : Fuzzy finder
--   - treesitter.lua   : Syntax highlighting and code understanding
--   - cmp.lua          : Completion engine

-- ============================================================================
-- LSP Configuration
-- ============================================================================

-- Setup LSP (native Neovim LSP client)
-- This must load after plugins (specifically after nvim-cmp)
vim.schedule(function()
  require('lsp')
end)

-- Language servers configured:
--   - bashls   : Bash/shell scripting
--   - clangd   : C/C++ development
--   - pyright  : Python type checking and completion
--   - nil      : Nix language support with flake integration

-- ============================================================================
-- UI Enhancements
-- ============================================================================

-- Setup custom statusline
require('core.statusline').setup()

-- Language-specific features
require('core.filetypes').setup()

-- ============================================================================
-- Welcome Message (optional, comment out if not desired)
-- ============================================================================

-- vim.notify('Neovim configured. Ready to code!', vim.log.levels.INFO)
