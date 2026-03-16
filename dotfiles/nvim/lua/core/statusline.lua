-- Custom statusline
-- Native Neovim statusline without plugin overhead

local M = {}

-- Helper functions for statusline components
local function mode()
  local modes = {
    ['n'] = 'NORMAL',
    ['no'] = 'O-PENDING',
    ['nov'] = 'O-PENDING',
    ['noV'] = 'O-PENDING',
    ['no\22'] = 'O-PENDING',
    ['niI'] = 'NORMAL',
    ['niR'] = 'NORMAL',
    ['niV'] = 'NORMAL',
    ['nt'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['vs'] = 'VISUAL',
    ['V'] = 'V-LINE',
    ['Vs'] = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    ['\22s'] = 'V-BLOCK',
    ['s'] = 'SELECT',
    ['S'] = 'S-LINE',
    ['\19'] = 'S-BLOCK',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['ix'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rc'] = 'REPLACE',
    ['Rx'] = 'REPLACE',
    ['Rv'] = 'V-REPLACE',
    ['Rvc'] = 'V-REPLACE',
    ['Rvx'] = 'V-REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'EX',
    ['ce'] = 'EX',
    ['r'] = 'PROMPT',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
  }
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(' %s ', modes[current_mode] or 'UNKNOWN')
end

local function git_branch()
  -- Try to get git branch from fugitive first, then fall back to system call
  if vim.fn.exists('*FugitiveHead') == 1 then
    local branch = vim.fn.FugitiveHead()
    if branch ~= '' then
      return string.format('  %s ', branch)
    end
  end

  -- Fallback: Read from .git/HEAD
  local git_dir = vim.fn.finddir('.git', '.;')
  if git_dir ~= '' then
    local head_file = git_dir .. '/HEAD'
    local ok, head = pcall(vim.fn.readfile, head_file)
    if ok and head and head[1] then
      local branch = head[1]:match('ref: refs/heads/(.+)')
      if branch then
        return string.format('  %s ', branch)
      end
    end
  end

  return ''
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.:h')
  local fname = vim.fn.expand('%:t')

  if fpath == '' or fpath == '.' then
    return string.format(' %s ', fname ~= '' and fname or '[No Name]')
  end

  -- Show relative path
  return string.format(' %s/%s ', fpath, fname)
end

local function filetype()
  local ft = vim.bo.filetype
  if ft == '' then
    return ''
  end
  return string.format(' %s ', ft)
end

local function fileencoding()
  local enc = vim.bo.fileencoding
  if enc == '' then
    enc = vim.o.encoding
  end
  return enc ~= 'utf-8' and string.format(' %s ', enc) or ''
end

local function fileformat()
  local fmt = vim.bo.fileformat
  local icons = {
    unix = '',
    dos = '',
    mac = '',
  }
  return fmt ~= 'unix' and string.format(' %s ', icons[fmt] or fmt) or ''
end

local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then
    return ''
  end

  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end

  return string.format(' LSP[%s] ', table.concat(client_names, ','))
end

local function diagnostics()
  if not vim.diagnostic.is_enabled() then
    return ''
  end

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local parts = {}
  if errors > 0 then
    table.insert(parts, string.format('E:%d', errors))
  end
  if warnings > 0 then
    table.insert(parts, string.format('W:%d', warnings))
  end
  if hints > 0 then
    table.insert(parts, string.format('H:%d', hints))
  end
  if info > 0 then
    table.insert(parts, string.format('I:%d', info))
  end

  if #parts > 0 then
    return string.format(' %s ', table.concat(parts, ' '))
  end

  return ''
end

local function modified()
  if vim.bo.modified then
    return ' [+] '
  elseif vim.bo.modifiable == false or vim.bo.readonly then
    return ' [-] '
  end
  return ''
end

local function location()
  local line = vim.fn.line('.')
  local col = vim.fn.virtcol('.')
  local total = vim.fn.line('$')
  local percent = math.floor((line / total) * 100)
  return string.format(' %d:%d %d%%%% ', line, col, percent)
end

-- Build statusline
function M.statusline()
  local parts = {
    '%#StatusLineMode#',
    mode(),
    '%#StatusLine#',
    git_branch(),
    filepath(),
    modified(),
    '%#StatusLine#',
    '%=',  -- Right align from here
    diagnostics(),
    lsp_status(),
    filetype(),
    fileencoding(),
    fileformat(),
    '%#StatusLineLocation#',
    location(),
  }

  return table.concat(parts, '')
end

-- Setup statusline
function M.setup()
  -- Set statusline
  vim.opt.statusline = '%!v:lua.require("core.statusline").statusline()'

  -- Always show statusline
  vim.opt.laststatus = 3  -- Global statusline

  -- Define statusline highlight groups
  local function set_highlights()
    local colors = {
      bg = '#1f1f28',      -- kanagawa sumiInk1
      fg = '#dcd7ba',      -- kanagawa fujiWhite
      mode_bg = '#7e9cd8', -- kanagawa crystalBlue
      mode_fg = '#1f1f28',
      loc_bg = '#2d4f67',  -- kanagawa waveBlue2
      loc_fg = '#dcd7ba',
    }

    vim.api.nvim_set_hl(0, 'StatusLine', { bg = colors.bg, fg = colors.fg })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = colors.bg, fg = '#54546d' })
    vim.api.nvim_set_hl(0, 'StatusLineMode', { bg = colors.mode_bg, fg = colors.mode_fg, bold = true })
    vim.api.nvim_set_hl(0, 'StatusLineLocation', { bg = colors.loc_bg, fg = colors.loc_fg })
  end

  -- Set highlights on startup and colorscheme change
  set_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = set_highlights,
    desc = 'Update statusline colors',
  })
end

return M
