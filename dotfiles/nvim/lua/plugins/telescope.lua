-- Telescope fuzzy finder
-- Essential for modern file/text navigation

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        -- Native FZF sorter for better performance
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
    cmd = 'Telescope',  -- Lazy load on command
    keys = {
      -- File pickers
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
      { '<leader>fa', '<cmd>Telescope find_files hidden=true no_ignore=true<cr>', desc = 'Find all files' },

      -- Grep and search
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
      { '<leader>fw', '<cmd>Telescope grep_string<cr>', desc = 'Grep word under cursor' },

      -- Buffers and navigation
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
      { '<leader>fm', '<cmd>Telescope man_pages<cr>', desc = 'Man pages' },

      -- Git integration
      { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Git commits' },
      { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'Git branches' },
      { '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'Git status' },

      -- LSP and diagnostics (will be useful when LSP is configured)
      { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = 'Diagnostics' },
      { '<leader>fs', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Document symbols' },
      { '<leader>fS', '<cmd>Telescope lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },

      -- Vim internals
      { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
      { '<leader>fo', '<cmd>Telescope vim_options<cr>', desc = 'Vim options' },
      { '<leader>fc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
      { '<leader>fq', '<cmd>Telescope quickfix<cr>', desc = 'Quickfix' },
    },
    opts = function()
      local actions = require('telescope.actions')

      return {
        defaults = {
          prompt_prefix = '🔍 ',
          selection_caret = '➜ ',
          path_display = { 'truncate' },
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          -- Key mappings within telescope
          mappings = {
            i = {
              ['<C-n>'] = actions.move_selection_next,
              ['<C-p>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-c>'] = actions.close,
              ['<Esc>'] = actions.close,
              ['<CR>'] = actions.select_default,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
              ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = {
              ['q'] = actions.close,
              ['<Esc>'] = actions.close,
              ['<CR>'] = actions.select_default,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
              ['j'] = actions.move_selection_next,
              ['k'] = actions.move_selection_previous,
              ['H'] = actions.move_to_top,
              ['M'] = actions.move_to_middle,
              ['L'] = actions.move_to_bottom,
              ['gg'] = actions.move_to_top,
              ['G'] = actions.move_to_bottom,
              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
              ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },

          -- File ignore patterns
          file_ignore_patterns = {
            'node_modules',
            '.git/',
            '%.pyc',
            '__pycache__',
            '%.o',
            '%.a',
            '%.out',
            '%.class',
            '%.pdf',
            '%.mkv',
            '%.mp4',
            '%.zip',
          },

          -- Better color scheme integration
          winblend = 0,
          border = {},
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          color_devicons = true,
          set_env = { ['COLORTERM'] = 'truecolor' },
        },

        pickers = {
          find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
          },
          live_grep = {
            additional_args = function()
              return { '--hidden', '--glob', '!.git/*' }
            end,
          },
          buffers = {
            sort_lastused = true,
            sort_mru = true,
            mappings = {
              i = {
                ['<C-d>'] = actions.delete_buffer,
              },
              n = {
                ['dd'] = actions.delete_buffer,
              },
            },
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)

      -- Load fzf extension if available
      pcall(telescope.load_extension, 'fzf')
    end,
  },
}
