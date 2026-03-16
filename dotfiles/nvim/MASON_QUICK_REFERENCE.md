# Mason Quick Reference Card

## 🚀 Daily Commands

```vim
:Mason                    " Open package manager UI
:MasonInstall <package>   " Install specific package
:MasonUpdate              " Update package registry
:LspInfo                  " Show active LSP clients
:LspRestart               " Restart LSP servers
```

## ⌨️ Keybindings Cheat Sheet

### Mason UI
| Key | Action |
|-----|--------|
| `<leader>m` | Open Mason |
| `<leader>mi` | Install prompt |
| `<leader>mu` | Update registry |

### Inside :Mason UI
| Key | Action |
|-----|--------|
| `i` | Install package |
| `u` | Update package |
| `U` | Update ALL |
| `X` | Uninstall |
| `c` | Check version |
| `C` | Check outdated |
| `<CR>` | Toggle details |
| `g?` | Help |
| `/` | Search |
| `<C-f>` | Filter by language |

### LSP Navigation
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help |

### LSP Actions
| Key | Action |
|-----|--------|
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>cf` | Format buffer |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>d` | Show diagnostic float |

### Language-Specific
| Key | Language | Action |
|-----|----------|--------|
| `<leader>cs` | C/C++ | Switch source/header |
| `<leader>ci` | Python | Organize imports |
| `<leader>nf` | Nix | Format with nixpkgs-fmt |
| `<leader>ne` | Nix | Evaluate expression |

## 📦 Popular Packages to Add

### Language Servers
```vim
:MasonInstall rust-analyzer      " Rust
:MasonInstall typescript-language-server  " TypeScript/JS
:MasonInstall gopls              " Go
:MasonInstall lua-language-server  " Lua
:MasonInstall yaml-language-server  " YAML
:MasonInstall json-lsp           " JSON
```

### Formatters
```vim
:MasonInstall stylua             " Lua formatter
:MasonInstall prettier           " JS/TS/JSON/YAML/etc
:MasonInstall black              " Python formatter
:MasonInstall shfmt              " Shell script formatter
```

### Linters
```vim
:MasonInstall shellcheck         " Shell script linter
:MasonInstall eslint_d           " Fast JS/TS linter
:MasonInstall ruff               " Fast Python linter
```

## 🔧 Common Tasks

### Install Multiple Packages at Once
```vim
:MasonInstall rust-analyzer gopls lua-language-server prettier
```

### Check What's Installed
```vim
:Mason
" Press 'C' to check for outdated packages
```

### Update Everything
```vim
:Mason
" Press 'U' (Shift+u) to update all packages
```

### Troubleshoot Installation
```vim
:MasonLog                " View installation logs
:checkhealth mason       " Check Mason health
:LspInfo                 " Check active LSP clients
```

### Manually Trigger LSP Attach
If LSP doesn't auto-start:
```vim
:edit                    " Reload current buffer
:LspRestart              " Restart LSP
```

## 🎯 Pro Tips

### 1. Bulk Install on New Machine
Add to your `ensure_installed` list in `mason-lspconfig.lua`, then:
```vim
:Lazy sync               " Sync plugins
" Mason will auto-install all listed servers
```

### 2. Check Server Status
```vim
:LspInfo                 " Shows which servers are active
:LspLog                  " View LSP communication logs
```

### 3. Install Without Opening Mason UI
```vim
:MasonInstall rust-analyzer gopls prettier
" Space-separated list
```

### 4. Find Package Names
```vim
:Mason
" Press '/' to search
" Or browse https://mason-registry.dev/registry/list
```

### 5. PATH Verification
Mason adds to PATH automatically. Verify:
```vim
:echo $PATH
" Should include ~/.local/share/nvim/mason/bin
```

## 🐛 Troubleshooting Quick Fixes

### LSP Not Starting
```vim
1. :LspInfo              " Check if attached
2. :Mason                " Verify installation
3. :MasonLog             " Check for errors
4. :edit                 " Reload buffer
```

### Installation Failed
```vim
1. :Mason                " Open UI
2. Find package, press 'X' to uninstall
3. Press 'i' to reinstall
4. :MasonLog             " Check error details
```

### Server Outdated
```vim
:Mason
" Navigate to package, press 'u' to update
```

### Clear Cache
```bash
# Outside nvim, in terminal:
rm -rf ~/.local/share/nvim/mason
# Then restart nvim - will reinstall everything
```

## 📚 Useful Links

- [Mason Registry](https://mason-registry.dev/registry/list) - Browse all packages
- [LSP Configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Mason GitHub](https://github.com/williamboman/mason.nvim)
- [Neovim LSP Docs](https://neovim.io/doc/user/lsp.html)

## 🎨 Configuration Locations

```
~/.config/nvim/
├── lua/plugins/
│   ├── mason.lua              # Mason base config
│   ├── mason-lspconfig.lua    # Server configurations
│   └── lspconfig.lua          # Plugin loader
├── lua/lsp/
│   ├── init.lua               # Shared LSP config
│   └── servers/               # Server-specific settings
└── MASON_SETUP.md             # Full documentation
```

## 💡 Example Workflow

1. **Open a file**: `nvim main.rs`
2. **Server auto-installs** (first time only)
3. **Use LSP features**:
   - Hover: `K`
   - Go to definition: `gd`
   - Rename: `<leader>rn`
   - Format: `<leader>cf`
4. **Add more tools**: `:Mason` → find rustfmt → press `i`

---

**Remember**: All tools managed by Mason are available system-wide within Neovim, but NOT outside of it (unless you add mason/bin to your shell's PATH).
