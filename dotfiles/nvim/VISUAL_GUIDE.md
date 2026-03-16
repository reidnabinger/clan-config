# Visual Configuration Guide

## 📁 Your New Configuration Structure

```
~/.config/nvim/
│
├── 📄 init.lua                      # Entry point - loads everything
├── 📘 README.md                     # Quick start guide
├── 📗 MASON_SETUP.md                # Complete setup documentation
├── 📙 MASON_QUICK_REFERENCE.md      # Keybinding cheat sheet
├── 📕 TEST_MASON.md                 # Testing guide
├── 📔 ADVANCED_TIPS.md              # Power user tips
├── 📓 VISUAL_GUIDE.md               # This file
│
├── 📂 lua/
│   ├── 📂 core/                     # Core Neovim configuration
│   │   ├── lazy.lua                 # 🔌 Plugin manager setup
│   │   ├── options.lua              # ⚙️  Neovim options (tabs, UI, etc)
│   │   ├── keymaps.lua              # ⌨️  Global keybindings
│   │   ├── autocmds.lua             # 🔄 Auto-commands
│   │   ├── filetypes.lua            # 📝 Filetype detection
│   │   └── statusline.lua           # 📊 Statusline config
│   │
│   ├── 📂 lsp/                      # LSP Configuration Hub
│   │   ├── init.lua                 # 🌟 GLOBAL LSP CONFIG
│   │   │                            #    - on_attach (keybindings)
│   │   │                            #    - capabilities (nvim-cmp)
│   │   │                            #    - diagnostics UI
│   │   │                            #    - floating windows
│   │   │
│   │   └── 📂 servers/              # Per-server settings
│   │       ├── bashls.lua           # ⚡ Bash: shellcheck config
│   │       ├── clangd.lua           # ⚡ C/C++: compile flags
│   │       ├── pyright.lua          # ⚡ Python: type checking
│   │       └── nil_ls.lua           # ⚡ Nix: flake settings
│   │
│   └── 📂 plugins/                  # Plugin Specifications
│       ├── 🔷 mason.lua             # Package manager
│       ├── 🔷 mason-lspconfig.lua   # LSP auto-install bridge
│       ├── 🔷 lspconfig.lua         # LSP config plugin loader
│       ├── 🔷 cmp.lua               # Completion engine
│       ├── 🔷 telescope.lua         # Fuzzy finder
│       ├── 🔷 treesitter.lua        # Syntax highlighting
│       ├── 🔷 gitsigns.lua          # Git integration
│       ├── 🔷 oil.lua               # File explorer
│       ├── 🔷 which-key.lua         # Keybinding hints
│       └── ...                      # Other plugins
│
└── 📂 lazy-lock.json                # Plugin version lock file
```

## 🔄 How Configuration Loads

```
1. init.lua
   ↓
2. lua/core/lazy.lua (loads plugin manager)
   ↓
3. lua/core/options.lua (Neovim settings)
   ↓
4. lua/core/keymaps.lua (global keybindings)
   ↓
5. lua/plugins/*.lua (ALL plugin specs loaded automatically)
   │
   ├→ mason.lua (loaded FIRST - priority 1000)
   ├→ mason-lspconfig.lua (loaded SECOND - priority 900)
   ├→ lspconfig.lua
   └→ Other plugins...
   ↓
6. Mason installs LSP servers in background
   ↓
7. LSP servers become available when needed
```

## 🎯 LSP Configuration Flow

```
                    ┌─────────────────────┐
                    │  Open a file.py     │
                    └──────────┬──────────┘
                               ↓
                    ┌──────────────────────┐
                    │  Neovim detects      │
                    │  filetype = python   │
                    └──────────┬───────────┘
                               ↓
            ┌──────────────────────────────────┐
            │ mason-lspconfig checks:          │
            │ Is pyright installed?            │
            └──────────┬───────────────────────┘
                       ↓
              ┌────────┴────────┐
              │                 │
            NO│               YES│
              ↓                 ↓
    ┌─────────────────┐  ┌─────────────────┐
    │ Mason installs  │  │ Start pyright   │
    │ pyright         │  │ LSP server      │
    └────────┬────────┘  └────────┬────────┘
             ↓                    ↓
    ┌─────────────────────────────┴──────┐
    │ vim.lsp.config('pyright', {...})   │
    │ ├─ Load settings from              │
    │ │  lua/lsp/servers/pyright.lua     │
    │ ├─ Apply on_attach from            │
    │ │  lua/lsp/init.lua                │
    │ └─ Apply capabilities from         │
    │    lua/lsp/init.lua                │
    └────────────────┬───────────────────┘
                     ↓
         ┌───────────────────────┐
         │ LSP features active!  │
         │ ✓ Hover (K)          │
         │ ✓ Go to def (gd)     │
         │ ✓ Completion         │
         │ ✓ Diagnostics        │
         │ ✓ Code actions       │
         └───────────────────────┘
```

## 🛠️ Mason Installation Flow

```
When you run: :MasonInstall pyright

┌──────────────────────────┐
│ Mason Registry           │
│ (github.com/mason-org/   │
│  mason-registry)         │
└───────────┬──────────────┘
            ↓
┌──────────────────────────┐
│ Download package spec    │
│ (JSON metadata)          │
└───────────┬──────────────┘
            ↓
┌──────────────────────────┐
│ Install to:              │
│ ~/.local/share/nvim/     │
│   mason/packages/pyright/│
└───────────┬──────────────┘
            ↓
┌──────────────────────────┐
│ Create symlinks in:      │
│ ~/.local/share/nvim/     │
│   mason/bin/             │
│     ├─ pyright           │
│     └─ pyright-langserver│
└───────────┬──────────────┘
            ↓
┌──────────────────────────┐
│ Mason prepends to PATH:  │
│ $PATH = mason/bin:$PATH  │
└───────────┬──────────────┘
            ↓
┌──────────────────────────┐
│ pyright is now available │
│ to Neovim's LSP client   │
└──────────────────────────┘
```

## 📊 File Responsibility Matrix

| File | Purpose | When to Edit |
|------|---------|--------------|
| **lua/plugins/mason.lua** | Mason UI config, PATH setup | Change UI appearance, installation concurrency |
| **lua/plugins/mason-lspconfig.lua** | Server auto-install list, server configs | Add/remove LSP servers, customize server settings |
| **lua/plugins/lspconfig.lua** | Plugin loader | Rarely (just loads nvim-lspconfig) |
| **lua/lsp/init.lua** | Global LSP behavior | Change all LSP keybindings, diagnostic display, capabilities |
| **lua/lsp/servers/bashls.lua** | Bash-specific settings | Customize bashls behavior, shellcheck options |
| **lua/lsp/servers/clangd.lua** | C/C++-specific settings | Add compile flags, change clangd behavior |
| **lua/lsp/servers/pyright.lua** | Python-specific settings | Adjust type checking strictness, Python analysis |
| **lua/lsp/servers/nil_ls.lua** | Nix-specific settings | Configure Nix language server, formatting |
| **lua/core/keymaps.lua** | Global keybindings | Add Mason shortcuts, general editor bindings |

## 🎨 Customization Decision Tree

```
Want to customize LSP behavior?
│
├─ Affects ALL LSP servers?
│  └─→ Edit: lua/lsp/init.lua
│      Examples:
│      - Change keybindings (gd, K, <leader>ca)
│      - Modify diagnostic display
│      - Customize floating windows
│
├─ Affects ONE specific server?
│  └─→ Edit: lua/lsp/servers/<server>.lua
│      Examples:
│      - Python type checking strictness
│      - C++ compile flags
│      - Nix formatter command
│
├─ Add/remove LSP servers?
│  └─→ Edit: lua/plugins/mason-lspconfig.lua
│      Find: ensure_installed = { ... }
│      Add server name (lspconfig name, not Mason name!)
│
├─ Change Mason UI?
│  └─→ Edit: lua/plugins/mason.lua
│      Examples:
│      - Border style
│      - Window size
│      - Icon appearance
│      - Concurrent installs
│
└─ Add global keybindings?
   └─→ Edit: lua/core/keymaps.lua
       Examples:
       - <leader>m for Mason
       - LSP workspace management
       - Diagnostic navigation
```

## 🔍 Where Things Live

### LSP Server Executables
```
~/.local/share/nvim/mason/
├── bin/                    # Symlinks to all tools
│   ├── bash-language-server
│   ├── clangd
│   ├── pyright
│   ├── pyright-langserver
│   └── nil
│
└── packages/               # Actual installations
    ├── bash-language-server/
    ├── clangd/
    ├── pyright/
    └── nil/
```

### LSP Logs
```
~/.local/state/nvim/lsp.log    # LSP communication log
~/.local/share/nvim/mason.log  # Mason installation log
```

### Plugin Data
```
~/.local/share/nvim/lazy/      # Installed plugins
├── mason.nvim/
├── mason-lspconfig.nvim/
├── nvim-lspconfig/
├── nvim-cmp/
└── ...
```

## 🎯 Quick Edit Guide

### Add a New LSP Server

1. **Add to auto-install list**:
   ```lua
   -- Edit: lua/plugins/mason-lspconfig.lua
   ensure_installed = {
     'bashls', 'clangd', 'pyright', 'nil_ls',
     'rust_analyzer',  -- ← Add this
   }
   ```

2. **Configure the server**:
   ```lua
   -- In same file, add:
   vim.lsp.config('rust_analyzer', {
     settings = {
       ['rust-analyzer'] = {
         checkOnSave = { command = 'clippy' },
       },
     },
   })
   ```

3. **Restart Neovim**:
   ```bash
   nvim  # Will auto-install rust-analyzer
   ```

### Change Global LSP Keybinding

```lua
-- Edit: lua/lsp/init.lua
M.on_attach = function(client, bufnr)
  -- Find the keybinding you want to change, e.g.:
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, ...)
  --                  ↑ change this to something else
end
```

### Customize Diagnostic Display

```lua
-- Edit: lua/lsp/init.lua
vim.diagnostic.config({
  virtual_text = false,           -- Turn off inline text
  signs = true,                   -- Keep gutter signs
  underline = true,               -- Keep underlines
  update_in_insert = false,       -- Don't update while typing
  severity_sort = true,           -- Sort by severity
})
```

## 📈 Dependency Graph

```
init.lua
 └── core/lazy.lua
      └── plugins/ (auto-discovered)
           ├── mason.lua (priority: 1000)
           │    └── williamboman/mason.nvim
           │
           ├── mason-lspconfig.lua (priority: 900)
           │    ├── depends on: mason.nvim
           │    └── williamboman/mason-lspconfig.nvim
           │         └── loads: lsp/init.lua
           │              └── loads: lsp/servers/*.lua
           │
           ├── lspconfig.lua
           │    └── neovim/nvim-lspconfig
           │
           └── cmp.lua
                └── hrsh7th/nvim-cmp
                     └── provides: capabilities for LSP
```

## 💡 Mental Model

Think of the configuration as layers:

```
┌─────────────────────────────────────┐
│  Layer 4: Mason UI                  │  ← mason.lua
│  (Package management interface)     │
├─────────────────────────────────────┤
│  Layer 3: Mason-LSPConfig Bridge    │  ← mason-lspconfig.lua
│  (Auto-install & server config)     │
├─────────────────────────────────────┤
│  Layer 2: LSP Global Config         │  ← lsp/init.lua
│  (Shared keybindings & capabilities)│
├─────────────────────────────────────┤
│  Layer 1: Server-Specific Settings  │  ← lsp/servers/*.lua
│  (Per-language configuration)       │
├─────────────────────────────────────┤
│  Layer 0: Neovim LSP Client         │  ← Built into Neovim
│  (vim.lsp.*)                         │
└─────────────────────────────────────┘
```

Each layer builds on the one below it. You typically edit Layer 1-4, never Layer 0.

---

**Pro Tip**: Start with the visual flow diagrams above when troubleshooting. Follow the arrows to understand what's happening!
