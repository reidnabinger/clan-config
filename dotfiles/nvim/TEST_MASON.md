# Testing Your Mason Setup

## Quick Test

Open Neovim with one of these test files:

```bash
# Test Python LSP
nvim /tmp/lsp_test/test.py

# Test Bash LSP  
nvim /tmp/lsp_test/test.sh

# Test C LSP
nvim /tmp/lsp_test/test.c

# Test Nix LSP
nvim /tmp/lsp_test/test.nix
```

## What to Expect

### First Time Opening Each File Type
1. Neovim opens
2. Mason auto-installs the LSP server (background)
3. You'll see a notification when ready
4. LSP features activate automatically

### LSP Features to Test

#### 1. Hover Documentation (K)
- Place cursor on `greet` in test.py
- Press `K`
- Should show function signature

#### 2. Go to Definition (gd)
- Place cursor on function call
- Press `gd`
- Should jump to definition

#### 3. Diagnostics
- Type something invalid
- Should see error highlights
- Press `<leader>d` to see diagnostic

#### 4. Completion
- Start typing in insert mode
- Should see completion menu (from nvim-cmp)

#### 5. Format (leader+cf)
- Mess up indentation
- Press `<leader>cf`
- Should auto-format

## Verify Installation

```vim
:Mason
" Should show installed servers with ✓ icon
```

## Check LSP Status

```vim
:LspInfo
" Should show attached language server
```

## Expected Output

When you open test.py:
```
[mason-lspconfig.nvim] Installing pyright...
[mason-lspconfig.nvim] pyright installed successfully
LSP[pyright] attached to buffer
```

## Troubleshooting

If LSP doesn't start:
```vim
:LspInfo         " Check attachment status
:Mason           " Verify installation
:MasonLog        " Check error logs
:checkhealth mason
```

If you see "Server not found":
```vim
:MasonInstall pyright
" Wait for installation, then :edit
```
