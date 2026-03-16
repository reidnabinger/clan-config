return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = { 'mason.nvim' },
  lazy = false,
  priority = 900,
  config = function()
    local lsp = require('lsp')
    
    require('mason-lspconfig').setup({
      ensure_installed = {
        'bashls',
        'clangd',
        'pyright',
        'nixd',
        'jsonls',
        'yamlls',
      },
      automatic_installation = true,
    })
    
    vim.lsp.config('*', {
      on_attach = lsp.on_attach,
      capabilities = lsp.capabilities,
    })
    
    local bashls_config = require('lsp.servers.bashls')
    vim.lsp.config('bashls', {
      cmd = { 'bash-language-server', 'start' },
      filetypes = { 'sh', 'bash', 'zsh' },
      root_markers = { '.git', '.bashrc', '.zshrc' },
      settings = bashls_config.settings,
    })
    
    local clangd_config = require('lsp.servers.clangd')
    vim.lsp.config('clangd', {
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
      },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
      root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac',
        '.git',
      },
      capabilities = vim.tbl_deep_extend('force', lsp.capabilities, {
        textDocument = {
          completion = {
            completionItem = {
              snippetSupport = true,
            },
          },
        },
        offsetEncoding = { 'utf-16' },
      }),
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', '<leader>cs', ':ClangdSwitchSourceHeader<CR>',
          vim.tbl_extend('force', opts, { desc = 'Switch source/header' }))
      end,
    })
    
    vim.api.nvim_create_user_command('ClangdSwitchSourceHeader', function()
      vim.cmd('ClangdSwitchSourceHeader')
    end, { desc = 'Switch between source and header file' })
    
    local pyright_config = require('lsp.servers.pyright')
    vim.lsp.config('pyright', {
      cmd = { 'pyright-langserver', '--stdio' },
      filetypes = { 'python' },
      root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
      },
      settings = pyright_config.settings,
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set('n', '<leader>ci', function()
          vim.lsp.buf.code_action({
            context = { only = { 'source.organizeImports' } },
            apply = true,
          })
        end, vim.tbl_extend('force', opts, { desc = 'Organize imports' }))
      end,
    })
    
    vim.lsp.config('nixd', {
      cmd = { 'nixd' },
      filetypes = { 'nix' },
      root_markers = { 'flake.nix', 'default.nix', 'shell.nix', '.git' },
      settings = {
        nixd = {
          nixpkgs = {
            expr = 'import <nixpkgs> {}',
          },
          formatting = {
            command = { 'nixpkgs-fmt' },
          },
        },
      },
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set('n', '<leader>ne', function()
          vim.cmd('write')
          local file = vim.fn.expand('%')
          vim.cmd('!nix-instantiate --eval ' .. file)
        end, vim.tbl_extend('force', opts, { desc = 'Evaluate Nix expression' }))
      end,
    })

    -- JSON Language Server with SchemaStore integration
    vim.lsp.config('jsonls', {
      cmd = { 'vscode-json-language-server', '--stdio' },
      filetypes = { 'json', 'jsonc' },
      root_markers = { '.git' },
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
      end,
    })

    -- YAML Language Server with SchemaStore integration
    vim.lsp.config('yamlls', {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
      root_markers = { '.git' },
      settings = {
        yaml = {
          schemaStore = {
            enable = false, -- Disable built-in schema store to use schemastore.nvim
            url = '',
          },
          schemas = require('schemastore').yaml.schemas(),
          validate = true,
          completion = true,
          hover = true,
        },
      },
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
      end,
    })
  end,
}
