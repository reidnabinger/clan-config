# Mason LSP Auto-Installation Setup

## Overview

Your Neovim configuration now includes **mason.nvim** for automatic LSP server management. This eliminates the need to manually install language servers - they install automatically when you open supported files.

## What Changed

### New Plugins Added
- **mason.nvim** - Package manager for LSP servers, DAP, linters, formatters
- **mason-lspconfig.nvim** - Bridge between mason and nvim-lspconfig
- **nvim-lspconfig** - LSP configuration framework (now optional with Neovim 0.11+)

### Files Modified
- `lua/plugins/mason.lua` - Mason configuration
- `lua/plugins/mason-lspconfig.lua` - Auto-install configuration
- `lua/plugins/lspconfig.lua` - Plugin loader
- `lua/lsp/init.lua` - Removed manual server loading
- `lua/lsp/servers/*.lua` - Converted to settings-only modules
- `lua/core/keymaps.lua` - Added Mason UI keybindings

## Configured LSP Servers

The following servers will auto-install on first use:

| Server | Language | Special Features |
|--------|----------|------------------|
| **bashls** | Bash/Shell/Zsh | Shellcheck integration |
| **clangd** | C/C++ | Source/header switching, clang-tidy, IWYU |
| **pyright** | Python | Type checking, organize imports |
| **nil_ls** | Nix | Flake support, nixpkgs-fmt integration |

## Keybindings

### Mason UI
- `<leader>m` - Open Mason UI
- `<leader>mi` - Mason install package (opens prompt)
- `<leader>mu` - Update Mason registry

### Mason UI Navigation (when :Mason is open)
- `i` - Install package under cursor
- `u` - Update package under cursor
- `U` - Update all packages
- `X` - Uninstall package
- `c` - Check package version
- `C` - Check for outdated packages
- `<CR>` - Toggle package details
- `g?` - Show help

### LSP (unchanged)
All your existing LSP keybindings still work:
- `gd` - Go to definition
- `gr` - Show references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format buffer
- `[d` / `]d` - Previous/next diagnostic

### Language-Specific (preserved)
- **C/C++**: `<leader>cs` - Switch between source and header
- **Python**: `<leader>ci` - Organize imports
- **Nix**: `<leader>nf` - Format with nixpkgs-fmt
- **Nix**: `<leader>ne` - Evaluate Nix expression

## How It Works

### First Launch
1. Open Neovim
2. Mason automatically installs configured servers in the background
3. Servers become available immediately after installation

### When Opening Files
1. Open a Python file (`*.py`) → pyright auto-installs if not present
2. Open a C file (`*.c`) → clangd auto-installs if not present
3. LSP features activate automatically once server is ready

### Manual Installation
If you want to install a server before using it:
```vim
:Mason              " Open UI, press 'i' on a package
:MasonInstall pyright    " Install specific package
:MasonUpdate             " Update registry
```

## Adding More LSP Servers

Edit `lua/plugins/mason-lspconfig.lua`:

```lua
require('mason-lspconfig').setup({
  ensure_installed = {
    'bashls',
    'clangd',
    'pyright',
    'nil_ls',
    -- Add more here:
    'rust_analyzer',  -- Rust
    'ts_ls',          -- TypeScript/JavaScript  
    'gopls',          -- Go
    'lua_ls',         -- Lua
  },
})
```

Then add configuration for the new server in the same file using `vim.lsp.config()`.

## Available Servers

Check available LSP servers in Mason:
```vim
:Mason
" Then press '/' to search
" Or browse by category with <C-f>
```

Common servers:
- **rust_analyzer** - Rust
- **ts_ls** - TypeScript/JavaScript
- **gopls** - Go
- **lua_ls** - Lua
- **yamlls** - YAML
- **jsonls** - JSON
- **html** - HTML
- **cssls** - CSS

## Troubleshooting

### LSP Not Starting
1. Check if server is installed: `:Mason`
2. Check LSP status: `:LspInfo`
3. Check logs: `:MasonLog`
4. Verify configuration: `:checkhealth mason`

### Server Installation Failed
1. Open Mason UI: `:Mason`
2. Find the package and press `X` to uninstall
3. Press `i` to reinstall
4. Check `:MasonLog` for errors

### Update All Servers
```vim
:Mason
" Press 'U' (capital U) to update all
```

## Technical Details

### Modern Neovim 0.11+ API
This setup uses the modern `vim.lsp.config()` API instead of the deprecated `require('lspconfig')` pattern.

**Old way (deprecated):**
```lua
require('lspconfig').pyright.setup({...})
```

**New way (Neovim 0.11+):**
```lua
vim.lsp.config('pyright', {...})
```

### Automatic Installation
Mason automatically installs servers defined in `ensure_installed` when you launch Neovim. You can also set `automatic_installation = true` to install any server when you open a file of that type (even if not in `ensure_installed`).

### PATH Integration
Mason prepends its bin directory to PATH, so installed tools are available system-wide within Neovim. This happens automatically when mason.nvim loads (which is why it must NOT be lazy-loaded).

## Resources

- [Mason.nvim GitHub](https://github.com/williamboman/mason.nvim)
- [Mason-LSPConfig GitHub](https://github.com/williamboman/mason-lspconfig.nvim)
- [Available Packages](https://mason-registry.dev/registry/list)
- [Neovim LSP Guide](https://neovim.io/doc/user/lsp.html)

## Quick Reference

```vim
" Install a package
:MasonInstall pyright

" Open UI
:Mason

" Check health
:checkhealth mason

" View logs
:MasonLog

" Update registry
:MasonUpdate

" LSP info for current buffer
:LspInfo

" LSP restart
:LspRestart
```
