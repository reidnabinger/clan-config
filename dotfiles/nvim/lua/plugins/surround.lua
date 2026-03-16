-- nvim-surround - Manipulate surrounding delimiters
-- Add, change, delete surrounding quotes, brackets, tags, etc.

return {
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    opts = {
      keymaps = {
        insert = '<C-g>s',
        insert_line = '<C-g>S',
        normal = 'ys',
        normal_cur = 'yss',
        normal_line = 'yS',
        normal_cur_line = 'ySS',
        visual = 'S',
        visual_line = 'gS',
        delete = 'ds',
        change = 'cs',
        change_line = 'cS',
      },
      aliases = {
        ['a'] = '>',  -- Angle brackets
        ['b'] = ')',  -- Parentheses
        ['B'] = '}',  -- Curly braces
        ['r'] = ']',  -- Square brackets
        ['q'] = { '"', "'", '`' }, -- Quotes
      },
      highlight = {
        duration = 200,
      },
      move_cursor = 'begin',
      indent_lines = function(start, stop)
        local b = vim.bo
        return start < stop and (b.autoindent or b.smartindent or b.cindent)
      end,
    },
  },
}
