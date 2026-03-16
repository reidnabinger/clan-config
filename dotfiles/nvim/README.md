# Neovim Configuration with Mason LSP Auto-Installation

## 📚 Documentation Index

| Document | Purpose |
|----------|---------|
| **[MASON_SETUP.md](MASON_SETUP.md)** | Complete setup guide and technical details |
| **[MASON_QUICK_REFERENCE.md](MASON_QUICK_REFERENCE.md)** | Keybindings cheat sheet and quick commands |
| **[TEST_MASON.md](TEST_MASON.md)** | How to test your setup with example files |

## 🚀 Quick Start

### First Launch
```bash
nvim
# Mason will auto-install configured LSP servers
```

### Test With Sample Files
```bash
nvim /tmp/lsp_test/test.py   # Python + pyright
nvim /tmp/lsp_test/test.sh   # Bash + bashls
nvim /tmp/lsp_test/test.c    # C/C++ + clangd
nvim /tmp/lsp_test/test.nix  # Nix + nil_ls
```

### Essential Commands
```vim
:Mason          " Open package manager
:LspInfo        " Check LSP status
:checkhealth    " Verify setup
```

## 📦 Installed LSP Servers

| Language | Server | Features |
|----------|--------|----------|
| **Bash/Shell** | bashls | Shellcheck integration |
| **C/C++** | clangd | Source/header switching, clang-tidy |
| **Python** | pyright | Type checking, organize imports |
| **Nix** | nil_ls | Flake support, nixpkgs-fmt |

## ⌨️ Most Used Keybindings

### Mason
- `<leader>m` - Open Mason UI
- `<leader>mi` - Install package

### LSP Navigation
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>cf` - Format buffer

### Diagnostics
- `[d` / `]d` - Next/previous diagnostic
- `<leader>d` - Show diagnostic

## 🎯 Next Steps

### 1. Add More LSP Servers
Edit `lua/plugins/mason-lspconfig.lua`:
```lua
ensure_installed = {
  'bashls',
  'clangd',
  'pyright',
  'nil_ls',
  'rust_analyzer',  -- Add Rust
  'ts_ls',          -- Add TypeScript
  'gopls',          -- Add Go
}
```

### 2. Install Formatters/Linters
```vim
:MasonInstall prettier black stylua shellcheck
```

### 3. Customize LSP Behavior
Edit `lua/lsp/init.lua` for global settings or
`lua/lsp/servers/*.lua` for server-specific configs.

## 🔧 Configuration Structure

```
~/.config/nvim/
├── init.lua                   # Entry point
├── lua/
│   ├── core/
│   │   ├── lazy.lua          # Plugin manager
│   │   ├── options.lua       # Neovim options
│   │   └── keymaps.lua       # Global keybindings
│   ├── lsp/
│   │   ├── init.lua          # LSP global config
│   │   └── servers/          # Per-server settings
│   │       ├── bashls.lua
│   │       ├── clangd.lua
│   │       ├── pyright.lua
│   │       └── nil_ls.lua
│   └── plugins/
│       ├── mason.lua         # Mason base config
│       ├── mason-lspconfig.lua  # LSP auto-install
│       ├── lspconfig.lua     # Plugin loader
│       ├── cmp.lua           # Completion
│       └── ...               # Other plugins
├── MASON_SETUP.md            # Full documentation
├── MASON_QUICK_REFERENCE.md  # Cheat sheet
└── TEST_MASON.md             # Testing guide
```

## 🐛 Troubleshooting

### LSP Not Working
```vim
:LspInfo                   " Check if attached
:Mason                     " Verify installation
:MasonLog                  " View error logs
:checkhealth mason         " Health check
```

### Server Not Installing
```vim
:MasonLog                  " Check what failed
:Mason                     " Manual reinstall (X then i)
```

### Config Not Loading
```vim
:Lazy                      " Check plugin status
:messages                  " View error messages
```

## 📖 Resources

- **Mason Registry**: https://mason-registry.dev/registry/list
- **LSP Configs**: https://github.com/neovim/nvim-lspconfig
- **Neovim LSP Docs**: `:help lsp`
- **This Setup's Docs**: See MASON_SETUP.md

## 💡 Pro Tips

1. **Use `:Mason` to browse** available packages (500+ tools!)
2. **Check `:LspInfo`** to see which servers are active
3. **Press `K` twice** for hover help when cursor on symbol
4. **Use `<leader>ca`** often - code actions are powerful
5. **`:LspRestart`** if server misbehaves

## 🎨 Customization Examples

### Add a New Language Server
```lua
-- In lua/plugins/mason-lspconfig.lua
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = { command = 'clippy' },
    },
  },
})
```

### Change Diagnostic Display
```lua
-- In lua/lsp/init.lua
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline diagnostics
  signs = true,
  float = { border = 'rounded' },
})
```

## ✨ What Makes This Setup Special

- ✅ **Automatic installation** - No manual setup
- ✅ **Modern API** - Uses Neovim 0.11+ native LSP
- ✅ **Preserved customizations** - All your server configs intact
- ✅ **Easy to extend** - Just add to ensure_installed
- ✅ **Well documented** - Multiple guides included
- ✅ **Production ready** - Based on 2025 best practices

---

**Questions?** Check the documentation files or run `:checkhealth mason`
