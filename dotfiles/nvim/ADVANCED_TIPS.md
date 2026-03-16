# Advanced Mason & LSP Tips

## 🎯 Power User Workflows

### 1. Bulk Server Installation for New Projects

When starting a new project with multiple languages:

```vim
" Install everything for a full-stack project
:MasonInstall lua-language-server typescript-language-server gopls rust-analyzer pyright tailwindcss-language-server json-lsp yaml-language-server

" Then install formatters/linters
:MasonInstall prettier eslint_d black ruff stylua shfmt shellcheck
```

Or edit `ensure_installed` once and let Mason handle it:
```lua
-- In lua/plugins/mason-lspconfig.lua
ensure_installed = {
  'lua_ls', 'ts_ls', 'gopls', 'rust_analyzer', 
  'pyright', 'tailwindcss', 'jsonls', 'yamlls',
}
```

### 2. Language-Specific Optimizations

#### Python Performance Boost
```lua
-- In lua/lsp/servers/pyright.lua
M.settings = {
  python = {
    analysis = {
      typeCheckingMode = 'basic',  -- or 'strict' for max checking
      autoImportCompletions = true,
      useLibraryCodeForTypes = true,
      autoSearchPaths = true,
      -- Performance: Exclude large directories
      exclude = {
        '**/node_modules',
        '**/__pycache__',
        '.git',
        'venv',
        '.venv',
      },
    },
  },
}
```

#### C/C++ Compile Commands
Create `compile_commands.json` for better clangd accuracy:
```bash
# CMake projects
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .

# Make projects  
bear -- make

# Meson
meson setup builddir --backend ninja
```

#### Rust Analyzer Optimization
```lua
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = 'clippy',
        extraArgs = { '--all-features' },
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
```

### 3. Multi-Root Workspace Setup

For monorepo projects:
```vim
" Add multiple workspace folders
:lua vim.lsp.buf.add_workspace_folder()

" List current workspace folders
:lua vim.print(vim.lsp.buf.list_workspace_folders())

" Remove a workspace folder
:lua vim.lsp.buf.remove_workspace_folder()
```

### 4. Custom LSP Handlers

Add to `lua/lsp/init.lua` for better UX:

```lua
-- Better hover window
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = 'rounded',
    max_width = 80,
    max_height = 20,
  }
)

-- Better signature help
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    border = 'rounded',
    focusable = false,
    relative = 'cursor',
  }
)

-- Custom diagnostic display
vim.diagnostic.config({
  virtual_text = {
    prefix = '■',
    source = 'if_many',
  },
  float = {
    source = 'always',
    border = 'rounded',
  },
  severity_sort = true,
  update_in_insert = false,
})
```

### 5. Conditional LSP by Project

Different configs for work vs personal projects:

```lua
-- In lua/plugins/mason-lspconfig.lua
local function get_project_lsp_config()
  local cwd = vim.fn.getcwd()
  
  -- Work projects use stricter settings
  if cwd:match('/work/') then
    return {
      python = {
        analysis = {
          typeCheckingMode = 'strict',
          reportUnusedVariable = 'error',
        },
      },
    }
  end
  
  -- Personal projects are more relaxed
  return {
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        reportUnusedVariable = 'warning',
      },
    },
  }
end

vim.lsp.config('pyright', {
  settings = get_project_lsp_config(),
})
```

### 6. LSP Performance Monitoring

Add performance tracking:

```lua
-- In lua/lsp/init.lua
M.on_attach = function(client, bufnr)
  -- Track LSP attach time
  local start_time = vim.loop.hrtime()
  
  -- Your existing on_attach code...
  
  local elapsed = (vim.loop.hrtime() - start_time) / 1e6
  vim.notify(
    string.format('LSP[%s] attached in %.2fms', client.name, elapsed),
    vim.log.levels.INFO
  )
end
```

## 🔧 Advanced Keybindings

Add to `lua/core/keymaps.lua`:

```lua
-- LSP Workspace management
keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder' })
keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace folder' })
keymap('n', '<leader>wl', function()
  vim.print(vim.lsp.buf.list_workspace_folders())
end, { desc = 'List workspace folders' })

-- Diagnostic navigation with count
keymap('n', '[d', function()
  vim.diagnostic.goto_prev({ float = { border = 'rounded' } })
end, { desc = 'Previous diagnostic' })

keymap('n', ']d', function()
  vim.diagnostic.goto_next({ float = { border = 'rounded' } })
end, { desc = 'Next diagnostic' })

-- Show diagnostics in location list
keymap('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Diagnostics to location list' })

-- Restart LSP for current buffer
keymap('n', '<leader>lr', ':LspRestart<CR>', { desc = 'Restart LSP' })

-- LSP info
keymap('n', '<leader>li', ':LspInfo<CR>', { desc = 'LSP info' })
```

## 🚀 Integration with Other Tools

### Formatter Integration (conform.nvim)

```lua
-- lua/plugins/conform.lua
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'black' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
```

Then install formatters:
```vim
:MasonInstall stylua black ruff prettier shfmt
```

### Linter Integration (nvim-lint)

```lua
-- lua/plugins/lint.lua
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    
    lint.linters_by_ft = {
      python = { 'ruff', 'mypy' },
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      sh = { 'shellcheck' },
    }
    
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
```

Install linters:
```vim
:MasonInstall ruff mypy eslint_d shellcheck
```

## 📊 Debugging LSP Issues

### Enable LSP Logging

```lua
-- In init.lua or lua/core/options.lua
vim.lsp.set_log_level('DEBUG')  -- 'TRACE' for even more detail
```

View logs:
```vim
:LspLog
" or
:edit ~/.local/state/nvim/lsp.log
```

### Check LSP Communication

```lua
-- Add to lua/lsp/init.lua for debugging
M.on_attach = function(client, bufnr)
  -- Log all LSP capabilities
  vim.notify(
    'LSP Capabilities: ' .. vim.inspect(client.server_capabilities),
    vim.log.levels.DEBUG
  )
  
  -- Your existing on_attach code...
end
```

### Performance Profiling

```vim
" Start profiling
:profile start profile.log
:profile func *
:profile file *

" Do your LSP operations...

" Stop profiling
:profile pause
:noautocmd qall!
```

## 🎨 Statusline Integration

Show active LSP in statusline:

```lua
-- In lua/core/statusline.lua or your statusline config
local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end
  
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  
  return '  LSP[' .. table.concat(names, ',') .. ']'
end
```

## 🔄 Auto-Update Workflow

Create a weekly update routine:

```vim
" Update everything
:Lazy sync        " Update plugins
:Mason            " Then press 'U' to update all packages
:checkhealth      " Verify everything works
```

Or automate it:

```lua
-- Auto-check for Mason updates weekly
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local last_check = vim.fn.stdpath('data') .. '/mason_last_check'
    local current_time = os.time()
    
    local file = io.open(last_check, 'r')
    local should_check = true
    
    if file then
      local last_time = tonumber(file:read('*a'))
      file:close()
      -- Check once per week (604800 seconds)
      should_check = (current_time - last_time) > 604800
    end
    
    if should_check then
      vim.notify('Checking for Mason package updates...', vim.log.levels.INFO)
      vim.cmd('MasonUpdate')
      
      file = io.open(last_check, 'w')
      if file then
        file:write(tostring(current_time))
        file:close()
      end
    end
  end,
})
```

## 💡 Pro Tips

1. **Use `:LspInfo`** regularly to see which servers are active
2. **Check `:checkhealth lsp`** for common configuration issues
3. **`:LspRestart`** often fixes mysterious LSP bugs
4. **Use `:Mason`** to discover new tools (500+ available!)
5. **Monitor `:LspLog`** when debugging server issues
6. **Pin versions** for critical production environments
7. **Batch install** related tools together for consistency
8. **Use workspaces** for monorepo projects
9. **Configure per-project** with `.nvim.lua` in project root
10. **Keep formatters separate** from LSP for better control

## 🎯 Common Patterns

### Pattern: Language Ecosystem Setup

When adding a new language, install the full ecosystem:

```vim
" Rust example
:MasonInstall rust-analyzer     " LSP
:MasonInstall rustfmt           " Formatter
:MasonInstall rust-analyzer     " Already includes clippy

" TypeScript example
:MasonInstall typescript-language-server   " LSP
:MasonInstall prettier                     " Formatter
:MasonInstall eslint_d                     " Linter
```

### Pattern: Project-Specific Config

Create `.nvim.lua` in project root:

```lua
-- .nvim.lua in project root
vim.lsp.config('pyright', {
  settings = {
    python = {
      pythonPath = '.venv/bin/python',
      analysis = {
        typeCheckingMode = 'strict',
        extraPaths = { './src' },
      },
    },
  },
})
```

Then load it:
```lua
-- In init.lua
vim.opt.exrc = true    -- Load .nvim.lua from current directory
vim.opt.secure = true  -- Restrict what .nvim.lua can do
```

---

**Remember**: LSP is a tool to help you code faster. Don't over-configure - start simple and add as needed!
