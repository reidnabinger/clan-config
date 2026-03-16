-- TreeSJ - Split/Join code blocks intelligently using treesitter
-- Split single-line code to multi-line, or join multi-line to single-line

return {
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',  -- Load on startup, but lazily
    keys = {
      { '<leader>j', function() require('treesj').toggle({split = {recursive = true}}) end, desc = 'Toggle split/join recursive' },
      { '<leader>J', function() require('treesj').split() end, desc = 'Split code block' },
      { 'gJ', function() require('treesj').join() end, desc = 'Join code block' },
    },
    opts = {
      use_default_keymaps = false,
      check_syntax_error = true,
      max_join_length = 4096,
      cursor_behavior = 'hold',
      notify = true,
      dot_repeat = true,
    },
    config = function(_, opts)
      require('treesj').setup(opts)
    end,
  },
}
