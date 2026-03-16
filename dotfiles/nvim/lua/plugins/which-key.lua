-- which-key.nvim - Interactive keymap discovery
-- Shows available keybindings in a popup as you type

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      delay = 500, -- Delay before showing the popup (ms)
      plugins = {
        marks = true,     -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
          enabled = true,   -- z= to select spelling suggestions
          suggestions = 20,
        },
        presets = {
          operators = true,    -- adds help for operators like d, y, c
          motions = true,      -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true,      -- default bindings on <c-w>
          nav = true,          -- misc bindings to work with windows
          z = true,            -- bindings for folds, spelling and others prefixed with z
          g = true,            -- bindings for prefixed with g
        },
      },
      -- Icons for different key types
      icons = {
        breadcrumb = '»',
        separator = '→',
        group = '+',
        ellipsis = '…',
        mappings = true,
        keys = {
          Up = '↑',
          Down = '↓',
          Left = '←',
          Right = '→',
          C = 'Ctrl-',
          M = 'Alt-',
          D = 'Cmd-',
          S = 'Shift-',
          CR = '↵',
          Esc = 'Esc',
          ScrollWheelDown = '🖱️↓',
          ScrollWheelUp = '🖱️↑',
          NL = '↵',
          BS = '⌫',
          Space = '␣',
          Tab = '⭾',
          F1 = 'F1',
          F2 = 'F2',
          F3 = 'F3',
          F4 = 'F4',
          F5 = 'F5',
          F6 = 'F6',
          F7 = 'F7',
          F8 = 'F8',
          F9 = 'F9',
          F10 = 'F10',
          F11 = 'F11',
          F12 = 'F12',
        },
      },
      win = {
        border = 'rounded',
        padding = { 1, 2 },
      },
      layout = {
        spacing = 3,
      },
      show_help = true,
      show_keys = true,
      disable = {
        buftypes = {},
        filetypes = {},
      },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)

      -- Register leader key groups with descriptions
      wk.add({
        -- Top-level groups
        { '<leader>b', group = 'Buffer' },
        { '<leader>c', group = 'Code/Compile' },
        { '<leader>d', group = 'Diagnostics' },
        { '<leader>f', group = 'Find/Telescope' },
        { '<leader>g', group = 'Git' },
        { '<leader>l', group = 'Lazy (plugins)' },
        { '<leader>n', group = 'Nix' },
        { '<leader>p', group = 'Python' },
        { '<leader>r', group = 'Rename/Refactor' },
        { '<leader>s', group = 'Shell/Script' },
        { '<leader>t', group = 'Tab/Treesitter' },
        { '<leader>w', group = 'Workspace' },

        -- Additional helpful groupings
        { 'g', group = 'Go to' },
        { 'z', group = 'Folds/Spelling' },
        { ']', group = 'Next' },
        { '[', group = 'Previous' },

        -- Surround operations
        { 'y', group = 'Yank/Surround' },
        { 'd', group = 'Delete/Surround' },
        { 'c', group = 'Change/Surround' },
        { '<leader>j', group = 'Join/Split' },

        -- Visual mode groups
        { '<leader>c', group = 'Code', mode = 'v' },
        { '<leader>g', group = 'Git', mode = 'v' },
        { 'S', desc = 'Surround selection', mode = 'v' },
      })
    end,
  },
}
