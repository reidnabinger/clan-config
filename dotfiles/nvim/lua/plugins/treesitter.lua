-- Treesitter configuration
-- Modern syntax highlighting and code understanding

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      -- Additional textobjects for better navigation
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    cmd = {
      'TSUpdate',
      'TSInstall',
      'TSBufEnable',
      'TSBufDisable',
      'TSModuleInfo',
    },
    keys = {
      { '<leader>tt', '<cmd>TSToggle highlight<CR>', desc = 'Toggle treesitter highlight' },
      { '<leader>ti', '<cmd>TSInstallInfo<CR>', desc = 'Treesitter install info' },
    },
    opts = {
      -- Install parsers for your primary languages
      ensure_installed = {
        'bash',
        'c',
        'lua',
        'python',
        'nix',
        'vim',
        'vimdoc',
        'markdown',
        'markdown_inline',
        'regex',
        'json',
        'yaml',
        'toml',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'diff',
        'make',
      },

      -- Auto-install missing parsers when entering buffer
      auto_install = true,

      -- Syntax highlighting
      highlight = {
        enable = true,
        -- Disable for large files
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },

      -- Indentation based on treesitter
      indent = {
        enable = true,
        disable = { 'python' },  -- Python indentation is tricky
      },

      -- Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          scope_incremental = '<S-CR>',
          node_decremental = '<BS>',
        },
      },

      -- Textobjects configuration
      textobjects = {
        select = {
          enable = true,
          lookahead = true,  -- Automatically jump forward to textobj
          keymaps = {
            -- Functions
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            -- Classes
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            -- Conditionals
            ['ai'] = '@conditional.outer',
            ['ii'] = '@conditional.inner',
            -- Loops
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
            -- Parameters/arguments
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            -- Comments
            ['a/'] = '@comment.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true,  -- Add to jumplist
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
            [']a'] = '@parameter.inner',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
            [']A'] = '@parameter.inner',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
            ['[a'] = '@parameter.inner',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
            ['[A'] = '@parameter.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- Set foldmethod to treesitter
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  },
}
